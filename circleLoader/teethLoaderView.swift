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
    let teethSize = CGSizeMake(8, 45) // The size of each individual tooth
    let animationDuration:NSTimeInterval = 5.0 // The duration of the animation
    
    let highlightColor = UIColor(red: 29.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1) // The color of a tooth when it's 'highlighted'
    let inactiveColor = UIColor(red: 233.0/255.0, green: 235.0/255.0, blue: 236.0/255.0, alpha: 1) // The color of a tooth when it isn't 'hightlighted'
    
    var progress:NSTimeInterval = 0.0 // The progress of the loader
    var paths = NSArray() // The array containing the UIBezier paths
    var displayLink = CADisplayLink() // The display link to update the progress
    var teethHighlighted:Int = 0 // Number of teeth highlighted
    
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
        paths = getPaths(frame.size, numberOfTeeth: numberOfTeeth, teethSize: teethSize, radius: ((frame.width*0.5)-teethSize.height))
        
        displayLink = CADisplayLink(target: self, selector: "displayLinkDidFire");
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func displayLinkDidFire() {
        
        progress += displayLink.duration/animationDuration
        
        if (progress > 1) {
            progress -= 1
        }
        
        let t = teethHighlighted
        
        teethHighlighted = Int(round(progress*NSTimeInterval(numberOfTeeth))) // Calculate the number of teeth to highlight
        
        if (t != teethHighlighted) { // Only call setNeedsDisplay if the teethHighlighted changed
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextScaleCTM(ctx, -1, -1) // Flip the context to the correct orientation
        CGContextTranslateCTM(ctx, -rect.size.width, -rect.size.height)
        
        for var i = 0; i < Int(numberOfTeeth); i++ { // Draw each 'tooth'
            let p = paths.objectAtIndex(i) as! UIBezierPath
            
            CGContextAddPath(ctx, p.CGPath);
            
            let fillColor = (i <= teethHighlighted) ? highlightColor:inactiveColor;
            
            CGContextSetFillColorWithColor(ctx, fillColor.CGColor)
            CGContextFillPath(ctx)
        }
    }
    
    func getPaths(size:CGSize, numberOfTeeth:UInt, teethSize:CGSize, radius:CGFloat) -> NSArray {
        
        let halfHeight = size.height/2;
        let halfWidth = size.width/2;
        let deltaAngle = CGFloat(2*M_PI/Double(numberOfTeeth)); // The change in angle between paths
        
        // Create the template path of a single shape.
        let p = CGPathCreateWithRect(CGRectMake(-teethSize.width*0.5, radius, teethSize.width, teethSize.height), nil);
        
        let pathArray = NSMutableArray()
        for var i:UInt = 0; i < numberOfTeeth; i++ { // Copy, translate and rotate shapes around
            
            let translate = CGAffineTransformMakeTranslation(halfWidth, halfHeight);
            var rotate = CGAffineTransformRotate(translate, deltaAngle*CGFloat(i))
            let pathCopy = CGPathCreateCopyByTransformingPath(p, &rotate)
            
            pathArray.addObject(UIBezierPath(CGPath: pathCopy!)) // Populate the array
        }
        
        return pathArray.copy() as! NSArray
    }
    
}