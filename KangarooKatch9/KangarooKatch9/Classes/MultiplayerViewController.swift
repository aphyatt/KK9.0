//
//  MultiplayerViewController.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 1/21/16.
//  Copyright © 2016 ADAM HYATT. All rights reserved.
//

import UIKit
import SpriteKit

class MultiplayerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: CGSize(width: 768, height: 1024))
        // Configure the view.
        let skView = self.view as! SKView

        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
