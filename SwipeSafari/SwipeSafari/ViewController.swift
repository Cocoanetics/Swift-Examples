//
//  ViewController.swift
//  SwipeSafari
//
//  Created by Stefan Gugarel on 21/10/15.
//  Copyright © 2015 Stefan Gugarel. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate, OCSafariViewControllerDelegate, UINavigationControllerDelegate {
	
	@IBOutlet weak var showButton: UIBarButtonItem!
	
	var animator: OCModalPushPopAnimator?
		
	
	// MARK: - View lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationController?.delegate = self
	}
	
	override func viewWillAppear(animated: Bool) {
		
		super.viewWillAppear(animated)
		
		self.navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
				
		showButton.enabled = true
	}
	
    
    // MARK: - SFSafariViewControllerDelegate
    
	func safariViewControllerDidFinish(controller: SFSafariViewController) {
		
		self.navigationController?.popToRootViewControllerAnimated(true)
	}
	
	
	// MARK: - Actions
	
	@IBAction func showButtonPressed(sender: AnyObject) {
		
		showButton.enabled = false

		let safariViewController = OCSafariViewController(URL: NSURL(string: "http://www.cocoanetics.com")!)
		
		safariViewController.delegate = self
		safariViewController.gestureDelegate = self
		
		self.navigationController?.pushViewController(safariViewController, animated: true)
		
		NSLog("Present Safari!")
	}
	
	func handleSwipeInSafari(recognizer: UIScreenEdgePanGestureRecognizer) {
		
		let realPercentComplete = (recognizer.locationInView(view).x) / view.bounds.size.width
		let percentComplete = realPercentComplete / 2.5
		
		switch recognizer.state {
			
		case .Began:
			animator = OCModalPushPopAnimator()
			self.navigationController?.popViewControllerAnimated(true)
			
		case .Changed:
			animator?.updateInteractiveTransition(percentComplete)
			
		case .Ended:
			
			if realPercentComplete < 0.5 {
				// If swipe is below half of screen cancel gesture
				animator?.cancelInteractiveTransition()
			} else {
				// If swipe is above half of screen finish gesture
				animator?.finishInteractiveTransition()
			}
            animator = nil

			
		case .Cancelled:
			animator?.cancelInteractiveTransition()
            animator = nil
			
		default: ()
		}
	}
	
	
	// MARK: - UINavigation delegate
	
	func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		
		return animator
	}
	
	func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		
		return animator
	}
}

