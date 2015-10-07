//
//  PauseMenu.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 10/6/15.
//  Copyright © 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

class PauseMenu: SKNode {
    
    var gamePausedLabel: GameLabel?
    var exitLabel: GameLabel?
    var resumeLabel: GameLabel?
    var restartLabel: GameLabel?
    var soundLabel: GameLabel?
    var shakeLabel: GameLabel?
    
    let resumeRect: CGRect
    let restartRect: CGRect
    let exitRect: CGRect
    let soundRect: CGRect
    let shakeRect: CGRect
    
    
    let gamePausedY: CGFloat = 700
    let resumeLabelY: CGFloat = GameSize!.height/2 + 110
    let restartLabelY: CGFloat = GameSize!.height/2 + 20
    let exitLabelY: CGFloat = GameSize!.height/2 - 70
    let checkBoxY: CGFloat = GameSize!.height/2 - 180
    
    let fullRect: CGRect
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        fullRect = CGRect(x: 0, y: 0,
            width: GameSize!.width,
            height: GameSize!.height)
        resumeRect = CGRect(x: GameSize!.width/2 - 100, y: resumeLabelY - 35,
            width: 200, height: 70)
        restartRect = CGRect(x: GameSize!.width/2 - 100, y: restartLabelY - 35, width: 200, height: 70)
        exitRect = CGRect(x: GameSize!.width/2 - 100, y: exitLabelY - 35,
            width: 200, height: 70)
        soundRect = CGRect(x: GameSize!.width/2 - 65, y: checkBoxY - 25, width: 50, height: 50)
        shakeRect = CGRect(x: GameSize!.width/2 + 135, y: checkBoxY - 25, width: 50, height: 50)
        
        
        super.init()
        
        CreatePauseMenu()
        debugRect()
    }
    
    private func CreateGamePausedLabel() {
        gamePausedLabel = GameLabel(text: "GAME PAUSED", size: 60,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: GameSize!.width/2, y: gamePausedY), zPosition: 4)
        if let p = gamePausedLabel {
            self.addChild(p)
        }
    }
    
    private func CreateExitLabel() {
        exitLabel = GameLabel(text: "EXIT", size: 40,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: GameSize!.width/2, y: exitLabelY - 10), zPosition: 4)
        if let el = exitLabel {
            self.addChild(el)
        }
    }
    
    private func CreateResumeLabel() {
        resumeLabel = GameLabel(text: "RESUME", size: 40,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: GameSize!.width/2, y: resumeLabelY - 10), zPosition: 4)
        if let rl = resumeLabel {
            self.addChild(rl)
        }
    }
    
    private func CreateRestartLabel() {
        restartLabel = GameLabel(text: "RESTART", size:40,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: GameSize!.width/2, y: restartLabelY - 10), zPosition: 4)
        if let rl = restartLabel {
            self.addChild(rl)
        }
    }
    
    private func CreateSoundLabel() {
        soundLabel = GameLabel(text: "SOUND", size:40,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: GameSize!.width/2 - 135, y: checkBoxY - 10), zPosition: 4)
        if let sl = soundLabel {
            self.addChild(sl)
        }
    }
    
    private func CreateShakeLabel() {
        shakeLabel = GameLabel(text: "SHAKE", size:40,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.whiteColor(), shadowColor: SKColor.grayColor(),
            pos: CGPoint(x: GameSize!.width/2 + 65, y: checkBoxY - 10), zPosition: 4)
        if let shl = shakeLabel {
            self.addChild(shl)
        }
    }
    
    func CreatePauseMenu() {
        let shade = drawRectangle(fullRect, color: SKColor.grayColor(), width: 1.0)
        shade.fillColor = SKColor.grayColor()
        shade.alpha = 0.4
        shade.zPosition = -1
        shade.name = "shade"
        addChild(shade)
        
        //PauseMenuRect
        let pmRect = CGRect(x: oneThirdX-130, y: GameSize!.height/2-250,
            width: GameSize!.width-(2*(oneThirdX-130)), height: 500)
        let pauseMenu = getRoundedRectShape(pmRect, cornerRadius: 16, color: SKColor.whiteColor(), lineWidth: 10)
        pauseMenu.fillColor = SKColor.blackColor()
        pauseMenu.zPosition = 2
        addChild(pauseMenu)
        
        /*
        let pmRectS = CGRect(x: oneThirdX-130, y: GameSize!.height/2-255,
            width: GameSize!.width-(2*(oneThirdX-130)), height: 500)
        let pauseMenuS = getRoundedRectShape(pmRectS, cornerRadius: 16, color: SKColor.whiteColor(), lineWidth: 16)
        pauseMenuS.fillColor = SKColor.blackColor()
        pauseMenuS.zPosition = 1
        addChild(pauseMenuS)
        */
        
        //Resume Rect
        let resumeSquare = getRoundedRectShape(resumeRect, cornerRadius: 16, color: SKColor.whiteColor(), lineWidth: 4)
        resumeSquare.fillColor = SKColor.blackColor()
        resumeSquare.zPosition = 3
        addChild(resumeSquare)
        
        let rsmRectS = CGRect(x: GameSize!.width/2 - 100, y: resumeLabelY - 40,
            width: 200, height: 70)
        let resumeSquareS = getRoundedRectShape(rsmRectS, cornerRadius: 16, color: SKColor.whiteColor(), lineWidth: 8)
        resumeSquareS.fillColor = SKColor.blackColor()
        resumeSquareS.zPosition = 2
        addChild(resumeSquareS)
        
        //Restart Rect
        let restartSquare = getRoundedRectShape(restartRect, cornerRadius: 16, color: SKColor.whiteColor(), lineWidth: 4)
        restartSquare.fillColor = SKColor.blackColor()
        restartSquare.zPosition = 3
        addChild(restartSquare)
        
        let rstRectS = CGRect(x: GameSize!.width/2 - 100, y: restartLabelY - 40, width: 200, height: 70)
        let restartSquareS = getRoundedRectShape(rstRectS, cornerRadius: 16, color: SKColor.whiteColor(), lineWidth: 8)
        restartSquareS.fillColor = SKColor.blackColor()
        restartSquareS.zPosition = 2
        addChild(restartSquareS)
        
        //Exit Rect
        let exitSquare = getRoundedRectShape(exitRect, cornerRadius: 16, color: SKColor.whiteColor(), lineWidth: 4)
        exitSquare.fillColor = SKColor.blackColor()
        exitSquare.zPosition = 3
        addChild(exitSquare)
        
        let eRectS = CGRect(x: GameSize!.width/2 - 100, y: exitLabelY - 40,
            width: 200, height: 70)
        let exitSquareS = getRoundedRectShape(eRectS, cornerRadius: 16, color: SKColor.whiteColor(), lineWidth: 8)
        exitSquareS.fillColor = SKColor.blackColor()
        exitSquareS.zPosition = 2
        addChild(exitSquareS)
        
        //Sound Box
        let soundBox = getRoundedRectShape(soundRect, cornerRadius: 16, color: SKColor.whiteColor(), lineWidth: 4)
        soundBox.fillColor = SKColor.blackColor()
        soundBox.zPosition = 3
        addChild(soundBox)
        
        let sBoxS = CGRect(x: GameSize!.width/2 - 65, y: checkBoxY - 30, width: 50, height: 50)
        let soundBoxS = getRoundedRectShape(sBoxS, cornerRadius: 16, color: SKColor.whiteColor(), lineWidth: 8)
        soundBoxS.fillColor = SKColor.blackColor()
        soundBoxS.zPosition = 2
        addChild(soundBoxS)
        
        //Shake Box
        let shakeBox = getRoundedRectShape(shakeRect, cornerRadius: 16, color: SKColor.whiteColor(), lineWidth: 4)
        shakeBox.fillColor = SKColor.blackColor()
        shakeBox.zPosition = 3
        addChild(shakeBox)
        
        let shBoxS = CGRect(x: GameSize!.width/2 + 135, y: checkBoxY - 30, width: 50, height: 50)
        let shakeBoxS = getRoundedRectShape(shBoxS, cornerRadius: 16, color: SKColor.whiteColor(), lineWidth: 8)
        shakeBoxS.fillColor = SKColor.blackColor()
        shakeBoxS.zPosition = 2
        addChild(shakeBoxS)
        
        CreateGamePausedLabel()
        
        CreateResumeLabel()
        CreateRestartLabel()
        CreateExitLabel()
        CreateSoundLabel()
        CreateShakeLabel()

    }
    
    func debugRect() {
        let rsm = drawRectangle(resumeRect, color: SKColor.redColor(), width: 1.0)
        rsm.zPosition = 5
        addChild(rsm)
        
        let rst = drawRectangle(restartRect, color: SKColor.redColor(), width: 1.0)
        rst.zPosition = 5
        addChild(rst)
        
        let e = drawRectangle(exitRect, color: SKColor.redColor(), width: 1.0)
        e.zPosition = 5
        addChild(e)
        
        let sound = drawRectangle(soundRect, color: SKColor.redColor(), width: 1.0)
        sound.zPosition = 5
        addChild(sound)
        
        let shake = drawRectangle(shakeRect, color: SKColor.redColor(), width: 1.0)
        shake.zPosition = 5
        addChild(shake)
        
    }
}