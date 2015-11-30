//
//  GameScene.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 7/8/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

weak var TheGameScene: GameScene?
var GameSize: CGSize?

var numFingers: Int = 0
var playableMargin: CGFloat = 0
var playableWidth: CGFloat = 0

let leftColX: CGFloat = 219.4300000
let midColX: CGFloat = 384.000000
let rightColX: CGFloat = 548.5700000
let oneThirdX: CGFloat = 288.0
let twoThirdX: CGFloat = 480.0

class GameScene: SKScene {
    
    let fullRect: CGRect
    let sceneRect: CGRect
    let worldRect: CGRect
    let hudRect: CGRect
    
    var GameWorld: World?
    var HUDdisplay: HUD?
    var GameOver: GameOverLayer?
    
    var countdownWait: Bool = false
    var countdownLabel: GameLabel?
    
    override func didMoveToView(view: SKView) {
        TheGameScene = self
        GameSize = TheGameScene?.size
        super.didMoveToView(view)
        
        restartGame()
    }
    
    func restart() {
        removeAllActions()
        removeAllChildren()
        CreateWorld()
        CreateHUD()
        CreateGameOver()
    }
    
    private func CreateWorld() {
        GameWorld = World()
        if let world = GameWorld {
            self.addChild(world)
        }
    }
    
    private func CreateHUD() {
        HUDdisplay = HUD()
        if let hud = HUDdisplay {
            self.addChild(hud)
        }
    }
    
    private func CreateGameOver() {
        GameOver = GameOverLayer()
        if let go = GameOver {
            self.addChild(go)
        }
    }
    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        playableWidth = size.height / maxAspectRatio
        playableMargin = (size.width-playableWidth)/2.0
        fullRect = CGRect(x: 0, y: 0,
            width: size.width,
            height: size.height)
        worldRect = CGRect(x: 0, y: 0,
            width: size.width,
            height: size.height - HUDheight)
        hudRect = CGRect(x: 0, y: size.height - HUDheight,
            width: size.width,
            height: HUDheight)
        sceneRect = CGRect(x: playableMargin, y: 0,
            width: playableWidth,
            height: size.height)
  
        GS.GameState = .GameRunning
        
        super.init(size: size)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        switch GS.GameState {
        case .Countdown:
            countdownHelper()
            break
        case .GameRunning:
            GameWorld!.update(currentTime)
            HUDdisplay!.update(currentTime)
            break
        case .Paused:
            dropLines = false
            GameWorld!.update(currentTime)
            HUDdisplay!.update(currentTime)
            break
        case .GameOver:
            dropLines = false
            GameOver!.update(currentTime)
            break
        }
    }
    
    var countdownCalls: Int = 0
    func countdownHelper() {
        countdownCalls++
        if(countdownCalls == 1) {
            let countdown = SKAction.runBlock({self.countdown()})
            let wait = SKAction.waitForDuration(NSTimeInterval(3))
            let setBool = SKAction.runBlock({self.countdownWait = true})
            runAction(SKAction.sequence([countdown, wait, setBool]))
        }
        else {
            if countdownWait {
                countdownWait = false
                countdownCalls = 0
                TheDropletLayer!.unfreezeDroplets()
                GS.GameState = .GameRunning
            }
        }
    }
    
    private func countdown() {
        CreateCountdownLabel()
        
        let grow = SKAction.scaleBy(1.2, duration: 0.1)
        let wait1s = SKAction.waitForDuration(0.8)
        let changeTo2 = SKAction.runBlock({self.countdownLabel!.text = "2"})
        let changeTo1 = SKAction.runBlock({self.countdownLabel!.text = "1"})
        let removeCD = SKAction.runBlock({self.countdownLabel!.removeFromParent()})
        let sec3Action = SKAction.sequence([grow, grow.reversedAction(), wait1s])
        let sec2Action = SKAction.sequence([grow, changeTo2, grow.reversedAction(), wait1s])
        let sec1Action = SKAction.sequence([grow, changeTo1, grow.reversedAction(), wait1s])
        let countDownAction = SKAction.sequence([sec3Action, sec2Action, sec1Action, removeCD])
        countdownLabel!.runAction(countDownAction)
        
    }
    
    private func CreateCountdownLabel() {
        countdownLabel = GameLabel(text: "3", size: 120,
            horAlignMode: .Center, vertAlignMode: .Center,
            color: SKColor.blackColor(), shadowColor: SKColor.whiteColor(), shadowOffset: 5,
            pos: CGPoint(x: self.size.width/2, y: 650), zPosition: self.zPosition+5)
        if let cdl = countdownLabel {
            self.addChild(cdl)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.locationInNode(self)
        numFingers += touches.count
        
        switch GS.GameState {
        case .GameRunning:
            if worldRect.contains(touchLocation) {
                GameWorld!.sceneTouched(touchLocation)
            }
            break
        case .Paused:
            GameWorld!.sceneTouched(touchLocation)
            break
        case .GameOver:
            GameOver!.sceneTouched(touchLocation)
            break
        default: break
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.locationInNode(self)
        GameWorld!.trackThumb(touchLocation)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.locationInNode(self)
        numFingers -= touches.count
        
        switch GS.GameState {
        case .GameRunning:
            if worldRect.contains(touchLocation) {
                GameWorld!.sceneUntouched(touchLocation)
            }
            break
        case .Paused:
            GameWorld!.sceneUntouched(touchLocation)
            break
        case .GameOver:
            GameOver!.sceneUntouched(touchLocation)
            break
        default: break
        }
    }
    
    override func didEvaluateActions()  {
        Droplets!.checkCollisions()
    }
    
    func restartGame() {
        GS.CurrScore = 0
        GS.totalLinesDropped = 0
        GS.currLinesToDrop = 0
        GS.lineCountBeforeDrops = 0
        GS.groupAmtMin = 2
        GS.groupAmtMax = 3
        GS.JoeysCaught = 0
        GS.BoomersCaught = 0
        
        switch GS.GameMode {
        case .Classic:
            GS.JoeysLeft = GS.JoeyAmountSelected
            GS.DiffLevel = GS.DiffLevelSelected
            break
        case .Endless:
            GS.DiffLevel = V_EASY
            GS.CurrJoeyLives = 6
            GS.CurrBoomerangLives = 3
            break
        }
        restart()
        GS.GameState = .Countdown
    }
    
}
