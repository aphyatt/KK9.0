//
//  Kangaroo.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/14/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

var kangPosX: CGFloat = 0
weak var TheKangaroo: Kangaroo?

class Kangaroo: SKNode {
    
    var leftTouch: Bool = false
    var rightTouch: Bool = false
    
    var kangPos: Int = 2
    let kangaroo = SKSpriteNode(imageNamed: "Kangaroo")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        super.init()
        
        TheKangaroo = self
        
        self.name = "kangaroo"
        self.zPosition = 10
        
        kangaroo.position = CGPoint(x: GameSize!.width/2, y: dropletCatchBoundaryY)
        kangaroo.zPosition = 11
        kangaroo.setScale(0.7)
        addChild(kangaroo)
        
    }
    
    override func runAction(action: SKAction?) {
        if let a = action {
            kangaroo.runAction(a)
        }
    }
    
    func update(currentTime: CFTimeInterval) {
        let kangSpeed: NSTimeInterval = 0.05
        
        if leftTouch && (kangPos != 1) {
            kangaroo.runAction(SKAction.moveToX(leftColX, duration: kangSpeed))
            kangPos = 1
        }
        if rightTouch && (kangPos != 3) {
            kangaroo.runAction(SKAction.moveToX(rightColX, duration: kangSpeed))
            kangPos = 3
        }
        if ((!leftTouch && !rightTouch) || numFingers == 0) && (kangPos != 2) {
            kangaroo.runAction(SKAction.moveToX(midColX, duration: kangSpeed))
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
