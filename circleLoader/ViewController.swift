//
//  ViewController.swift
//  loader
//
//  Created by Hamish Knight on 22/01/2016.
//  Copyright © 2016 Redonkulous Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let circle = TeethLoaderViewCA(frame: UIScreen.main().bounds) // comment for core graphics version
    
    //let circle = TeethLoaderView(frame: UIScreen.main().bounds) // uncomment for core graphics version
    
    override func loadView() {
        
        self.view = circle
        
        circle.animate(from:0, to:0.6)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // Example function showing the animate() function working.
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        circle.animate(from:0.6, to:1)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
}

