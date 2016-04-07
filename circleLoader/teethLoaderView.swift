//
//  View.swift
//  loader
//
//  Created by Hamish Knight on 22/01/2016.
//  Copyright © 2016 Redonkulous Apps. All rights reserved.
//

import Foundation
import UIKit

class teethLoaderView : UIView {
    
    let numberOfTeeth:UInt = 60 // Number of teetch to render
    let teethSize = CGSize(width:8, height:45) // The size of each individual tooth
    let animationDuration = NSTimeInterval(5.0) // The duration of the animation
    
    let highlightColor = UIColor(red: 29.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1) // The color of a tooth when it's 'highlighted'
    let inactiveColor = UIColor(red: 233.0/255.0, green: 235.0/255.0, blue: 236.0/255.0, alpha: 1) // The color of a tooth when it isn't 'hightlighted'
    
    var progress = NSTimeInterval(0.0) // The progress of the loader
    var paths = [UIBezierPath]() // The array containing the UIBezier paths
    var displayLink = CADisplayLink() // The display link to update the progress
    var teethHighlighted = UInt(0) // Number of teeth highlighted
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    private func commonSetup() {
        self.backgroundColor = UIColor.whiteColor()
        paths = getPaths(frame.size, teethCount: numberOfTeeth, teethSize: teethSize, radius: ((frame.width*0.5)-teethSize.height))
        
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkDidFire));
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func displayLinkDidFire() {
        
        progress += displayLink.duration/animationDuration
        
        if (progress > 1) {
            progress -= 1
        }
        
        let t = teethHighlighted
        
        teethHighlighted = UInt(round(progress*NSTimeInterval(numberOfTeeth))) // Calculate the number of teeth to highlight
        
        if (t != teethHighlighted) { // Only call setNeedsDisplay if the teethHighlighted changed
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextScaleCTM(ctx, -1, -1) // Flip the context to the correct orientation
        CGContextTranslateCTM(ctx, -rect.size.width, -rect.size.height)
        
        for (index, path) in paths.enumerate() { // Draw each 'tooth'
            
            CGContextAddPath(ctx, path.CGPath);
            
            let fillColor = (UInt(index) <= teethHighlighted) ? highlightColor:inactiveColor;
            
            CGContextSetFillColorWithColor(ctx, fillColor.CGColor)
            CGContextFillPath(ctx)
        }
    }
    
    func getPaths(size:CGSize, teethCount:UInt, teethSize:CGSize, radius:CGFloat) -> [UIBezierPath] {
        
        let halfHeight = size.height*0.5;
        let halfWidth = size.width*0.5;
        let deltaAngle = CGFloat(2*M_PI)/CGFloat(teethCount); // The change in angle between paths
        
        // Create the template path of a single shape.
        let p = CGPathCreateWithRect(CGRectMake(-teethSize.width*0.5, radius, teethSize.width, teethSize.height), nil);
        
        var pathArray = [UIBezierPath]()
        for i in 0..<teethCount { // Copy, translate and rotate shapes around
            
            let translate = CGAffineTransformMakeTranslation(halfWidth, halfHeight);
            var rotate = CGAffineTransformRotate(translate, deltaAngle*CGFloat(i))
            let pathCopy = CGPathCreateCopyByTransformingPath(p, &rotate)!
            
            pathArray.append(UIBezierPath(CGPath: pathCopy)) // Populate the array
        }
        
        return pathArray
    }
}