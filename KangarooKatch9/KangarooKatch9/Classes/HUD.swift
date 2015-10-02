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
    var pauseLabel: GameLabel?
    var exitLabel: GameLabel?
    var resumeLabel: GameLabel?
    var unpauseGame: Bool = false
    var pauseMenuArray: [SKNode]
    let fullRect: CGRect
    let pauseRect: CGRect
    let pauseX: CGFloat = 585
    let pauseY: CGFloat = GameSize!.height - 80
    
    let resumeLabelY: CGFloat = GameSize!.height/2 + 120
    let restartLabelY: CGFloat = GameSize!.width/2 + 40
    let exitLabelY: CGFloat = GameSize!.height/2 - 40
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        fullRect = CGRect(x: 0, y: 0,
            width: GameSize!.width,
            height: GameSize!.height)
        pauseRect = CGRect(x: pauseX, y: pauseY, width: 60, height: 60)
        
        pauseMenuArray = []
        
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
    
    private func CreatePauseLabel() {
        pauseLabel = GameLabel(text: "GAME PAUSED", size: 60,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: GameSize!.width/2, y: 710), zPosition: 300)
        if let p = pauseLabel {
            self.addChild(p)
        }
    }
    
    private func CreateExitLabel() {
        exitLabel = GameLabel(text: "EXIT", size: 40,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: GameSize!.width/2, y: exitLabelY - 10), zPosition: 300)
        if let el = exitLabel {
            self.addChild(el)
        }
    }
    
    private func CreateResumeLabel() {
        resumeLabel = GameLabel(text: "RESUME", size: 40,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: GameSize!.width/2, y: resumeLabelY - 10), zPosition: 300)
        if let rl = resumeLabel {
            self.addChild(rl)
        }
    }
    
    let mmLabel = createShadowLabel("Soup of Justice", text: "MAIN MENU",
        fontSize: 20,
        horAlignMode: horAlignModeDefault, vertAlignMode: .Baseline,
        labelColor: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
        name: "mainMenu",
        positon: CGPoint(x: oneThirdX, y: 500),
        shadowZPos: 8, shadowOffset: 2)
    
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
            unpauseGame = true
            break
        case .GameOver:
            break
        }
        
    }
    
    func sceneUntouched(touchLocation:CGPoint) {
        
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
        removeChildrenInArray(pauseMenuArray)
        exitLabel?.removeFromParent()
        pauseLabel?.removeFromParent()
        resumeLabel?.removeFromParent()
    }
    
    func showPauseMenu() {
        let shade = drawRectangle(fullRect, color: SKColor.grayColor(), width: 1.0)
        shade.fillColor = SKColor.grayColor()
        shade.alpha = 0.4
        shade.zPosition = 250
        shade.name = "shade"
        addChild(shade)
        
        let pmRect = CGRect(x: oneThirdX-130, y: GameSize!.height/2-250,
            width: GameSize!.width-(2*(oneThirdX-130)), height: 500)
        let pauseMenu = getRoundedRectShape(pmRect, cornerRadius: 16, color: SKColor.whiteColor(), lineWidth: 8)
        pauseMenu.fillColor = SKColor.blackColor()
        pauseMenu.zPosition = 251
        addChild(pauseMenu)
        
        let rRect = CGRect(x: GameSize!.width/2 - 100, y: resumeLabelY - 35,
            width: 200, height: 70)
        let resumeSquare = getRoundedRectShape(rRect, cornerRadius: 16, color: SKColor.whiteColor(), lineWidth: 4)
        resumeSquare.fillColor = SKColor.blackColor()
        resumeSquare.zPosition = 252
        addChild(resumeSquare)
        
        let eRect = CGRect(x: GameSize!.width/2 - 100, y: exitLabelY - 35,
            width: 200, height: 70)
        let exitSquare = getRoundedRectShape(eRect, cornerRadius: 16, color: SKColor.whiteColor(), lineWidth: 4)
        exitSquare.fillColor = SKColor.blackColor()
        exitSquare.zPosition = 252
        addChild(exitSquare)
        
        CreatePauseLabel()
        CreateExitLabel()
        CreateResumeLabel()
        
        pauseMenuArray = [shade, pauseMenu, resumeSquare, exitSquare]
    }
    
}
