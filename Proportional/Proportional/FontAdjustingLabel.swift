//
//  FontAdjustingLabel.swift
//  
//
//  Created by Oliver Drobnik on 21/06/15.
//
//

import UIKit

/**
UILabel subclass that stores the values from IB and adjusts the font size based on the current height
*/
class FontAdjustingLabel: UILabel
{
	var initialSize : CGSize!
	var initialFont : UIFont!
	
	override func awakeFromNib()
	{
		super.awakeFromNib()
		
		// store values from IB
		initialSize = self.frame.size
		initialFont = self.font
	}
	
	override func layoutSubviews()
	{
		super.layoutSubviews()
		
		// calculate new height
		let currentSize = self.bounds.size
		let factor = currentSize.height / initialSize.height
		
		// calculate point size of font
		let pointSize = initialFont.pointSize * factor;
		
		// make same font, but new size
		let fontDescriptor = initialFont.fontDescriptor()
		self.font = UIFont(descriptor: fontDescriptor, size: pointSize)
	}
}
