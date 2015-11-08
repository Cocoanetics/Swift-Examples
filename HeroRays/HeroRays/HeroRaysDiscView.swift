//
//  HeroRaysDiscView.swift
//  HeroRays
//
//  Created by Oliver Drobnik on 08/11/15.
//  Copyright © 2015 Oliver Drobnik. All rights reserved.
//

import UIKit

internal final class HeroRaysDiscView: UIView
{
    var rayFillColor: UIColor?
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    var rayStrokeColor: UIColor?
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect)
    {
        let path = raysPath()
        
        if let color = rayFillColor
        {
            color.setFill()
            path.fill()
        }
        
        if let color = rayStrokeColor
        {
            color.setStroke()
            path.stroke()
        }
    }
    
    func raysPath()->UIBezierPath
    {
        let center = CGPoint(x: CGRectGetMidX(self.bounds),
                             y: CGRectGetMidY(self.bounds))
        let radius = sqrt(center.x * center.x + center.y * center.y)
        let numberOfSlices = 16
        let raysPath = UIBezierPath()
        let oneRayRadians = (2.0 * CGFloat(M_PI)) / CGFloat(numberOfSlices)
        
        for var i=0; i<numberOfSlices; i++
        {
            // skip every second slice, for background to show
            if i%2 != 0
            {
                continue;
            }
            
            // make one slice
            let ray = UIBezierPath(arcCenter: center,
                radius: radius,
                startAngle: CGFloat(i)*oneRayRadians,
                endAngle: CGFloat(i+1)*oneRayRadians,
                clockwise: true)
            ray.addLineToPoint(center)
            ray.closePath()
            
            // add all slices to the main path
            raysPath.appendPath(ray)
        }
        
        return raysPath
    }
}
