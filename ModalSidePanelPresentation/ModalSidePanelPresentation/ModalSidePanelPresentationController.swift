//
//  ModalSidePanelPresentationController.swift
//
//  Created by Oliver Drobnik on 22/06/16.
//  Copyright © 2016 Cocoanetics. All rights reserved.
//

import UIKit

/// A presentation controller that presents a modal VC right of the presenting VC which gets shrunken a bit
class ModalSidePanelPresentationController: UIPresentationController
{
	// MARK: - Properties
	
	// The gradient behind both view controllers
	var backgroundView: UIView!
	
	// original superview of the presentingViewController
	var presentingViewSuperview: UIView!
	
	// gives the current direction of the animation
	var isPresenting: Bool = false
	
	// how many points are "sticking out from the side of the presenting view"
	var widthVisibleOfPresentingView: CGFloat = 60
	
	// the distance between the presenting and presented view
	var paddingWidth: CGFloat = 40
	
	// the percentage by which the presenting view will be scaled
	var presentationScalePercent: CGFloat = 0.85
	
	// MARK: - Methods
	
	override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
		super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
		
		// style needs to be custom so that the presentationController transitioning delegate method is being called
		presentedViewController.modalPresentationStyle = .Custom;
	}
	
	override func containerViewWillLayoutSubviews()
	{
		super.containerViewWillLayoutSubviews()
	}
	
	override func containerViewDidLayoutSubviews()
	{
		super.containerViewDidLayoutSubviews()
	
		if isPresenting
		{
			let view = presentingViewController.view
			// set the scale first
			view.transform = CGAffineTransformMakeScale(self.presentationScalePercent, self.presentationScalePercent)
			
			// adjust the frame position
			var frame = view.frame
			frame.origin.x = CGRectGetMaxX(self.containerView!.frame) - self.widthVisibleOfPresentingView
			view.frame = frame
		}
	}
	
	override func frameOfPresentedViewInContainerView() -> CGRect
	{
		let bounds = containerView!.bounds
		
		return CGRect(x: 0, y: bounds.size.height * (1.0 - presentationScalePercent)/2.0,
		              width: bounds.size.width - widthVisibleOfPresentingView - paddingWidth,
		              height: bounds.size.height * presentationScalePercent)
	}
	
	override func presentationTransitionWillBegin()
	{
		super.presentationTransitionWillBegin()
		
		isPresenting = true
	}
	
	override func presentationTransitionDidEnd(completed: Bool)
	{
		super.presentationTransitionDidEnd(completed)
	}
	
	override func dismissalTransitionWillBegin()
	{
		super.dismissalTransitionWillBegin()
		
		isPresenting = false
	}
	
	override func dismissalTransitionDidEnd(completed: Bool)
	{
		super.dismissalTransitionDidEnd(completed)
        
        // release strong references, causes deinit of this
        presentingViewSuperview = nil
        _modalPresentationController = nil
	}
	
	// MARK: - Actions
	
	func handleTap(gesture: UITapGestureRecognizer)
	{
		if gesture.state == UIGestureRecognizerState.Recognized
		{
			let location = gesture.locationInView(presentedViewController.view)
			
			if !presentedViewController.view.pointInside(location, withEvent: nil)
			{
				presentingViewController.dismissViewControllerAnimated(true, completion: nil)
			}
		}
	}
}

extension ModalSidePanelPresentationController: UIViewControllerTransitioningDelegate
{
	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
	{
		return self
	}
	
	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
	{
		return self
	}
	
	func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
    {
		
		return self
	}
}

extension ModalSidePanelPresentationController: UIViewControllerAnimatedTransitioning
{
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
	{
		return 0.50
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning)
	{
		if isPresenting
		{
			animatePresentingTransition(transitionContext)
		}
		else
		{
			animateDismissingTransition(transitionContext)
		}
	}
	
	// MARK: - Private Animations
	
	private func animatePresentingTransition(transitionContext: UIViewControllerContextTransitioning)
	{
		let fromViewController = presentingViewController
		let toViewController = presentedViewController
		
		let containerView = transitionContext.containerView()!
		
		let toView = toViewController.view
		let fromView = fromViewController.view
		
		var toViewInitialFrame = transitionContext.initialFrameForViewController(toViewController)
		let toViewFinalFrame = transitionContext.finalFrameForViewController(toViewController)
		
		let transitionDuration = self.transitionDuration(transitionContext)
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
		tap.delegate = self
		containerView.addGestureRecognizer(tap)
		
		// presented view needs to be transparent
		toView.backgroundColor = UIColor.clearColor()
		
		backgroundView = UIView(frame: containerView.bounds)
        backgroundView.backgroundColor = .blackColor()
		backgroundView.autoresizingMask = [.FlexibleWidth , .FlexibleHeight]
		containerView.addSubview(backgroundView)
		
		// store the original superview
		presentingViewSuperview = fromView.superview
		
		// round the corners
		fromView.layer.cornerRadius = 5.0
		fromView.layer.masksToBounds = true
		
		// move both to container
		containerView.addSubview(fromView)
		containerView.addSubview(toView)
		
		// last frame update before animation
		toViewInitialFrame.size = toViewFinalFrame.size;
		toViewInitialFrame.origin = CGPointMake(-toViewFinalFrame.size.width - paddingWidth, (containerView.bounds.size.height - toViewFinalFrame.size.height)/2.0);
		toView.frame = toViewInitialFrame;
		toView.transform = CGAffineTransformMakeScale(self.presentationScalePercent, self.presentationScalePercent)
		toView.alpha = 0

		// disable touches on presenting VC
		presentingViewController.view.userInteractionEnabled = false
		
		UIView.animateWithDuration(transitionDuration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.3, options: [], animations: {
			toView.transform = CGAffineTransformIdentity
			toView.frame = toViewFinalFrame
			toView.alpha = 1

			
			// set the scale first
			fromView.transform = CGAffineTransformMakeScale(self.presentationScalePercent, self.presentationScalePercent)
			
			// adjust the frame position
			var frame = fromView.frame
			frame.origin.x = CGRectGetMaxX(containerView.frame) - self.widthVisibleOfPresentingView
			fromView.frame = frame
		}) { (_) in
			let wasCancelled = transitionContext.transitionWasCancelled()
			
			transitionContext.completeTransition(!wasCancelled)
		}
	}
	
	private func animateDismissingTransition(transitionContext: UIViewControllerContextTransitioning)
	{
		let fromViewController = presentedViewController
		let toViewController = presentingViewController
		
		let toView = presentingViewController.view
		let fromView = presentedViewController.view
		
		var fromViewFinalFrame = transitionContext.finalFrameForViewController(fromViewController)
		let toViewFinalFrame = transitionContext.finalFrameForViewController(toViewController)
		
		let transitionDuration = self.transitionDuration(transitionContext)
		
		// last frame update before animation
		fromViewFinalFrame = fromView.frame
		fromViewFinalFrame.origin.x = -fromViewFinalFrame.size.width - paddingWidth
		
		UIView.animateWithDuration(transitionDuration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.3, options: [], animations: {
			fromView.frame = fromViewFinalFrame
			fromView.transform = CGAffineTransformMakeScale(self.presentationScalePercent, self.presentationScalePercent)
			
			toView.transform = CGAffineTransformIdentity
			toView.frame = toViewFinalFrame
			fromView.alpha = 0
		}) { (_) in
			let wasCancelled = transitionContext.transitionWasCancelled()
			
			if (!wasCancelled)
			{
				// remove round corners
				toView.layer.cornerRadius = 0
				toView.layer.masksToBounds = false
				
				// move original view back to its prior parent
				self.presentingViewSuperview.addSubview(toView)
				self.presentingViewSuperview = nil
				
				// don't need gradient any more
				self.backgroundView.removeFromSuperview()
				
				// enable touches on presenting VC
				self.presentingViewController.view.userInteractionEnabled = true
			}
			
			transitionContext.completeTransition(!wasCancelled)
		}
	}
}

extension ModalSidePanelPresentationController: UIGestureRecognizerDelegate {
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		let location = touch.locationInView(presentedViewController.view)
		
		return !presentedViewController.view.pointInside(location, withEvent: nil)
	}
}






