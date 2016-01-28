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
    
    let twoHandsControlRect: CGRect
    var twoHandsControlButton: OptionButton?
    let oneHandControlRect: CGRect
    var oneHandControlButton: OptionButton?
    
    var settingsLabel: GameLabel?
    let settingsTitleY: CGFloat = 890
    
    let backButtonX: CGFloat = 180
    let backButtonY: CGFloat = 970
    
    let oneHandControlX: CGFloat = 254
    let twoHandsControlX: CGFloat = 514
    let controlButtonY: CGFloat = 710
    
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
        twoHandsControlRect = CGRect(x: twoHandsControlX - 110, y: controlButtonY-40,
            width: 220, height: 80)
        oneHandControlRect = CGRect(x: oneHandControlX - 110, y: controlButtonY-40,
            width: 220, height: 80)
        
        super.init(size: size)
        
        CreateSettingsLabel()
        CreateControlsLabel()
        CreateBackButton()
        CreateTwoHandsControlButton()
        CreateOneHandControlButton()
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
    
    private func CreateControlsLabel() {
        settingsLabel = GameLabel(text: "CONTROLS:", size: 45,
            horAlignMode: .Center, vertAlignMode: .Baseline,
            color: SKColor.blackColor(), shadowColor: SKColor.whiteColor(), shadowOffset: 3,
            pos: CGPoint(x: self.size.width/2 - 150, y: 780), zPosition: self.zPosition+1)
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
    
    private func CreateTwoHandsControlButton() {
        twoHandsControlButton = OptionButton(buttonRect: twoHandsControlRect,
            outlineColor: SKColor.blackColor(), fillColor: kangColor,
            lineWidth: 4, startZ: self.zPosition+1)
        twoHandsControlButton?.setText("TWO THUMBS", textSize: 33,
            textColor: SKColor.blackColor(), textColorS: SKColor.whiteColor(),
            textPos: CGPoint(x: twoHandsControlX, y: controlButtonY-9), shadowOffset: 2)
        if let thb = twoHandsControlButton {
            self.addChild(thb)
        }
        if GS.GameControls == .TwoHands {
            twoHandsControlButton!.showHighlight()
        }
    }
    
    private func CreateOneHandControlButton() {
        oneHandControlButton = OptionButton(buttonRect: oneHandControlRect,
            outlineColor: SKColor.blackColor(), fillColor: kangColor,
            lineWidth: 4, startZ: self.zPosition+1)
        oneHandControlButton?.setText("SWIPE", textSize: 40,
            textColor: SKColor.blackColor(), textColorS: SKColor.whiteColor(),
            textPos: CGPoint(x: oneHandControlX, y: controlButtonY-9), shadowOffset: 2)
        if let ohb = oneHandControlButton {
            self.addChild(ohb)
        }
        if GS.GameControls == .OneHand {
            oneHandControlButton!.showHighlight()
        }
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        if(backButtonRect.contains(touchLocation)) {
            backButton!.click()
        }
        if(twoHandsControlRect.contains(touchLocation)) {
            twoHandsControlButton!.click()
        }
        if(oneHandControlRect.contains(touchLocation)) {
            oneHandControlButton!.click()
        }
    }
    
    func sceneUntouched(touchLocation:CGPoint) {
        var myScene: SKScene!
        
        if(backButtonRect.contains(touchLocation)) {
            myScene = MainMenu(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        if(twoHandsControlRect.contains(touchLocation)) {
            GS.GameControls = .TwoHands
            twoHandsControlButton!.unclick()
            twoHandsControlButton!.showHighlight()
            oneHandControlButton!.removeHighlight()
        }
        if(oneHandControlRect.contains(touchLocation)) {
            GS.GameControls = .OneHand
            oneHandControlButton!.unclick()
            oneHandControlButton!.showHighlight()
            twoHandsControlButton!.removeHighlight()
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