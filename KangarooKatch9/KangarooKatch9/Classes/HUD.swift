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

var TheHUD: HUD?

class HUD: SKNode {
    
    var classicHUD: ClassicHUD?
    var endlessHUD: EndlessHUD?
    var pauseButton: SKSpriteNode?
    var pauseButtonS: SKSpriteNode?
    var unpauseGame: Bool = false
    let pauseRect: CGRect
    let pauseX: CGFloat = 585
    let pauseY: CGFloat = GameSize!.height - 80
    var ThePauseMenu: PauseMenu?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        pauseRect = CGRect(x: pauseX, y: pauseY, width: 60, height: 60)
        
        super.init()
        
        TheHUD = self
        
        self.name = "HUD"
        self.zPosition = 100
        
        CreatePauseButton()
        
        if GS.GameMode == .Classic {
            CreateClassicHUD()
        }
        if GS.GameMode == .Endless {
            CreateEndlessHUD()
        }
        
    }
    
    func update(currentTime: CFTimeInterval) {
        if GS.GameState == .Paused {
            pauseGame()
        }
    }
    
    private func CreatePauseButton() {
        pauseButton = SKSpriteNode(imageNamed: "PauseButtonWhite")
        pauseButtonS = SKSpriteNode(imageNamed: "PauseButtonGray")
        if let pb = pauseButton {
            pb.position = CGPoint(x: pauseX+30, y: pauseY+30)
            pb.setScale(1.5)
            pb.zPosition = self.zPosition + 1
            pb.setScale(0.45)
            pb.color = SKColor.whiteColor()
            addChild(pb)
        }
        if let pbS = pauseButtonS {
            pbS.position = CGPoint(x: pauseX+32, y: pauseY+28)
            pbS.setScale(1.5)
            pbS.zPosition = self.zPosition
            pbS.setScale(0.45)
            pbS.color = SKColor.grayColor()
            addChild(pbS)
        }
        
    }
    
    private func CreateClassicHUD() {
        classicHUD = ClassicHUD()
        if let cHUD = classicHUD {
            cHUD.zPosition = -1
            self.addChild(cHUD)
        }
    }
    
    private func CreateEndlessHUD() {
        endlessHUD = EndlessHUD()
        if let eHUD = endlessHUD {
            eHUD.zPosition = -1
            self.addChild(eHUD)
        }
    }
    
    func updateScore() {
        if GS.GameMode == .Endless {
            endlessHUD!.updateScore()
        }
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        switch GS.GameState {
        case .GameRunning:
            if (pauseRect.contains(touchLocation)) {
                GS.GameState = .Paused
            }
            break
        case .Paused:
            ThePauseMenu?.sceneTouched(touchLocation)
            break
        case .GameOver:
            break
        }
        
    }
    
    func sceneUntouched(touchLocation:CGPoint) {
        switch GS.GameState {
        case .GameRunning:
            break
        case .Paused:
            ThePauseMenu?.sceneUntouched(touchLocation)
            break
        case .GameOver:
            break
        }
    }
    
    var pauseGameCalls: Int = 0
    func pauseGame() {
        pauseGameCalls++
        if(pauseGameCalls == 1) {
            TheDropletLayer!.freezeDroplets()
            showPauseMenu()
        }
        else {
            if unpauseGame {
                unpauseGame = false
                pauseGameCalls = 0
                removePauseMenu()
                //countdown / wait
                TheDropletLayer!.unfreezeDroplets()
                GS.lineCountBeforeDrops = GS.totalLinesDropped
                GS.currLinesToDrop = 0
                dropLines = true
                GS.GameState = .GameRunning
            }
        }
    }
    
    func removePauseMenu() {
        ThePauseMenu!.removeFromParent()
    }
    
    func showPauseMenu() {
        ThePauseMenu = PauseMenu()
        if let pm = ThePauseMenu {
            pm.zPosition = 250
            self.addChild(pm)
        }
    }
    
}
