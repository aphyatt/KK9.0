//
//  MainMenu.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 7/19/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import Foundation
import SpriteKit

class Settings: SKScene {
    
    let backButtonRect: CGRect
    var backButton: OptionButton?
    
    var settingsLabel: GameLabel?
    let settingsTitleY: CGFloat = 890
    
    let backButtonX: CGFloat = 180
    let backButtonY: CGFloat = 970
    
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        let background = SKSpriteNode(imageNamed: "ImageBoundary")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        addChild(background)
        
        //debugDrawPlayableArea()
    }
    
    override init(size: CGSize) {
        
        backButtonRect = CGRect(x: backButtonX - 50, y: backButtonY - 20,
            width: 100,
            height: 40)
        
        super.init(size: size)
        
        CreateSettingsLabel()
        CreateBackButton()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func CreateSettingsLabel() {
        settingsLabel = GameLabel(text: "SETTINGS", size: 70,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.blackColor(), shadowColor: SKColor.whiteColor(), shadowOffset: 3,
            pos: CGPoint(x: self.size.width/2, y: settingsTitleY), zPosition: self.zPosition+1)
        if let sl = settingsLabel {
            self.addChild(sl)
        }
    }
    
    private func CreateBackButton() {
        backButton = OptionButton(buttonRect: backButtonRect,
            outlineColor: SKColor.blackColor(), fillColor: kangColor,
            lineWidth: 4, startZ: self.zPosition+1)
        backButton?.setText("BACK", textSize: 25,
            textColor: SKColor.blackColor(), textColorS: SKColor.whiteColor(),
            textPos: CGPoint(x: backButtonX, y: backButtonY-7), shadowOffset: 2)
        if let bb = backButton {
            self.addChild(bb)
        }
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        var shade: SKShapeNode!
        var buttonTouched: Bool = false
        if(backButtonRect.contains(touchLocation)) {
            shade = drawRectangle(backButtonRect, color: SKColor.grayColor(), width: 1.0)
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
            
            if(backButtonRect.contains(touchLocation)) {
                myScene = MainMenu(size: self.size)
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
        
        let bShape = drawRectangle(backButtonRect, color: SKColor.redColor(), width: 4.0)
        addChild(bShape)
        
    }
    
    
}