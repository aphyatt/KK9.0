//
//  GameOverLayer.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/20/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit
import GameKit

var boomDeath: Bool = false
weak var TheGameOverLayer: GameOverLayer?

class GameOverLayer: SKNode {
    
    let fullRect: CGRect
    var restartTap: Bool = false
    var restartTapWait: Bool = false
    var startGameOver: Bool = false
    var newHighscore: Bool = false
    
    var gameOverLabel: GameLabel?
    var joeysCaughtLabel: GameLabel?
    var boomersCaughtLabel: GameLabel?
    var percentScoreLabel: GameLabel?
    var highscoreLabel: GameLabel?
    
    let gameOverY: CGFloat = 780
    let joeysCaughtY: CGFloat = 780
    let boomersCaughtY: CGFloat = 680
    let scorePercentageY: CGFloat = 580
    let highScoreY: CGFloat = 480
    
    let grow = SKAction.scaleBy(1.05, duration: 0.2)
    let scoreAnimation: SKAction
    let repeatScoreAnimation: SKAction
    let scoreTime: NSTimeInterval = 2.0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        fullRect = CGRect(x: 0, y: 0,
            width: GameSize!.width,
            height: GameSize!.height)
        
        scoreAnimation = SKAction.sequence([grow, grow.reversedAction()])
        repeatScoreAnimation = SKAction.repeatAction(scoreAnimation, count: 5)
        
        super.init()
        
        TheGameOverLayer = self
        
        self.name = "GameOver"
        self.zPosition = 300
    }
    
    func update(currentTime: CFTimeInterval) {
        endGame()
    }
    
    var endGameCalls: Int = 0
    func endGame() {
        endGameCalls++
        if(endGameCalls == 1) {
            GameKitHelper.sharedInstance.reportHighscore(Int64(GS.CurrScore))
            let highscore = GS.getHighscore()
            if GS.CurrScore > highscore {
                newHighscore = true
            }
            let gameOver: SKAction = SKAction.runBlock({self.GameOver()})
        
            let wait = SKAction.waitForDuration(NSTimeInterval(5))
            let shakeWait: SKAction
            if (boomDeath) {
                shakeWait = SKAction.waitForDuration(NSTimeInterval(0.5))
                boomDeath = false
            }
            else {
                shakeWait = SKAction.waitForDuration(NSTimeInterval(0.1))
            }
            let setBool = SKAction.runBlock({self.restartTapWait = true})
            TheDropletLayer?.freezeDroplets()
            runAction(SKAction.sequence([shakeWait, gameOver, wait, setBool]))
        }
        else {
            if restartTap {
                restartTap = false
                restartTapWait = false
                endGameCalls = 0
                restartGame()
            }
        }
    }
    
    private func CreateGameOverLabel() {
        gameOverLabel = GameLabel(text: "GAME OVER", size: 70,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.blackColor(), shadowColor: SKColor.whiteColor(), shadowOffset: 3,
            pos: CGPoint(x: GameSize!.width/2, y: gameOverY), zPosition: self.zPosition + 1)
        if let gol = gameOverLabel {
            gol.alpha = 0.0
            self.addChild(gol)
        }
    }
    
    private func CreateJoeysCaughtLabel() {
        joeysCaughtLabel = GameLabel(text: "Joeys: 0", size: 55,
            horAlignMode: .Center, vertAlignMode: .Center,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(), shadowOffset: 3,
            pos: CGPoint(x: GameSize!.width/2, y: joeysCaughtY), zPosition: self.zPosition + 1)
        if let jcl = joeysCaughtLabel {
            jcl.runAction(SKAction.scaleYTo(1.3, duration: 0.0))
            jcl.alpha = 0.0
            self.addChild(jcl)
        }
    }
    
    private func CreateHighscoreLabel() {
        highscoreLabel = GameLabel(text: "HIGHSCORE: \(GS.getHighscore())", size: 45,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.blackColor(), shadowColor: SKColor.whiteColor(), shadowOffset: 3,
            pos: CGPoint(x: GameSize!.width/2, y: 624), zPosition: self.zPosition + 1)
        if let hsl = highscoreLabel {
            hsl.alpha = 0.0
            self.addChild(hsl)
        }
    }
    
    func GameOver() {
        let shade = drawRectangle(fullRect, color: SKColor.grayColor(), width: 1.0)
        shade.fillColor = SKColor.grayColor()
        shade.alpha = 0.0
        shade.zPosition = self.zPosition
        addChild(shade)
        let fadeInShade = SKAction.fadeAlphaTo(0.4, duration: 0.5)
        let fadeOutScore = SKAction.fadeAlphaTo(0.0, duration: 0.5)
        shade.runAction(fadeInShade);
        scoreLabel?.runAction(fadeOutScore)
        
        CreateGameOverLabel()
        
        //fade in GAME OVER
        let wait = SKAction.waitForDuration(1.0)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 2.0)
        let gameOverAction = SKAction.sequence([wait, fadeIn])
        gameOverLabel!.runAction(gameOverAction)
     
        //have score move and grow under GAME OVER
        let wait2 = SKAction.waitForDuration(3.5)
        let grow = SKAction.scaleBy(1.3, duration: 0.0)
        let moveAndSizeScore = SKAction.runBlock({
            scoreLabel?.zPosition = self.zPosition + 500
            scoreLabel?.changeHorAlign(.Center)
            scoreLabel?.changePos(CGPoint(x: GameSize!.width/2, y: 722))
        })
        let fadeInScore = SKAction.fadeAlphaTo(1.0, duration: 0.5)
        let scoreAction = SKAction.sequence([wait2, grow, moveAndSizeScore, fadeInScore])
        scoreLabel!.runAction(scoreAction)
        
        reportAchievementsForJoeys(GS.CurrScore)
        
        //have old high score appear
        CreateHighscoreLabel()
        let wait3 = SKAction.waitForDuration(5.5)
        let fadeIn2 = SKAction.fadeAlphaTo(1.0, duration: 1.5)
        let beforeHighscoreLabelAction = SKAction.sequence([wait3, fadeIn2])
        highscoreLabel?.runAction(beforeHighscoreLabelAction)
        
        //if new, replace old with new and animate
        if newHighscore {
            GS.setHighscore(GS.CurrScore)
            
            //TODO animate if new highscore
            let wait4 = SKAction.waitForDuration(6.0)
            let changeScore = SKAction.runBlock({
                self.highscoreLabel?.text = "HIGHSCORE: \(GS.CurrScore)"
            })
            let newHighscoreAction = SKAction.sequence([wait4, changeScore])
            highscoreLabel!.runAction(newHighscoreAction)
        }
        
    }
    
    //not currently used, but add later for normal gameover
    private func runJoeysCaughtAction() {
        CreateJoeysCaughtLabel()
        
        //show JoeysCaught
        let JCwait = SKAction.waitForDuration(0.5)
        let JCfadeIn = SKAction.fadeAlphaTo(1.0, duration: 2.0)
        let JCfadeAction = SKAction.sequence([JCwait, JCfadeIn])
        joeysCaughtLabel!.runAction(JCfadeAction)
        
        var JCtemp = 0
        let changeJC = SKAction.runBlock({
            //will add twice because of shadow and main label
            JCtemp++
            self.joeysCaughtLabel!.text = "Joeys: \(JCtemp/2)"
        })
        
        let JCwaitBetweenTime = SKAction.waitForDuration(scoreTime / Double(GS.CurrScore))
        let JCrepeatScore = SKAction.repeatAction(SKAction.sequence([changeJC, JCwaitBetweenTime]), count: GS.CurrScore)
        let JCscoreAction = SKAction.group([JCrepeatScore, repeatScoreAnimation])
        
        let JCfinalAction = SKAction.sequence([SKAction.waitForDuration(2.5), JCscoreAction])
        joeysCaughtLabel!.runAction(JCfinalAction)
    }
    
    func reportAchievementsForJoeys(joeys: Int) {
        let achievements: [GKAchievement] =
        AchievementsHelper.joeysCaughtAchievements(joeys)
        
        if achievements.count != 0 {
            GameKitHelper.sharedInstance.reportAchievements(achievements)
        }
    }
    
    func restartGame() {
        //remove all nodes
        removeAllActions()
        removeAllChildren()
        TheGameScene!.restartGame()
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        if (restartTapWait) {
            restartTap = true
        }
    }
    
    func sceneUntouched(touchLocation:CGPoint) {
        
    }
    
}
