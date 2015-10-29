//
//  GameOverLayer.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/20/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

var GameOver: GameOverLayer?

class GameOverLayer: SKNode {
    
    let fullRect: CGRect
    
    var restartTap: Bool = false
    var restartTapWait: Bool = false
    var startGameOver: Bool = false
    var newHighscore: Bool = false
    
    var gameOverLabel: GameLabel?
    var tempScoreLabel: GameLabel?
    var highscoreLabel: GameLabel?
    
    var scoreTmp: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        fullRect = CGRect(x: 0, y: 0,
            width: GameSize!.width,
            height: GameSize!.height)
        
        super.init()
        
        GameOver = self
        
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
            var gameOver: SKAction
            if GS.GameMode == .Endless {
                let highscore = GS.getEndlessHighscore()
                if GS.CurrScore > highscore {
                    newHighscore = true
                }
                gameOver = SKAction.runBlock({self.endlessGameOver()})
            }
            else { //if GS.GameMode == .Classic
                let highscore = GS.getClassicHighscore()
                let currScore = intDivisionToDouble(GS.CurrScore, rhs: GS.JoeyAmountSelected)*100
                if currScore > highscore {
                    newHighscore = true
                }
                gameOver = SKAction.runBlock({self.classicGameOver()})
            }
            let wait2 = SKAction.waitForDuration(NSTimeInterval(5))
            let setBool = SKAction.runBlock({self.restartTapWait = true})
            runAction(SKAction.sequence([gameOver, wait2, setBool]))
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
            color: SKColor.blackColor(), shadowColor: SKColor.whiteColor(),
            pos: CGPoint(x: GameSize!.width/2, y: 780), zPosition: self.zPosition + 1)
        if let gol = gameOverLabel {
            gol.alpha = 0.0
            self.addChild(gol)
        }
    }
    
    private func CreateHighscoreLabel() {
        var ltext: String
        var yPos: CGFloat
        if GS.GameMode == .Classic {
            ltext = "HIGHSCORE: \(GS.getClassicHighscore())%"
            yPos = 600
        }
        else { //Endless
            ltext = "HIGHSCORE: \(GS.getEndlessHighscore())"
            yPos = 624
        }
        highscoreLabel = GameLabel(text: ltext, size: 60,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.blackColor(), shadowColor: SKColor.whiteColor(),
            pos: CGPoint(x: GameSize!.width/2, y: yPos), zPosition: self.zPosition + 1)
        if let hsl = highscoreLabel {
            hsl.alpha = 0.0
            self.addChild(hsl)
        }
    }
    
    private func CreateTempScoreLabel() {
        tempScoreLabel = GameLabel(text: "Score: 0", size: 60,
            horAlignMode: .Center, vertAlignMode: .Center,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: GameSize!.width/2, y: 780), zPosition: self.zPosition + 1)
        if let tsl = tempScoreLabel {
            tsl.runAction(SKAction.scaleYTo(1.3, duration: 0.0))
            tsl.alpha = 0.0
            self.addChild(tsl)
        }
    }
    
    func restartGame() {
        //remove all nodes
        removeAllActions()
        removeAllChildren()
        TheGameScene!.restartGame()
    }
    
    func endlessGameOver() {
        TheDropletLayer?.freezeDroplets()
        let shade = drawRectangle(fullRect, color: SKColor.grayColor(), width: 1.0)
        shade.fillColor = SKColor.grayColor()
        shade.alpha = 0.4
        shade.zPosition = self.zPosition
        addChild(shade)
        
        CreateGameOverLabel()
        
        //fade in GAME OVER
        let wait = SKAction.waitForDuration(0.5)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 2.0)
        let gameOverAction = SKAction.sequence([wait, fadeIn])
        gameOverLabel!.runAction(gameOverAction)
     
        //have score move and grow under GAME OVER
        let wait2 = SKAction.waitForDuration(3.0)
        let bringToFront = SKAction.runBlock({scoreLabel?.zPosition = self.zPosition + 500})
        let moveIntoPos = SKAction.moveTo(CGPoint(x: GameSize!.width/2, y: 722), duration: 1.0)
        let grow = SKAction.scaleBy(1.3, duration: 1.0)
        let adjust = SKAction.runBlock({
            scoreLabel?.labelS.position.x += 2
            scoreLabel?.labelS.position.y -= 2
        })
        let scoreAction = SKAction.sequence([wait2, bringToFront, SKAction.group([moveIntoPos, grow]), adjust])
        scoreLabel!.runAction(scoreAction)
        
        //have old high score appear
        CreateHighscoreLabel()
        let wait3 = SKAction.waitForDuration(5.0)
        let fadeIn2 = SKAction.fadeAlphaTo(1.0, duration: 1.5)
        let beforeHighscoreLabelAction = SKAction.sequence([wait3, fadeIn2])
        highscoreLabel?.runAction(beforeHighscoreLabelAction)
        
        //if new, replace old with new and animate
        if newHighscore {
            GS.setEndlessHighscore(GS.CurrScore)
            
            //TODO animate if new highscore
            let wait4 = SKAction.waitForDuration(5.5)
            let changeScore = SKAction.runBlock({
                self.highscoreLabel?.text = "HIGHSCORE: \(GS.CurrScore)"
            })
            let newHighscoreAction = SKAction.sequence([wait4, changeScore])
            highscoreLabel!.runAction(newHighscoreAction)
        }
        
    }
    
    func classicGameOver() {
        TheDropletLayer?.freezeDroplets()
        let shade = drawRectangle(fullRect, color: SKColor.grayColor(), width: 1.0)
        shade.fillColor = SKColor.grayColor()
        shade.alpha = 0.4
        shade.zPosition = self.zPosition
        addChild(shade)
        
        CreateTempScoreLabel()
        
        //fade in score
        let wait = SKAction.waitForDuration(0.5)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 2.0)
        let fadeAction = SKAction.sequence([wait, fadeIn])
        tempScoreLabel!.runAction(fadeAction)
        
        var scoreTime: NSTimeInterval
        if GS.CurrScore < 11 {
            scoreTime = 0.5
        }
        else if GS.CurrScore < 31 {
            scoreTime = 1.0
        }
        else if GS.CurrScore < 61 {
            scoreTime = 1.5
        }
        else if GS.CurrScore < 101 {
            scoreTime = 2.0
        }
        else {
            scoreTime = 2.5
        }
        
        let changeScore = SKAction.runBlock({
            //will add twice because of shadow and main label
            self.scoreTmp++
            self.tempScoreLabel!.text = "Score: \(self.scoreTmp/2)"
        })
        
        let waitBetweenTime = SKAction.waitForDuration(scoreTime / Double(GS.CurrScore))
        let repeatScore = SKAction.repeatAction(SKAction.sequence([changeScore, waitBetweenTime]), count: GS.CurrScore)
        
        let grow = SKAction.scaleBy(1.05, duration: 0.3)
        let scoreAnimation = SKAction.sequence([grow, grow.reversedAction()])
    
        let repeatScoreAnimation = SKAction.repeatActionForever(scoreAnimation)
        let scoreAction = SKAction.group([repeatScore, repeatScoreAnimation])
       
        print("\(scoreTime) , \(GS.CurrScore) , wait = \(scoreTime / Double(GS.CurrScore))")
        
        let finalScoreAction = SKAction.sequence([SKAction.waitForDuration(2.5), scoreAction])
        tempScoreLabel!.runAction(finalScoreAction)
        
        //have old high score appear
        CreateHighscoreLabel()
        let wait2 = SKAction.waitForDuration(5.0+scoreTime)
        let fadeIn2 = SKAction.fadeAlphaTo(1.0, duration: 1.5)
        let beforeHighscoreLabelAction = SKAction.sequence([wait2, fadeIn2])
        highscoreLabel?.runAction(beforeHighscoreLabelAction)
        
        //if new, replace old with new and animate
        if newHighscore {
            let currScore = intDivisionToDouble(GS.CurrScore, rhs: GS.JoeyAmountSelected)*100
            GS.setClassicHighscore(currScore)
            
            //TODO animate if new highscore
            let wait3 = SKAction.waitForDuration(7.0)
            let changeScore = SKAction.runBlock({
                self.highscoreLabel?.text = "HIGHSCORE: \(currScore)%"
            })
            let newHighscoreAction = SKAction.sequence([wait3, changeScore])
            highscoreLabel!.runAction(newHighscoreAction)
        }
        
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        if (restartTapWait) {
            restartTap = true
        }
    }
    
    func sceneUntouched(touchLocation:CGPoint) {
        
    }

    
}
