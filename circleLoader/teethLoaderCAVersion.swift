//
//  teethLoaderCAVersion.swift
//  circleLoader
//
//  Created by Hamish Knight on 23/01/2016.
//  Copyright © 2016 Redonkulous Apps. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class teethLoaderViewCA : UIView {
    
    let numberOfTeeth:UInt = 60 // Number of teetch to render
    let teethSize = CGSizeMake(8, 45) // The size of each individual tooth
    let animationDuration:NSTimeInterval = 5.0 // The duration of the animation
    
    let highlightColor = UIColor(red: 29.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1) // The color of a tooth when it's 'highlighted'
    let inactiveColor = UIColor(red: 233.0/255.0, green: 235.0/255.0, blue: 236.0/255.0, alpha: 1) // The color of a tooth when it isn't 'hightlighted'
    
    let shapeLayer = CAShapeLayer() // The teeth shape layer
    let drawLayer = CAShapeLayer() // The arc fill layer
    
    let anim = CABasicAnimation(keyPath: "strokeEnd") // The stroke animation
    
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

        // Get the group of paths we created.
        shapeLayer.path = getPathMask(frame.size, teethCount: numberOfTeeth, teethSize: teethSize, radius: ((frame.width*0.5)-teethSize.height))
        
        let halfWidth = frame.size.width*0.5
        let halfHeight = frame.size.height*0.5
        let halfDeltaAngle = CGFloat(M_PI/Double(numberOfTeeth));
        
        // Creates an arc path, with a given offset to allow it to be presented nicely
        drawLayer.path = UIBezierPath(arcCenter: CGPointMake(halfWidth, halfHeight), radius: halfWidth, startAngle: CGFloat(-M_PI_2)-halfDeltaAngle, endAngle: CGFloat(M_PI*1.5)+halfDeltaAngle, clockwise: true).CGPath
        drawLayer.frame = frame
        drawLayer.fillColor = inactiveColor.CGColor
        drawLayer.strokeColor = highlightColor.CGColor
        drawLayer.strokeStart = 0
        drawLayer.lineWidth = halfWidth
        drawLayer.mask = shapeLayer
        layer.addSublayer(drawLayer)

        // Setup animation
        anim.duration = animationDuration
        anim.fromValue = drawLayer.strokeStart
        anim.toValue = 1.0
        anim.repeatCount = Float.infinity
        drawLayer.addAnimation(anim, forKey: "circleAnim")
        
    }
    

    func getPathMask(size:CGSize, teethCount:UInt, teethSize:CGSize, radius:CGFloat) -> CGPathRef {
        
        let halfHeight = size.height*0.5;
        let halfWidth = size.width*0.5;
        let deltaAngle = CGFloat(2*M_PI/Double(teethCount)); // The change in angle between paths
        
        // Create the template path of a single shape.
        let p = CGPathCreateWithRect(CGRectMake(-teethSize.width*0.5, radius, teethSize.width, teethSize.height), nil);
        
        let returnPath = CGPathCreateMutable()
        
        for i in 0..<teethCount { // Copy, translate and rotate shapes around
            
            let translate = CGAffineTransformMakeTranslation(halfWidth, halfHeight);
            var rotate = CGAffineTransformRotate(translate, deltaAngle*CGFloat(i))
            CGPathAddPath(returnPath, &rotate, p)
        }
        
        return CGPathCreateCopy(returnPath)!
    }
    
}