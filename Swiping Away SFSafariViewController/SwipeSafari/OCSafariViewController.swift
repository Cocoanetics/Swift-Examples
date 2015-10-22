//
//  OCSafariViewController.swift
//  ProTips
//
//  Created by Stefan Gugarel on 15.10.15.
//  Copyright © 2015 Stefan Gugarel. All rights reserved.
//

import UIKit
import SafariServices

protocol OCSafariViewControllerDelegate {
	
	func handleSwipeInSafari(gestureRecognizer: UIScreenEdgePanGestureRecognizer)
}

class OCSafariViewController: SFSafariViewController, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
	
	
	// MARK: - Members
	
	var edgeView: UIView?
	
	var gestureDelegate: OCSafariViewControllerDelegate?

	
	deinit {
		NSLog("deinit")
	}
	
    
	// MARK: - View lifecycle
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
	}
	
	override func viewWillAppear(animated: Bool) {
		
		super.viewWillAppear(animated)
		
		self.navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	override func viewDidAppear(animated: Bool) {
		
		super.viewDidAppear(animated)
		
		// Here we add our special view for recognizing swipe gestures
		edgeView = UIView()
		edgeView?.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(edgeView!)
		let bindings = ["edgeView": edgeView!]
		let options = NSLayoutFormatOptions(rawValue: 0)
		let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-0-[edgeView(20)]", options: options, metrics: nil, views: bindings)
		let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[edgeView]-44-|", options: options, metrics: nil, views: bindings)
		view?.addConstraints(hConstraints)
		view?.addConstraints(vConstraints)
		
		// Create swipe gesture recognizer
		let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleGesture:")
		recognizer.edges = UIRectEdge.Left
		self.edgeView?.addGestureRecognizer(recognizer)
		
		self.navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
		gestureDelegate?.handleSwipeInSafari(gestureRecognizer)
	}
}
