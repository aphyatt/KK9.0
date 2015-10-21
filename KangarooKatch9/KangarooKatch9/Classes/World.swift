//
//  World.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/14/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

var leftRect: CGRect?
var rightRect: CGRect?
var Droplets: DropletLayer?
var TheWorld: World?
var unpauseGame: Bool = false

class World: SKNode {
    
    var Kang: Kangaroo?
    
    let pauseRect: CGRect
    var ThePauseMenu: PauseMenu?
    
    //let pauseX: CGFloat = 585
    //let pauseY: CGFloat = GameSize!.height - 80
    let pauseX: CGFloat = 120
    let pauseY: CGFloat = 20
    
    var pauseButton: SKSpriteNode?
    var pauseButtonS: SKSpriteNode?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        pauseRect = CGRect(x: pauseX, y: pauseY, width: 55, height: 55)
        
        super.init()
        
        self.name = "world"
        self.zPosition = 0
        
        let size = TheGameScene?.size
        
        leftRect = CGRect(x: 0, y: 0,
            width: size!.width/2,
            height: size!.height)
        rightRect = CGRect(x: size!.width/2, y: 0,
            width: size!.width/2,
            height: size!.height)
        
        //oneThirdX = playableMargin + (playableWidth/3)
        //twoThirdX = playableMargin + (playableWidth*(2/3))
        
        TheGameScene?.backgroundColor = SKColor.whiteColor()
        
        let background = SKSpriteNode(imageNamed: "KKbackground")
        background.position = CGPoint(x: size!.width/2, y: size!.height/2)
        background.zPosition = 1
        addChild(background)
        
        CreateKangaroo()
        CreateDropletLayer()
        CreatePauseButton()
    }
    
    func update(currentTime: CFTimeInterval) {
        switch GS.GameState {
        case .GameRunning:
            Kang!.update(currentTime)
            Droplets!.update(currentTime)
            break
        case .Paused:
            pauseGame()
            break
        case .GameOver:
            break
        }
    
    }
    
    private func CreateKangaroo() {
        Kang = Kangaroo()
        if let kangaroo = Kang {
            self.addChild(kangaroo)
        }
    }
    
    private func CreateDropletLayer() {
        Droplets = DropletLayer()
        if let drops = Droplets {
            self.addChild(drops)
        }
    }
    
    private func CreatePauseButton() {
        pauseButton = SKSpriteNode(imageNamed: "PauseButtonWhite")
        pauseButtonS = SKSpriteNode(imageNamed: "PauseButtonGray")
        if let pb = pauseButton {
            pb.position = CGPoint(x: pauseX+27, y: pauseY+27)
            pb.zPosition = self.zPosition + 101
            pb.setScale(0.38)
            pb.color = SKColor.whiteColor()
            addChild(pb)
        }
        if let pbS = pauseButtonS {
            pbS.position = CGPoint(x: pauseX+31, y: pauseY+25)
            pbS.zPosition = self.zPosition + 100
            pbS.setScale(0.38)
            pbS.color = SKColor.grayColor()
            addChild(pbS)
        }
        
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        switch GS.GameState {
        case .GameRunning:
            Kang!.sceneTouched(touchLocation)
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
            Kang!.sceneUntouched(touchLocation)
            break
        case .Paused:
            ThePauseMenu?.sceneUntouched(touchLocation)
            break
        case .GameOver:
            break
        }
    }
    
    func trackThumb(touchLocation:CGPoint) {
        if GS.GameState == .GameRunning {
            Kang!.trackThumb(touchLocation)
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
            pm.zPosition = 150
            self.addChild(pm)
        }
    }
    
    func debugRects() {
        let p = drawRectangle(pauseRect, color: SKColor.redColor(), width: 1.0)
        p.zPosition = 300
        addChild(p)
    }
    
}
