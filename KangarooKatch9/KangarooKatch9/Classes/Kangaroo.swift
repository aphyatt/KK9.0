//
//  Kangaroo.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/14/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

var kangPosX: CGFloat = 0

class Kangaroo: SKSpriteNode {
    
    var leftTouch: Bool = false
    var rightTouch: Bool = false
    
    var kangPos: Int = 2
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        TheKangaroo = self
        
        self.name = "kangaroo"
        self.zPosition = 10
        
        self.position = CGPoint(x: GameSize!.width/2, y: dropletCatchBoundaryY)
        self.zPosition = 11
        self.setScale(0.7)
    }
    
    func update(currentTime: CFTimeInterval) {
        if leftTouch && (kangPos != 1) {
            self.runAction(SKAction.moveToX(leftColX, duration: 0.05))
            kangPos = 1
        }
        if rightTouch && (kangPos != 3) {
            self.runAction(SKAction.moveToX(rightColX, duration: 0.05))
            kangPos = 3
        }
        if ((!leftTouch && !rightTouch) || numFingers == 0) && (kangPos != 2) {
            self.runAction(SKAction.moveToX(midColX, duration: 0.05))
            kangPos = 2
        }
        
        switch kangPos {
        case 1: kangPosX = leftColX
            break
        case 2: kangPosX = midColX
            break
        default: kangPosX = rightColX
        }
        
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        if touchLocation.x < oneThirdX {
            leftTouch = true
            rightTouch = false
        }
        if touchLocation.x > twoThirdX {
            rightTouch = true
            leftTouch = false
        }
    }
    
    func sceneUntouched(touchLocation:CGPoint) {
        if numFingers == 0 {
            leftTouch = false
            rightTouch = false
        }
    }
    
    func trackThumb(touchLocation:CGPoint) {
        if touchLocation.x < oneThirdX {
            leftTouch = true
            rightTouch = false
        }
        else if touchLocation.x > twoThirdX {
            rightTouch = true
            leftTouch = false
        }
        else {
            leftTouch = false
            rightTouch = false
        }
    }
    
}
