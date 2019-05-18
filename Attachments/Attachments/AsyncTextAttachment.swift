//
//  AsyncTextAttachment.swift
//  Attachments
//
//  Created by Oliver Drobnik on 01/09/2016.
//  Copyright © 2016 Cocoanetics. All rights reserved.
//

import UIKit
import MobileCoreServices


@objc public protocol AsyncTextAttachmentDelegate
{
	/// Called when the image has been loaded
	func textAttachmentDidLoadImage(textAttachment: AsyncTextAttachment, displaySizeChanged: Bool)
}

/// An image text attachment that gets loaded from a remote URL
public class AsyncTextAttachment: NSTextAttachment
{
	/// Remote URL for the image
	public var imageURL: URL?

	/// To specify an absolute display size.
	public var displaySize: CGSize?
	
	/// if determining the display size automatically this can be used to specify a maximum width. If it is not set then the text container's width will be used
	public var maximumDisplayWidth: CGFloat?

	/// A delegate to be informed of the finished download
	public weak var delegate: AsyncTextAttachmentDelegate?
	
	/// Remember the text container from delegate message, the current one gets updated after the download
	weak var textContainer: NSTextContainer?
	
	/// The download task to keep track of whether we are already downloading the image
	private var downloadTask: URLSessionDataTask!
	
	/// The size of the downloaded image. Used if we need to determine display size
	private var originalImageSize: CGSize?
	
	/// Designated initializer
	public init(imageURL: URL? = nil, delegate: AsyncTextAttachmentDelegate? = nil)
	{
		self.imageURL = imageURL
		self.delegate = delegate
		
		super.init(data: nil, ofType: nil)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override public var image: UIImage? {
		didSet {
			originalImageSize = image?.size
		}
	}
	
	// MARK: - Helpers
	
	private func startAsyncImageDownload()
	{
		guard let imageURL = imageURL, contents == nil, downloadTask == nil else
		{
			return
		}
		
        downloadTask = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
			
			defer
			{
				// done with the task
				self.downloadTask = nil
			}
			
			guard let data = data, error == nil else {
				print(error?.localizedDescription as Any)
				return
			}
			
			var displaySizeChanged = false
			
			self.contents = data
			
			let ext = imageURL.pathExtension as CFString
			if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, ext, nil)
			{
				self.fileType = uti.takeRetainedValue() as String
			}
			
			if let image = UIImage(data: data)
			{
				let imageSize = image.size
				
				if self.displaySize == nil
				{
					displaySizeChanged = true
				}
				
				self.originalImageSize = imageSize
			}

            DispatchQueue.main.async
                {
                    // tell layout manager so that it should refresh
                    if displaySizeChanged
                    {
                        self.textContainer?.layoutManager?.setNeedsLayout(forAttachment: self)
                    }
                    else
                    {
                        self.textContainer?.layoutManager?.setNeedsDisplay(forAttachment: self)
                    }

                    // notify the optional delegate
                    self.delegate?.textAttachmentDidLoadImage(textAttachment: self, displaySizeChanged: displaySizeChanged)
            }
		}
		
		downloadTask.resume()
	}

	public override func image(forBounds imageBounds: CGRect, textContainer: NSTextContainer?, characterIndex charIndex: Int) -> UIImage?
	{
		if let image = image { return image }
		
		guard let contents = contents, let image = UIImage(data: contents) else
		{
			// remember reference so that we can update it later
			self.textContainer = textContainer
			
			startAsyncImageDownload()
			
			return nil
		}
		
		return image
	}

	public override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect
	{
		if let displaySize = displaySize
		{
			return CGRect(origin: CGPoint.zero, size: displaySize)
		}
		
		if let imageSize = originalImageSize
		{
			let maxWidth = maximumDisplayWidth ?? lineFrag.size.width
			let factor = maxWidth / imageSize.width
			
			return CGRect(origin: CGPoint.zero, size:CGSize(width: Int(imageSize.width * factor), height: Int(imageSize.height * factor)))
		}
		
		return CGRect.zero
	}
}
