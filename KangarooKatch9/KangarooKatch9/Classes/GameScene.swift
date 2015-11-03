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

let leftColX: CGFloat = 219.43
let midColX: CGFloat = 384.0
let rightColX: CGFloat = 548.57
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
    
    /************************************ Init/Update Functions ***************************************/
    
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
    
    /*********************************************************************************************************
    * UPDATE
    * Function is called incredibly frequently, main game loop is here
    *********************************************************************************************************/
    override func update(currentTime: CFTimeInterval) {
        
        switch GS.GameState {
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
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.locationInNode(self)
        if GS.GameControls == .Thumb {
            GameWorld!.trackThumb(touchLocation)
        }
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
        GS.GameState = .GameRunning
    }
    
}
