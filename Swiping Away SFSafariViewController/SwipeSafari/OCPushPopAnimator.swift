//
//  OCPushPopAnimator.swift
//  ProTips
//
//  Created by Stefan Gugarel on 08/10/15.
//  Copyright © 2015 Stefan Gugarel. All rights reserved.
//

import UIKit

class OCModalPushPopAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
		
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 0.75
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		
		let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
		let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
		
		let topView = fromViewController.view
		let bottomViewController = toViewController
		var bottomView = bottomViewController.view
		let offset = bottomView.bounds.size.width
		
		if let navVC = bottomViewController as? UINavigationController {
			bottomView = navVC.topViewController?.view
		}
		
		// Mofifications before animation
		transitionContext.containerView()?.insertSubview(toViewController.view, belowSubview: fromViewController.view)
		
		topView.frame = fromViewController.view.frame
		topView.transform = CGAffineTransformIdentity
		
		// Shift by half screen size to get same effect like on automatic push animations
		bottomView.transform = CGAffineTransformMakeTranslation(-offset / 2, 0)
		
		UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.0, options: OCModalPushPopAnimator.animOpts(), animations: { () -> Void in
			
			// Interactive animations
			topView.transform = CGAffineTransformMakeTranslation(offset, 0)
			
			bottomView.transform = CGAffineTransformIdentity
			
			}) { ( finished ) -> Void in
				
				topView.transform = CGAffineTransformIdentity
                bottomView.transform = CGAffineTransformIdentity
				
				transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
		}
	}
	
	class func animOpts() -> UIViewAnimationOptions {
		return UIViewAnimationOptions.AllowAnimatedContent.union(UIViewAnimationOptions.BeginFromCurrentState).union(UIViewAnimationOptions.LayoutSubviews)
	}
}