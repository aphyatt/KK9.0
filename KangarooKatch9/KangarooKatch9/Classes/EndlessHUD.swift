//
//  EndlessHUD.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/15/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

weak var TheEndlessHUD: EndlessHUD?
var scoreLabel: GameLabel?

class EndlessHUD: SKNode {
    
    var joeyLifeStartX: CGFloat
    var boomerangLifeStartX: CGFloat
    
    var dropsLeft: Int = 10
    var livesLeft: Int = 3
    let scoreLabelX: CGFloat = oneThirdX - 38
    let scoreLabelY: CGFloat = 952
    let livesLabelY: CGFloat = 982
    let dropsLabelY: CGFloat = 922
    
    var livesLabel: GameLabel?
    var dropsLabel: GameLabel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        joeyLifeStartX = GameSize!.width/2 + 32
        boomerangLifeStartX = GameSize!.width/2 + 50
        
        super.init()
        
        TheEndlessHUD = self
        
        self.name = "EndlessHUD"
        self.zPosition = 200
        
        CreateScoreLabel()
        CreateLives()
        
    }
    
    func update(currentTime: CFTimeInterval) {
        /*
        if endlessScoreChange {
            updateScore()
            endlessScoreChange = false
        }
        */
    }
    
    private func CreateScoreLabel() {
        scoreLabel = GameLabel(text: "Score: \(GS.CurrScore)", size: 58,
            horAlignMode: .Center, vertAlignMode: .Center,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
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
            
            node.position.x = joeyLifeStartX + CGFloat(i)*41
            node.position.y = dropsLabelY
            node.setScale(0.09)
            node.zPosition = 202
            node.name = "drop\(i+1)"
            
            nodeS.position = node.position
            nodeS.setScale(0.09)
            nodeS.zPosition = 201
            nodeS.alpha = 0.5
            
            addChild(node)
            addChild(nodeS)
        }
        
        for i in 0...(GS.MaxBoomerangLives-1) {
            let node = SKSpriteNode(imageNamed: "Boomerang")
            let nodeS = SKSpriteNode(imageNamed: "Boomerang")
            
            node.position.x = boomerangLifeStartX + CGFloat(i)*86
            node.position.y = livesLabelY
            node.setScale(0.17)
            node.zPosition = 202
            node.name = "life\(i+1)"
            
            nodeS.position = node.position
            nodeS.setScale(0.17)
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
            let adjust = SKAction.runBlock({
                sl.changePositionX(self.scoreLabelX)
            })
            let shrink = grow.reversedAction()
            let scoreAction = SKAction.sequence([grow, adjust, shrink])
            
            sl.runAction(scoreAction)
        }
    }

}