//
//  View.swift
//  loader
//
//  Created by Hamish Knight on 22/01/2016.
//  Copyright © 2016 Redonkulous Apps. All rights reserved.
//

import Foundation
import UIKit

class TeethLoaderView : UIView {
    
    var numberOfTeeth = 60 { // Number of teeth to render
        didSet {updatePathSegments()}
    }
    
    var teethSize = CGSize(width:8, height:45) { // The size of each individual tooth
        didSet {updatePathSegments()}
    }
    
    var animationDuration : TimeInterval = 5.0 // The duration of the animation
    
    var toothHighlightColor = UIColor(red: 29.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1) { // The color of a tooth when it's 'highlighted'
        didSet {setNeedsDisplay()}
    }
    
    var toothInactiveColor = UIColor(red: 233.0/255.0, green: 235.0/255.0, blue: 236.0/255.0, alpha: 1) { // The color of a tooth when it isn't 'hightlighted'
        didSet {setNeedsDisplay()}
    }
    
    private var progress = 0.0 // The progress of the loader
    private var pathSegments = [UIBezierPath]() // The array containing the UIBezier paths
    private var displayLink : CADisplayLink? // The display link to update the progress
    private var teethHighlighted = 0 // Number of teeth highlighted
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    private func commonSetup() {
        self.backgroundColor = UIColor.white()
    }
    
    override func layoutSubviews() {
        updatePathSegments()
    }
    
    func startAnimation() {
        
        displayLink?.invalidate()
        
        displayLink = CADisplayLink(target: self, selector: #selector(_displayLinkDidFire))
        displayLink?.add(to: RunLoop.main(), forMode: RunLoopMode.commonModes.rawValue)
    }
    
    func stopAnimation() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    func _displayLinkDidFire() {
        
        guard let displayLink = displayLink else {return}
        
        progress += displayLink.duration/animationDuration
        
        if (progress > 1) {
            progress -= 1
        }
        
        let t = teethHighlighted
        
        teethHighlighted = Int(round(progress*TimeInterval(numberOfTeeth))) // Calculate the number of teeth to highlight
        
        if (t != teethHighlighted) { // Only call setNeedsDisplay if the teethHighlighted changed
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.scale(x: -1, y: -1) // Flip the context to the correct orientation
        ctx?.translate(x: -rect.size.width, y: -rect.size.height)
        
        for (index, path) in pathSegments.enumerated() { // Draw each 'tooth'
            
            ctx?.addPath(path.cgPath)
            
            let fillColor = (index <= teethHighlighted) ? toothHighlightColor : toothInactiveColor
            
            ctx?.setFillColor(fillColor.cgColor)
            ctx?.fillPath()
        }
    }
    
    private func updatePathSegments() {
        pathSegments = getPathSegments(size: frame.size, teethCount: numberOfTeeth, teethSize: teethSize, radius: ((frame.width*0.5)-teethSize.height))
        setNeedsDisplay()
    }
    
    private func getPathSegments(size:CGSize, teethCount:Int, teethSize:CGSize, radius:CGFloat) -> [UIBezierPath] {
        
        let halfHeight = size.height*0.5
        let halfWidth = size.width*0.5
        let deltaAngle = CGFloat(2*M_PI)/CGFloat(teethCount) // The change in angle between paths
        
        // Create the template path of a single shape.
        let segment = CGPath(rect: CGRect(x: -teethSize.width*0.5, y: radius, width: teethSize.width, height: teethSize.height), transform: nil)
        
        return (0..<teethCount).flatMap { i in  // Copy, translate and rotate shapes around
            
            let translate = CGAffineTransform(translationX: halfWidth, y: halfHeight)
            var rotate = translate.rotate(deltaAngle*CGFloat(i))
            let transformedSegment = segment.copy(using: &rotate)
            
            assert(transformedSegment != nil, "Unable to copy path by applying a transform")
            
            return transformedSegment.map(UIBezierPath.init(cgPath:))
        }
    }
}
