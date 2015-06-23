//
//  UIView+Proportional.swift
//  Proportional
//
//  Created by Oliver Drobnik on 21/06/15.
//  Copyright (c) 2015 Cocoanetics. All rights reserved.
//

import Foundation
import UIKit

/**
Extensions for UIView to add proportional constraints
*/
extension UIView
{
	/**
	Removes the constraints added by IB
	*/
	func removePrototypingConstraints(view:UIView)
	{
		for constraint in view.constraints() as! [NSLayoutConstraint]
		{
			let name = NSStringFromClass(constraint.dynamicType)
			
			if (name.hasPrefix("NSIBPrototyping"))
			{
				view.removeConstraint(constraint);
			}
		}
	}
	
	/**
	Adds constraints for left and top to be relative to superview size
	*/
	func addProportionalOriginConstraints()
	{
		// need to disable autoresizing masks, they might interfere
		self.setTranslatesAutoresizingMaskIntoConstraints(false)
		
		// there must be a superview
		let superview = self.superview!
		
		// get dimensions
		let bounds = superview.bounds;
		let frame = self.frame
		
		// calculate percentages relative to bounds
		let percent_x = frame.origin.x / bounds.width;
		let percent_y = frame.origin.y / bounds.height;
		
		// constrain left as percent of superview
		if (percent_x > 0)
		{
			let leftMargin = NSLayoutConstraint(item: self,
				attribute: .Left,
				relatedBy: .Equal,
				toItem: superview,
				attribute: .Right,
				multiplier: percent_x,
				constant: 0);
			superview.addConstraint(leftMargin);
		}
		else
		{
			// since a multipler of 0 is illegal for .Right instead make .Left equal
			let leftMargin = NSLayoutConstraint(item: self,
				attribute: .Left,
				relatedBy: .Equal,
				toItem: superview,
				attribute: .Left,
				multiplier: 1,
				constant: 0);
			superview .addConstraint(leftMargin);
		}
		
		// constrain top as percent of superview
		if (percent_y > 0 )
		{
			let topMargin = NSLayoutConstraint(item: self,
				attribute: .Top,
				relatedBy: .Equal,
				toItem: superview,
				attribute: .Bottom,
				multiplier: percent_y,
				constant: 0);
			superview .addConstraint(topMargin);
		}
		else
		{
			// since a multipler of 0 is illegal for .Bottom we instead make .Top equal
			let topMargin = NSLayoutConstraint(item: self,
				attribute: .Top,
				relatedBy: .Equal,
				toItem: superview,
				attribute: .Top,
				multiplier: 1,
				constant: 0);
			superview.addConstraint(topMargin);
		}
	}
	
	/*
	Adds constraints for width and height to be relative to superview size
	*/
	func addProportionalSizeConstraints()
	{
		// need to disable autoresizing masks, they might interfere
		self.setTranslatesAutoresizingMaskIntoConstraints(false)

		// there must be a superview
		let superview = self.superview!
		
		// get dimensions
		let bounds = superview.bounds;
		let frame = self.frame
		
		// calculate percentages relative to bounds
		let percent_width = frame.size.width / bounds.width;
		let percent_height = frame.size.height / bounds.height;
		
		// constrain width as percent of superview
		let widthConstraint = NSLayoutConstraint(item: self,
			attribute: .Width,
			relatedBy: .Equal,
			toItem: superview,
			attribute: .Width,
			multiplier: percent_width,
			constant: 0);
		superview.addConstraint(widthConstraint);
		
		// constrain height as percent of superview
		let heightConstraint = NSLayoutConstraint(item: self,
			attribute: .Height,
			relatedBy: .Equal,
			toItem: superview,
			attribute: .Height,
			multiplier: percent_height,
			constant: 0);
		superview.addConstraint(heightConstraint);
	}
	
	/**
	Removes constraints that IB adds during prototyping
	*/
	func removePrototypingConstraints()
	{
		for constraint in self.constraints() as! [NSLayoutConstraint]
		{
			let name = NSStringFromClass(constraint.dynamicType)
			
			if (name.hasPrefix("NSIBPrototyping"))
			{
				self.removeConstraint(constraint)
			}
		}
	}
	
	/**
	Enumerate subviews of receiver
	*/
	func enumerateSubviews(block: (view: UIView) -> ())
	{
		for view in self.subviews as! [UIView]
		{
			// ignore _UILayoutGuide
			if (!view.conformsToProtocol(UILayoutSupport))
			{
				view.enumerateSubviews(block)
				block(view: view)
			}
		}
	}
}