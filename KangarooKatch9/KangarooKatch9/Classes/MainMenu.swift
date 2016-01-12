//
//  MainMenu.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 7/19/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {
    let normalRect: CGRect
    let multiRect: CGRect
    let settingsRect: CGRect
    let gameCenterRect: CGRect
    let playableRect: CGRect
    
    var normalButton: OptionButton?
    var multiButton: OptionButton?
    var settingsButton: OptionButton?
    var gameCenterButton: OptionButton?
    
    let normalY: CGFloat = 720
    let multiY: CGFloat = 480
    let settingsY: CGFloat = 240
    let gameCenterY: CGFloat = 240
    
    let buttonColor: UIColor = kangColor
    let buttonOColor: UIColor = SKColor.blackColor()
    let textColor: UIColor = SKColor.blackColor()
    let textSColor: UIColor = SKColor.whiteColor()
    let buttonWidth: CGFloat = 480
    let smallButtonWidth: CGFloat = 225
    let buttonHeight: CGFloat = 165
    let smallButtonHeight: CGFloat = 135
    let fontSize: CGFloat = 70
    let smallFontSize: CGFloat = 35
    
    override func didMoveToView(view: SKView) {
        if (TheGameScene != nil) {
            TheGameScene?.removeFromParent()
        }
        
        backgroundColor = SKColor.whiteColor()
        let background = SKSpriteNode(imageNamed: "MainMenu")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        addChild(background)
        
        //debugDrawPlayableArea()
    }
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let playableMargin = (size.width-playableWidth)/2.0
        print(playableMargin)
        print(playableMargin+playableWidth)
        print(size.height)
        playableRect = CGRect(x: playableMargin, y: 0, width: playableWidth, height: size.height)
        normalRect = CGRect(x: size.width/2 - buttonWidth/2,
            y: normalY - buttonHeight/2,
            width: buttonWidth,
            height: buttonHeight)
        multiRect = CGRect(x: size.width/2 - buttonWidth/2,
            y: multiY - buttonHeight/2,
            width: buttonWidth,
            height: buttonHeight)
        settingsRect = CGRect(x: playableMargin + playableWidth/4 - smallButtonWidth/2,
            y: settingsY - buttonHeight/2,
            width: smallButtonWidth,
            height: smallButtonHeight)
        gameCenterRect = CGRect(x: playableMargin + (3*playableWidth)/4 - smallButtonWidth/2,
            y: gameCenterY - buttonHeight/2,
            width: smallButtonWidth,
            height: smallButtonHeight)
        
        super.init(size: size)
        
        CreateMainMenu()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func CreateNormalButton() {
        normalButton = OptionButton(buttonRect: normalRect,
            outlineColor: buttonOColor, fillColor: buttonColor,
            lineWidth: 4, startZ: 2)
        normalButton?.setText("PLAY", textSize: fontSize,
            textColor: textColor, textColorS: textSColor,
            textPos: CGPoint(x: size.width/2, y: normalY-15), shadowOffset: 3)
        if let nb = normalButton {
            self.addChild(nb)
        }
    }
    
    private func CreateMultiButton() {
        multiButton = OptionButton(buttonRect: multiRect,
            outlineColor: buttonOColor, fillColor: buttonColor,
            lineWidth: 4, startZ: 2)
        multiButton?.setText("MULTIPLAYER", textSize: fontSize,
            textColor: textColor, textColorS: textSColor,
            textPos: CGPoint(x: size.width/2, y: multiY-15), shadowOffset: 3)
        if let mb = multiButton {
            self.addChild(mb)
        }
    }
    
    private func CreateSettingsButton() {
        settingsButton = OptionButton(buttonRect: settingsRect,
            outlineColor: buttonOColor, fillColor: buttonColor,
            lineWidth: 4, startZ: 2)
        settingsButton?.setText("SETTINGS", textSize: smallFontSize,
            textColor: textColor, textColorS: textSColor,
            textPos: CGPoint(x: size.width/2 - 145, y: settingsY-20), shadowOffset: 2)
        if let sb = settingsButton {
            self.addChild(sb)
        }
    }
    
    private func CreateGameCenterButton() {
        gameCenterButton = OptionButton(buttonRect: gameCenterRect,
            outlineColor: buttonOColor, fillColor: buttonColor,
            lineWidth: 4, startZ: 2)
        gameCenterButton?.setText("GAME CENTER", textSize: smallFontSize,
            textColor: textColor, textColorS: textSColor,
            textPos: CGPoint(x: size.width/2 + 145, y: gameCenterY-20), shadowOffset: 2)
        if let gcb = gameCenterButton {
            self.addChild(gcb)
        }
    }
    
    func CreateMainMenu() {
        
        CreateNormalButton()
        CreateMultiButton()
        CreateSettingsButton()
        CreateGameCenterButton()
        
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        var shade: SKShapeNode!
        var buttonTouched: Bool = false
        if(normalRect.contains(touchLocation)) {
            shade = drawRectangle(normalRect, color: SKColor.grayColor(), width: 1.0)
            buttonTouched = true
        }
        else if(multiRect.contains(touchLocation)) {
            shade = drawRectangle(multiRect, color: SKColor.grayColor(), width: 1.0)
            buttonTouched = true
        }
        else if(settingsRect.contains(touchLocation)) {
            shade = drawRectangle(settingsRect, color: SKColor.grayColor(), width: 1.0)
            buttonTouched = true
        }
        else if(gameCenterRect.contains(touchLocation)) {
            shade = drawRectangle(gameCenterRect, color: SKColor.grayColor(), width: 1.0)
            buttonTouched = true
        }
        
        if buttonTouched {
            shade.fillColor = SKColor.grayColor()
            shade.alpha = 0.4
            shade.name = "buttonDown"
            shade.zPosition = 4
            addChild(shade)
            buttonTouched = false
        }
        
    }
    
    func sceneUntouched(touchLocation:CGPoint) {
        let shade = childNodeWithName("buttonDown")
        if (shade != nil) {
            shade!.removeFromParent()
            
            var myScene: SKScene!
            if(normalRect.contains(touchLocation)) {
                GS.GameMode = .Normal
                myScene = GameScene(size: self.size)
                myScene.scaleMode = self.scaleMode
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                self.view?.presentScene(myScene, transition: reveal)
            }
            else if(multiRect.contains(touchLocation)) {
                //multiplayer scene (?) good luck...
            }
            else if(settingsRect.contains(touchLocation)) {
                myScene = Settings(size: self.size)
                myScene.scaleMode = self.scaleMode
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                self.view?.presentScene(myScene, transition: reveal)
            }
            else if(gameCenterRect.contains(touchLocation)) {
                GameKitHelper.sharedInstance.showGKGameCenterViewController(
                    self)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.locationInNode(self)
        sceneTouched(touchLocation)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.locationInNode(self)
        sceneUntouched(touchLocation)
    }
    
    func debugDrawPlayableArea() {
        let eShape = drawRectangle(normalRect, color: SKColor.redColor(), width: 4.0)
        addChild(eShape)
        
        let mShape = drawRectangle(multiRect, color: SKColor.redColor(), width: 4.0)
        addChild(mShape)
        
        let sShape = drawRectangle(settingsRect, color: SKColor.redColor(), width: 4.0)
        addChild(sShape)
        
        let gcShape = drawRectangle(gameCenterRect, color: SKColor.redColor(), width: 4.0)
        addChild(gcShape)
        
        let pShape = drawRectangle(playableRect, color: SKColor.whiteColor(), width: 5.0)
        addChild(pShape)
    }
    
    
}