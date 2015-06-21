//
//  ViewController.swift
//  Proportional
//
//  Created by Oliver Drobnik on 20/06/15.
//  Copyright (c) 2015 Cocoanetics. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
	@IBOutlet weak var squareView: UIView!
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		// restore reference frame from IB
//		self.view.frame = CGRect(x: 0, y: 0, width: 600, height: 600)

		// add proportional constraints
		self.squareView.enumerateSubviews { (view) -> () in
			
			// remove prototyping constraints from superview
			view.superview!.removePrototypingConstraints()

			// add proportional constraints
			view.addProportionalOriginConstraints()
			view.addProportionalSizeConstraints()
		}
	}
}
