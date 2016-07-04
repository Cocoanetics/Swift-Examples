//
//  ModalSidePanelPresentationSegue.swift
//
//  Created by Oliver Drobnik on 22/06/16.
//  Copyright © 2016 Cocoanetics. All rights reserved.
//

import UIKit

// private variable that sticks around even after the segue is has been released
internal var _modalPresentationController: ModalSidePanelPresentationController!

/// A custom segue that uses the ModalSidePanelPresentationController for presenting a modal view controller
public class ModalSidePanelPresentationSegue: UIStoryboardSegue
{
	/// Designated initializer
	override init(identifier: String?, source: UIViewController, destination: UIViewController)
	{
		super.init(identifier: identifier, source: source, destination: destination)
		
		_modalPresentationController = ModalSidePanelPresentationController(presentedViewController: destination, presentingViewController: source)
	}
	
	/// Executes the presentation
	public override func perform()
	{
		destinationViewController.transitioningDelegate = _modalPresentationController
		sourceViewController.presentViewController(destinationViewController, animated: true, completion: nil)
	}
}
