//
//  NSLayoutManager+Attachments.swift
//  Attachments
//
//  Created by Oliver Drobnik on 01/09/2016.
//  Copyright © 2016 Cocoanetics. All rights reserved.
//

import UIKit

extension NSLayoutManager
{
	/// Determine the character ranges for an attachment
	private func rangesForAttachment(attachment: NSTextAttachment) -> [NSRange]?
	{
		guard let attributedString = self.textStorage else
		{
			return nil
		}
		
		// find character range for this attachment
		let range = NSRange(location: 0, length: attributedString.length)
		
		var refreshRanges = [NSRange]()
		
		attributedString.enumerateAttribute(NSAttachmentAttributeName, inRange: range, options: []) { (value, effectiveRange, nil) in
			
			guard let foundAttachment = value as? NSTextAttachment where foundAttachment == attachment else
			{
				return
			}
			
			// add this range to the refresh ranges
			refreshRanges.append(effectiveRange)
		}
		
		if refreshRanges.count == 0
		{
			return nil
		}
		
		return refreshRanges
	}
	
	/// Trigger a relayout for an attachment
	public func setNeedsLayout(forAttachment attachment: NSTextAttachment)
	{
		guard let ranges = rangesForAttachment(attachment) else
		{
			return
		}
		
		// invalidate the display for the corresponding ranges
		ranges.reverse().forEach { (range) in
			
			self.invalidateLayoutForCharacterRange(range, actualCharacterRange: nil)
			
			// also need to trigger re-display or already visible images might not get updated
			self.invalidateDisplayForCharacterRange(range)
		}
	}
	
	/// Trigger a re-display for an attachment
	public func setNeedsDisplay(forAttachment attachment: NSTextAttachment)
	{
		guard let ranges = rangesForAttachment(attachment) else
		{
			return
		}
		
		// invalidate the display for the corresponding ranges
		ranges.reverse().forEach { (range) in
			
			self.invalidateDisplayForCharacterRange(range)
		}
	}
}