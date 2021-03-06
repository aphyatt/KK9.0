//
//  HUD.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/14/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

let HUDheight: CGFloat = 120
let horAlignModeDefault: SKLabelHorizontalAlignmentMode = .Center
let vertAlignModeDefault: SKLabelVerticalAlignmentMode = .Baseline
weak var TheHUD: HUD?
var scoreLabel: GameLabel?

class HUD: SKNode {
    
    var joeyLifeStartX: CGFloat
    var boomerangLifeStartX: CGFloat
    
    var dropsLeft: Int = 10
    var livesLeft: Int = 3
    let scoreLabelX: CGFloat = 110
    let scoreLabelY: CGFloat
    let livesLabelY: CGFloat = 992
    let dropsLabelY: CGFloat = 942
    
    var livesLabel: GameLabel?
    var dropsLabel: GameLabel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        joeyLifeStartX = GameSize!.width/2 + 67
        boomerangLifeStartX = GameSize!.width/2 + 85
        
        scoreLabelY = GameSize!.height - 40
        
        super.init()
        
        TheHUD = self
        
        self.name = "EnHUD"
        self.zPosition = 200
        
        CreateScoreLabel()
        CreateLives()
      
    }
    
    func update(currentTime: CFTimeInterval) {
        
    }
    
    private func CreateScoreLabel() {
        scoreLabel = GameLabel(text: "Score: \(GS.CurrScore)", size: 50,
            horAlignMode: .Left, vertAlignMode: .Center,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(), shadowOffset: 3,
            pos: CGPoint(x: scoreLabelX, y: scoreLabelY), zPosition: self.zPosition + 1)
        if let sl = scoreLabel {
            sl.runAction(SKAction.scaleYTo(1.3, duration: 0.0))
            self.addChild(sl)
        }
    }
    
    func CreateLives() {
        
        for i in 0...(GS.MaxJoeyLives-1) {
            let node = SKSpriteNode(imageNamed: "Egg")
            let nodeS = SKSpriteNode(imageNamed: "Egg")
            
            node.position.x = joeyLifeStartX + CGFloat(i)*36
            node.position.y = dropsLabelY
            node.setScale(0.075)
            node.zPosition = 202
            node.name = "drop\(i+1)"
            
            nodeS.position = node.position
            nodeS.setScale(0.075)
            nodeS.zPosition = 201
            nodeS.alpha = 0.5
            
            addChild(node)
            addChild(nodeS)
        }
        
        for i in 0...(GS.MaxBoomerangLives-1) {
            let node = SKSpriteNode(imageNamed: "Boomerang")
            let nodeS = SKSpriteNode(imageNamed: "Boomerang")
            
            node.position.x = boomerangLifeStartX + CGFloat(i)*72
            node.position.y = livesLabelY
            node.setScale(0.15)
            node.zPosition = 202
            node.name = "life\(i+1)"
            
            nodeS.position = node.position
            nodeS.setScale(0.15)
            nodeS.zPosition = 201
            nodeS.alpha = 0.5
            
            addChild(node)
            addChild(nodeS)
        }
        
    }
    
    func removeLife(child: String) {
        childNodeWithName(child)?.removeFromParent()
    }
    
    func updateScore() {
        if let sl = scoreLabel {
            sl.text = "Score: \(GS.CurrScore)"
            
            let grow = SKAction.scaleBy(1.05, duration: 0.15)
            let scoreAction = SKAction.sequence([grow, grow.reversedAction()])
            
            sl.runAction(scoreAction)
        }
    }
    
}
