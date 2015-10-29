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
    let classicRect: CGRect
    let endlessRect: CGRect
    let multiRect: CGRect
    let settingsRect: CGRect
    
    var classicButton: OptionButton?
    var endlessButton: OptionButton?
    var multiButton: OptionButton?
    var settingsButton: OptionButton?
    let classicY: CGFloat = 760
    let endlessY: CGFloat = 580
    let multiY: CGFloat = 400
    let settingsY: CGFloat = 220
    
    let buttonColor: UIColor = kangColor
    let buttonOColor: UIColor = SKColor.blackColor()
    let textColor: UIColor = SKColor.blackColor()
    let textSColor: UIColor = SKColor.whiteColor()
    let buttonWidth: CGFloat = 500
    let buttonHeight: CGFloat = 100
    let fontSize: CGFloat = 55
    
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
        classicRect = CGRect(x: size.width/2 - buttonWidth/2,
            y: classicY - buttonHeight/2,
            width: buttonWidth,
            height: buttonHeight)
        endlessRect = CGRect(x: size.width/2 - buttonWidth/2,
            y: endlessY - buttonHeight/2,
            width: buttonWidth,
            height: buttonHeight)
        multiRect = CGRect(x: size.width/2 - buttonWidth/2,
            y: multiY - buttonHeight/2,
            width: buttonWidth,
            height: buttonHeight)
        settingsRect = CGRect(x: size.width/2 - buttonWidth/2,
            y: settingsY - buttonHeight/2,
            width: buttonWidth,
            height: buttonHeight)
        
        super.init(size: size)
        
        CreateMainMenu()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func CreateClassicButton() {
        classicButton = OptionButton(buttonRect: classicRect,
            outlineColor: buttonOColor, fillColor: buttonColor,
            lineWidth: 4, startZ: 2)
        classicButton?.setText("CLASSIC MODE", textSize: fontSize,
            textColor: textColor, textColorS: textSColor,
            textPos: CGPoint(x: size.width/2, y: classicY-15))
        if let cb = classicButton {
            self.addChild(cb)
        }
    }
    
    private func CreateEndlessButton() {
        classicButton = OptionButton(buttonRect: endlessRect,
            outlineColor: buttonOColor, fillColor: buttonColor,
            lineWidth: 4, startZ: 2)
        classicButton?.setText("ENDLESS MODE", textSize: fontSize,
            textColor: textColor, textColorS: textSColor,
            textPos: CGPoint(x: size.width/2, y: endlessY-15))
        if let cb = classicButton {
            self.addChild(cb)
        }
    }
    
    private func CreateMultiButton() {
        classicButton = OptionButton(buttonRect: multiRect,
            outlineColor: buttonOColor, fillColor: buttonColor,
            lineWidth: 4, startZ: 2)
        classicButton?.setText("MULTIPLAYER MODE", textSize: fontSize,
            textColor: textColor, textColorS: textSColor,
            textPos: CGPoint(x: size.width/2, y: multiY-15))
        if let cb = classicButton {
            self.addChild(cb)
        }
    }
    
    private func CreateSettingsButton() {
        classicButton = OptionButton(buttonRect: settingsRect,
            outlineColor: buttonOColor, fillColor: buttonColor,
            lineWidth: 4, startZ: 2)
        classicButton?.setText("SETTINGS", textSize: fontSize,
            textColor: textColor, textColorS: textSColor,
            textPos: CGPoint(x: size.width/2, y: settingsY-15))
        if let cb = classicButton {
            self.addChild(cb)
        }
    }
    
    func CreateMainMenu() {
        
        CreateClassicButton()
        CreateEndlessButton()
        CreateMultiButton()
        CreateSettingsButton()
        
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        var shade: SKShapeNode!
        var buttonTouched: Bool = false
        if(classicRect.contains(touchLocation)) {
            shade = drawRectangle(classicRect, color: SKColor.grayColor(), width: 1.0)
            buttonTouched = true
        }
        else if(endlessRect.contains(touchLocation)) {
            shade = drawRectangle(endlessRect, color: SKColor.grayColor(), width: 1.0)
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
            if(classicRect.contains(touchLocation)) {
                GS.GameMode = .Classic
                //Create menus for diff->amount->then go
                GS.DiffLevelSelected = MED
                GS.JoeyAmountSelected = 100
                myScene = GameScene(size: self.size)
                myScene.scaleMode = self.scaleMode
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                self.view?.presentScene(myScene, transition: reveal)
            }
            else if(endlessRect.contains(touchLocation)) {
                GS.GameMode = .Endless
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
        let cShape = drawRectangle(classicRect, color: SKColor.redColor(), width: 4.0)
        addChild(cShape)
        
        let eShape = drawRectangle(endlessRect, color: SKColor.redColor(), width: 4.0)
        addChild(eShape)
        
        let mShape = drawRectangle(multiRect, color: SKColor.redColor(), width: 4.0)
        addChild(mShape)
        
        let sShape = drawRectangle(settingsRect, color: SKColor.redColor(), width: 4.0)
        addChild(sShape)
  
    }
    
    
}