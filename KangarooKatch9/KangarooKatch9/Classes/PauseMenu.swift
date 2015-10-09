//
//  PauseMenu.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 10/6/15.
//  Copyright © 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

var ThePauseMenu: PauseMenu?

class PauseMenu: SKNode {
    
    var gamePausedLabel: GameLabel?
    var soundLabel: GameLabel?
    var shakeLabel: GameLabel?
    
    var resumeButton: OptionButton?
    var restartButton: OptionButton?
    var exitButton: OptionButton?
    var soundButton: OptionButton?
    var shakeButton: OptionButton?
    
    let fullRect: CGRect
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
    
    let pauseColor: UIColor = SKColor.blackColor()
    let pauseOColor: UIColor = SKColor.whiteColor()
    let buttonColor: UIColor = SKColor.blackColor()
    let buttonOColor: UIColor = SKColor.whiteColor()
    let textColor: UIColor = SKColor.whiteColor()
    let textSColor: UIColor = SKColor.grayColor()
    
    let soundCheck = SKSpriteNode(imageNamed: "WhiteCheck")
    let shakeCheck = SKSpriteNode(imageNamed: "WhiteCheck")
    
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
        
        soundCheck.position = CGPoint(x: soundRect.midX+10, y: soundRect.midY+10)
        shakeCheck.position = CGPoint(x: shakeRect.midX+10, y: shakeRect.midY+10)
        soundCheck.setScale(0.2)
        shakeCheck.setScale(0.2)
        soundCheck.zPosition = 5
        shakeCheck.zPosition = 5
        
        super.init()
        
        ThePauseMenu = self
        
        CreatePauseMenu()
        debugRect()
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        if resumeRect.contains(touchLocation) {
            resumeButton?.click()
        }
        if restartRect.contains(touchLocation) {
            restartButton?.click()
        }
        if exitRect.contains(touchLocation) {
            exitButton?.click()
        }
        if soundRect.contains(touchLocation) {
            soundButton?.click()
        }
        if shakeRect.contains(touchLocation) {
            shakeButton?.click()
        }
        
    }
    
    func sceneUntouched(touchLocation:CGPoint) {
        if resumeRect.contains(touchLocation) {
            resumeButton?.unclick()
            TheHUD?.unpauseGame = true
        }
        if restartRect.contains(touchLocation) {
            //add ask are you sure you want to restart?
            GameOver?.restartGame()
            restartButton?.unclick()
        }
        if exitRect.contains(touchLocation) {
            //add ask are you sure you want to quit?
            let myScene = MainMenu(size: TheGameScene!.size)
            myScene.scaleMode = TheGameScene!.scaleMode
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            TheGameScene!.view?.presentScene(myScene, transition: reveal)
            exitButton?.unclick()
        }
        if soundRect.contains(touchLocation) {
            if GS.SoundOn {
                GS.SoundOn = false
                soundCheck.removeFromParent()
            }
            else {
                GS.SoundOn = true
                addChild(soundCheck)
            }
            soundButton?.unclick()
        }
        if shakeRect.contains(touchLocation) {
            if GS.ShakeOn {
                GS.ShakeOn = false
                shakeCheck.removeFromParent()
            }
            else {
                GS.ShakeOn = true
                addChild(shakeCheck)
            }
            shakeButton?.unclick()
        }
    }
    
    private func CreateGamePausedLabel() {
        gamePausedLabel = GameLabel(text: "GAME PAUSED", size: 60,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: textColor, shadowColor: textSColor,
            pos: CGPoint(x: GameSize!.width/2, y: gamePausedY), zPosition: 4)
        if let p = gamePausedLabel {
            self.addChild(p)
        }
    }
    
    private func CreateResumeButton() {
        resumeButton = OptionButton(buttonRect: resumeRect,
            outlineColor: buttonOColor, fillColor: buttonColor,
            lineWidth: 4, startZ: 2)
        resumeButton?.setText("RESUME", textSize: 40,
            textColor: textColor, textColorS: textSColor,
            textPos: CGPoint(x: GameSize!.width/2, y: resumeLabelY - 10))
        if let rsmb = resumeButton {
            self.addChild(rsmb)
        }
    }
    
    private func CreateRestartButton() {
        restartButton = OptionButton(buttonRect: restartRect,
            outlineColor: buttonOColor, fillColor: buttonColor,
            lineWidth: 4, startZ: 2)
        restartButton?.setText("RESTART", textSize: 40,
            textColor: textColor, textColorS: textSColor,
            textPos: CGPoint(x: GameSize!.width/2, y: restartLabelY - 10))
        if let rstb = restartButton {
            self.addChild(rstb)
        }
    }
    
    private func CreateExitButton() {
        exitButton = OptionButton(buttonRect: exitRect,
            outlineColor: buttonOColor, fillColor: buttonColor,
            lineWidth: 4, startZ: 2)
        exitButton?.setText("EXIT", textSize: 40,
            textColor: textColor, textColorS: textSColor,
            textPos: CGPoint(x: GameSize!.width/2, y: exitLabelY - 10))
        if let eb = exitButton {
            self.addChild(eb)
        }
    }
    
    private func CreateSoundOption() {
        soundButton = OptionButton(buttonRect: soundRect,
            outlineColor: buttonOColor, fillColor: buttonColor,
            lineWidth: 4, startZ: 2)
        soundLabel = GameLabel(text: "SOUND", size:40,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: textColor, shadowColor: textSColor,
            pos: CGPoint(x: GameSize!.width/2 - 135, y: checkBoxY - 10), zPosition: 4)
        if let sb = soundButton {
            self.addChild(sb)
        }
        if let sl = soundLabel {
            self.addChild(sl)
        }
    }
    
    private func CreateShakeOption() {
        shakeButton = OptionButton(buttonRect: shakeRect,
            outlineColor: buttonOColor, fillColor: buttonColor,
            lineWidth: 4, startZ: 2)
        shakeLabel = GameLabel(text: "SHAKE", size:40,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: textColor, shadowColor: textSColor,
            pos: CGPoint(x: GameSize!.width/2 + 65, y: checkBoxY - 10), zPosition: 4)
        if let shb = shakeButton {
            self.addChild(shb)
        }
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
        
        let pmRect = CGRect(x: oneThirdX-130, y: GameSize!.height/2-250,
            width: GameSize!.width-(2*(oneThirdX-130)), height: 500)
        let pauseMenu = getRoundedRectShape(pmRect, cornerRadius: 16,
            color: pauseOColor, lineWidth: 10)
        pauseMenu.fillColor = pauseColor
        pauseMenu.zPosition = 2
        addChild(pauseMenu)
        CreateGamePausedLabel()
        
        CreateResumeButton()
        CreateRestartButton()
        CreateExitButton()
        CreateSoundOption()
        CreateShakeOption()
        
        if GS.SoundOn {
            addChild(soundCheck)
        }
        if GS.ShakeOn {
            addChild(shakeCheck)
        }
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