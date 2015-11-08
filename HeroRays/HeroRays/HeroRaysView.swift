//
//  HeroRaysView.swift
//  HeroRays
//
//  Created by Oliver Drobnik on 08/11/15.
//  Copyright © 2015 Oliver Drobnik. All rights reserved.
//

import UIKit

public final class HeroRaysView: UIView
{
    // MARK: - Properties
    
    private lazy var raysView: HeroRaysDiscView =
    {
        let view = HeroRaysDiscView()
        self.insertSubview(view, atIndex: 0)
        self.clipsToBounds = true
        
        return view
    }()
    
    @IBInspectable var rayFillColor: UIColor?
    {
        didSet
        {
            raysView.rayFillColor = rayFillColor
        }
    }
    
    @IBInspectable var rayStrokeColor: UIColor?
    {
        didSet
        {
            raysView.rayStrokeColor = rayStrokeColor
        }
    }
    
    override public var backgroundColor: UIColor?
    {
        didSet
        {
            raysView.backgroundColor = backgroundColor
        }
    }
    
    // MARK: - Overridden Methods
    
    override public func willMoveToSuperview(newSuperview: UIView?)
    {
        super.willMoveToSuperview(newSuperview)
        
        // animate while visible
        if let _ = newSuperview
        {
            startAnimating()
        }
        else
        {
            stopAnimating()
        }
    }
    
    override public func layoutSubviews()
    {
        super.layoutSubviews()
        
        // size to be large enough to cover corners while rotating
        let biggerDim = max(self.bounds.size.width, self.bounds.size.height)
        let halfDim = biggerDim / 2.0
        let radius = ceil(sqrt(halfDim * halfDim + halfDim * halfDim))
        let frame = CGRectMake(0, 0, radius * 2.0, radius * 2.0)
        raysView.bounds = frame
        
        // always center the view
        let pos = CGPoint(x: CGRectGetMidX(self.bounds),
            y: CGRectGetMidY(self.bounds))
        raysView.center = pos
    }
    
    // MARK: - Animating
    
    func startAnimating()
    {
        let anim = CABasicAnimation()
        anim.keyPath = "transform.rotation.z"
        anim.toValue = CGFloat(2.0 * M_PI)
        anim.duration = 12 // seconds per rotation
        anim.repeatCount = Float.infinity
        
        raysView.layer.addAnimation(anim, forKey: "rotate")
    }
    
    func stopAnimating()
    {
        raysView.layer.removeAllAnimations()
    }
}
