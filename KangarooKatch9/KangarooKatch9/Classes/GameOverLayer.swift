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
            pos: CGPoint(x: GameSize!.width/2, y: gameOverY), zPosition: self.zPosition + 1)
        if let gol = gameOverLabel {
            gol.alpha = 0.0
            self.addChild(gol)
        }
    }
    
    private func CreateJoeysCaughtLabel() {
        joeysCaughtLabel = GameLabel(text: "Joeys: 0", size: 55,
            horAlignMode: .Center, vertAlignMode: .Center,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: GameSize!.width/2, y: joeysCaughtY), zPosition: self.zPosition + 1)
        if let jcl = joeysCaughtLabel {
            jcl.runAction(SKAction.scaleYTo(1.3, duration: 0.0))
            jcl.alpha = 0.0
            self.addChild(jcl)
        }
    }
    
    private func CreateBoomersCaughtLabel() {
        boomersCaughtLabel = GameLabel(text: "Boomerangs: 0", size: 55,
            horAlignMode: .Center, vertAlignMode: .Center,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: GameSize!.width/2, y: boomersCaughtY), zPosition: self.zPosition + 1)
        if let bcl = boomersCaughtLabel {
            bcl.runAction(SKAction.scaleYTo(1.3, duration: 0.0))
            bcl.alpha = 0.0
            self.addChild(bcl)
        }
    }
    
    private func CreatePercentScoreLabel() {
        percentScoreLabel = GameLabel(text: "Score: 0.00%", size: 55,
            horAlignMode: .Center, vertAlignMode: .Center,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: GameSize!.width/2, y: scorePercentageY), zPosition: self.zPosition + 1)
        if let psl = percentScoreLabel {
            psl.runAction(SKAction.scaleYTo(1.3, duration: 0.0))
            psl.alpha = 0.0
            self.addChild(psl)
        }
    }
    
    private func CreateHighscoreLabel() {
        var ltext: String
        var yPos: CGFloat
        if GS.GameMode == .Classic {
            ltext = "HIGHSCORE: \(GS.getClassicHighscore())%"
            yPos = highScoreY
        }
        else { //Endless
            ltext = "HIGHSCORE: \(GS.getEndlessHighscore())"
            yPos = 624
        }
        highscoreLabel = GameLabel(text: ltext, size: 45,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.blackColor(), shadowColor: SKColor.whiteColor(),
            pos: CGPoint(x: GameSize!.width/2, y: yPos), zPosition: self.zPosition + 1)
        if let hsl = highscoreLabel {
            hsl.alpha = 0.0
            self.addChild(hsl)
        }
    }
    
    func endlessGameOver() {
        TheDropletLayer?.freezeDroplets()
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
        
        //have old high score appear
        CreateHighscoreLabel()
        let wait3 = SKAction.waitForDuration(5.5)
        let fadeIn2 = SKAction.fadeAlphaTo(1.0, duration: 1.5)
        let beforeHighscoreLabelAction = SKAction.sequence([wait3, fadeIn2])
        highscoreLabel?.runAction(beforeHighscoreLabelAction)
        
        //if new, replace old with new and animate
        if newHighscore {
            GS.setEndlessHighscore(GS.CurrScore)
            
            //TODO animate if new highscore
            let wait4 = SKAction.waitForDuration(6.0)
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
        
        runJoeysCaughtAction()
        runBoomersCaughtAction()
        runPercentScoreAction()
        
        //show old high score appear
        CreateHighscoreLabel()
        let wait3 = SKAction.waitForDuration(9.5)
        let fadeIn3 = SKAction.fadeAlphaTo(1.0, duration: 1.5)
        let highscoreLabelAction = SKAction.sequence([wait3, fadeIn3])
        highscoreLabel?.runAction(highscoreLabelAction)
        
        //if new, replace old with new and animate
        if newHighscore {
            let currScore = (Double(GS.CurrScore) / Double(GS.JoeyAmountSelected))*100
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
        
        let JCwaitBetweenTime = SKAction.waitForDuration(scoreTime / Double(GS.JoeysCaught))
        let JCrepeatScore = SKAction.repeatAction(SKAction.sequence([changeJC, JCwaitBetweenTime]), count: GS.JoeysCaught)
        let JCscoreAction = SKAction.group([JCrepeatScore, repeatScoreAnimation])
        
        let JCfinalAction = SKAction.sequence([SKAction.waitForDuration(2.5), JCscoreAction])
        joeysCaughtLabel!.runAction(JCfinalAction)
    }
    
    private func runBoomersCaughtAction() {
        CreateBoomersCaughtLabel()
        
        //show BoomersCaught
        let BCwait = SKAction.waitForDuration(3.5)
        let BCfadeIn = SKAction.fadeAlphaTo(1.0, duration: 2.0)
        let BCfadeAction = SKAction.sequence([BCwait, BCfadeIn])
        boomersCaughtLabel!.runAction(BCfadeAction)
        
        var BCtemp = 0
        let changeBC = SKAction.runBlock({
            //will add twice because of shadow and main label
            BCtemp++
            self.boomersCaughtLabel!.text = "Boomerangs: \(BCtemp/2)"
        })
        
        let BCwaitBetweenTime = SKAction.waitForDuration(scoreTime / Double(GS.BoomersCaught))
        let BCrepeatScore = SKAction.repeatAction(SKAction.sequence([changeBC, BCwaitBetweenTime]), count: GS.BoomersCaught)
        let BCscoreAction = SKAction.group([BCrepeatScore, repeatScoreAnimation])
        
        let BCfinalAction = SKAction.sequence([SKAction.waitForDuration(5.5), BCscoreAction])
        boomersCaughtLabel!.runAction(BCfinalAction)
    }
    
    private func runPercentScoreAction() {
        CreatePercentScoreLabel()
        
        //show BoomersCaught
        let PSwait = SKAction.waitForDuration(6.0)
        let PSfadeIn = SKAction.fadeAlphaTo(1.0, duration: 2.0)
        let PSfadeAction = SKAction.sequence([PSwait, PSfadeIn])
        percentScoreLabel!.runAction(PSfadeAction)
        
        var PStemp: Double = 0.00
        let changePS = SKAction.runBlock({
            //will add twice because of shadow and main label
            PStemp = PStemp + 0.01
            let scoreString = String(format: "%.2f", (PStemp/2))
            self.percentScoreLabel!.text = "Score: \(scoreString)%"
        })
        
        if (GS.CurrScore > 0) {
            let PSwaitBetweenTime = SKAction.waitForDuration(scoreTime / (Double(GS.CurrScore)*100))
            let PSrepeatScore = SKAction.repeatAction(SKAction.sequence([changePS, PSwaitBetweenTime]), count: GS.CurrScore*100)
            let PSscoreAction = SKAction.group([PSrepeatScore, repeatScoreAnimation])
            
            let PSfinalAction = SKAction.sequence([SKAction.waitForDuration(8.0), PSscoreAction])
            percentScoreLabel!.runAction(PSfinalAction)
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
