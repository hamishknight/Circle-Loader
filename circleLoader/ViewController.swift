//
//  ViewController.swift
//  loader
//
//  Created by Hamish Knight on 22/01/2016.
//  Copyright © 2016 Redonkulous Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func loadView() {
        self.view = teethLoaderView(frame: UIScreen.mainScreen().bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }



}

