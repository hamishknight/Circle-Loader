//
//  ViewController.swift
//  loader
//
//  Created by Hamish Knight on 22/01/2016.
//  Copyright © 2016 Redonkulous Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
       // let circle = TeethLoaderViewCA(frame: UIScreen.mainScreen().bounds)
    
    override func loadView() {
        
        self.view = TeethLoaderView(frame: UIScreen.mainScreen().bounds) // uncomment for core graphics version
        //self.view = circle // comment for core graphics version
        
        //circle.animate(0, toValue: 0.6)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    // Example function showing the animate() function working.
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       // circle.animate(0.6, toValue: 1)
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }



}

