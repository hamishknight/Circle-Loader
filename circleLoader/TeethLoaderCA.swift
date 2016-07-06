//
//  teethLoaderCAVersion.swift
//  circleLoader
//
//  Created by Hamish Knight on 23/01/2016.
//  Copyright © 2016 Redonkulous Apps. All rights reserved.
//

import Foundation
import UIKit

class TeethLoaderViewCA : UIView {
    
    var numberOfTeeth = 60 { // Number of teeth to render
        didSet {updateLayerMask()}
    }
    
    var teethSize = CGSize(width:8, height:45) { // The size of each individual tooth
        didSet {updateLayerMask()}
    }
    
    var animationDuration : TimeInterval = 5.0 // The duration of the animation
    
    var toothHighlightColor = UIColor(red: 29.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1) { // The color of a tooth when it's 'highlighted'
        didSet {
            drawLayer.strokeColor = toothHighlightColor.cgColor
        }
    }
    
    var toothInactiveColor = UIColor(red: 233.0/255.0, green: 235.0/255.0, blue: 236.0/255.0, alpha: 1) { // The color of a tooth when it isn't 'hightlighted'
        didSet {
            drawLayer.fillColor = toothInactiveColor.cgColor
        }
    }
    
    private let shapeLayer = CAShapeLayer() // The teeth shape layer
    private let drawLayer = CAShapeLayer() // The arc fill layer
    
    private let anim = CABasicAnimation(keyPath: "strokeEnd") // The stroke animation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    private func commonSetup() {
        
        // set your background color
        self.backgroundColor = UIColor.white()

        // Creates an arc path, with a given offset to allow it to be presented nicely
        drawLayer.fillColor = toothInactiveColor.cgColor
        drawLayer.strokeColor = toothHighlightColor.cgColor
        drawLayer.strokeEnd = 0
        drawLayer.mask = shapeLayer
        layer.addSublayer(drawLayer)

        // Optional, but looks nice
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    }
    
    override func layoutSubviews() {
        
        updateLayerMask()
        
        let halfWidth = frame.size.width*0.5
        let halfHeight = frame.size.height*0.5
        let halfDeltaAngle = CGFloat(M_PI)/CGFloat(numberOfTeeth)

        drawLayer.path = UIBezierPath(arcCenter: CGPoint(x: halfWidth, y: halfHeight), radius: halfWidth, startAngle: CGFloat(-M_PI_2)-halfDeltaAngle, endAngle: CGFloat(M_PI*1.5)+halfDeltaAngle, clockwise: true).cgPath
        drawLayer.frame = frame
        drawLayer.lineWidth = halfWidth
    }
    
    func animate(from fromValue:CGFloat, to toValue:CGFloat) {
        
        let deltaValue = TimeInterval(abs(toValue-fromValue))
        anim.duration = animationDuration*deltaValue // Adjusts the duration to be proportional to the change in value.
        anim.fromValue = fromValue
        anim.toValue = toValue
        drawLayer.add(anim, forKey: "circleAnim")

        // Transaction to disable implicit animation
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        drawLayer.strokeEnd = toValue
        CATransaction.commit()
    }
    
    private func updateLayerMask() {
        shapeLayer.path = getLayerMask(frame.size, teethCount: numberOfTeeth, teethSize: teethSize, radius: ((frame.width*0.5)-teethSize.height))
    }

    private func getLayerMask(_ size:CGSize, teethCount:Int, teethSize:CGSize, radius:CGFloat) -> CGPath? {
        
        let halfHeight = size.height*0.5
        let halfWidth = size.width*0.5
        let deltaAngle = CGFloat(2*M_PI)/CGFloat(teethCount); // The change in angle between paths
        
        // Create the template path of a single shape.
        let p = CGPath(rect: CGRect(x: -teethSize.width*0.5, y: radius, width: teethSize.width, height: teethSize.height), transform: nil)
        
        let returnPath = CGMutablePath()
        
        for i in 0..<teethCount { // Copy, translate and rotate shapes around
            let translate = CGAffineTransform(translationX: halfWidth, y: halfHeight)
            var rotate = translate.rotate(deltaAngle*CGFloat(i))
            returnPath.addPath(&rotate, path: p)
        }
        
        return returnPath.copy()
    }
    
}
