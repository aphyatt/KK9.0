//
//  Droplet.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/29/15.
//  Copyright © 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

class Droplet: SKSpriteNode {
    var gravSpeed: CGVector = CGVector(dx: 0.0, dy: 0.0)
    
    init(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
