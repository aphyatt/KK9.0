//
//  dropletLayer.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/14/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

//Difficulty variables
var changeDiff: Bool = false
let V_EASY = 0
let EASY = 1
let MED = 2
let HARD = 3
let V_HARD = 4
let EXTREME = 5

//Droplet types and arrays
let SPACE = 0
let JOEY = 1
let BOOMERANG = 2

var dropLines: Bool = false
var TheDropletLayer: DropletLayer?

class DropletLayer: SKNode {
    
    var catchZoneRect: CGRect = CGRectNull
    var fadeZoneRect: CGRect = CGRectNull
    var eggInitSize: CGSize = CGSize(width: 40.0, height: 50.2)
    
    //Variables affecting speed / frequency of droplet lines
    var checkDiffCalls: Int = 1
    var dropID: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        super.init()
        
        TheDropletLayer = self
        
        self.name = "droplets"
        self.zPosition = 50
      
        catchZoneRect = CGRect(x: playableMargin, y: dropletCatchBoundaryY - 3,
            width: playableWidth,
            height: 6)
        fadeZoneRect = CGRect(x: playableMargin, y: dropletFadeBoundaryY - 5,
            width: playableWidth,
            height: 10)
   
        changeDiff = false
        initDifficulty()
        dropLines = true
        
    }
    
    func update(currentTime: CFTimeInterval) {
        switch GS.GameState {
        case .GameRunning:
            if (changeDiff) {
                changeDifficulty()
            }
            if (GS.totalLinesDropped - GS.lineCountBeforeDrops) == GS.currLinesToDrop {
                dropNewGroup()
            }
            break
        case .Paused:
            break
        case .GameOver:
            break
        default: break
        }
    }
    
    
    func initDifficulty() {
        GS.timeBetweenLines = 0.5
        TheGameScene!.physicsWorld.gravity.dy = -7.8
        GS.groupWaitTimeMax = 3
        GS.groupWaitTimeMin = 2
        GS.eggPercentage = 100
    }
    
    func changeDifficulty() {
        if GS.DiffLevel < EXTREME {
            GS.timeBetweenLines -= 0.04
            TheGameScene!.physicsWorld.gravity.dy -= 1.2
            GS.groupWaitTimeMax -= 0.2
            GS.groupWaitTimeMin -= 0.2
            GS.groupAmtMin = (GS.groupAmtMin*2 - 1)
            GS.groupAmtMax = (GS.groupAmtMin*2 - 1)
            GS.DiffLevel++
        }
        else {
            GS.timeBetweenLines -= 0.03
            TheGameScene!.physicsWorld.gravity.dy -= 0.9
            GS.groupAmtMin = (GS.groupAmtMin*2 - 1)
            GS.groupAmtMax = (GS.groupAmtMin*2 - 1)
        }
        
        switch GS.DiffLevel {
        case V_EASY: GS.eggPercentage = 100
            break
        case EASY: GS.eggPercentage = 70
            break
        case MED: GS.eggPercentage = 70
            break
        case HARD: GS.eggPercentage = 75
            break
        case V_HARD: GS.eggPercentage = 90
            break
        default: GS.eggPercentage = 90
            break
        }
        
        print("Diff Changed to \(GS.DiffLevel)")
        GS.printStatus()
        changeDiff = false
    }
    
    func updateDifficulty() {
        var groupRepeat: Int?
        switch GS.DiffLevel {
        case V_EASY:
            groupRepeat = 10
            break
        case EASY:
            groupRepeat = 10
            break
        case MED:
            groupRepeat = 10
            break
        case HARD:
            groupRepeat = 7
            break
        case V_HARD:
            groupRepeat = 5
            break
        default:
            groupRepeat = 1
        }
        
        if checkDiffCalls >= groupRepeat {
            checkDiffCalls = 1
            changeDiff = true
        }
        else {
            checkDiffCalls++
        }
    }
    
    /******************************************************************************
    * DROP NEW GROUP
    * Function drops new group, calls:
    * dropRandomLine: gets random line and drops
    * then groups a determined amount of these into one action
    *******************************************************************************/
    func dropNewGroup() {
    
        updateDifficulty()
        
        let linesToDrop: Int?
        let waitBeforeGroup: NSTimeInterval?
        if GS.totalLinesDropped == 0 {
            linesToDrop = 1
            waitBeforeGroup = 0.0
        }
        else {
            linesToDrop = randomInt(GS.groupAmtMin, max: GS.groupAmtMax)
            waitBeforeGroup = NSTimeInterval(CGFloat.random(GS.groupWaitTimeMin, max: GS.groupWaitTimeMax))
        }
        
        let groupSequence = SKAction.sequence([SKAction.runBlock({self.dropRandomLine()}), SKAction.waitForDuration(GS.timeBetweenLines)])
        let groupAction = SKAction.repeatAction(groupSequence, count: linesToDrop!)
        let finalAction = SKAction.sequence([SKAction.waitForDuration(waitBeforeGroup!), groupAction])
        
        //save variables to check when you can drop another group
        GS.currLinesToDrop = linesToDrop!
        GS.lineCountBeforeDrops = GS.totalLinesDropped
        GS.totalGroupsDropped++
        
        //println("Droping group size: \(linesToDrop), waitBeforeGroup: \(waitBeforeGroup)")
        runAction(finalAction)
    }
    
    /*********************** Drop Group Helper Functions ******************************/
    
     //TODO: figure out how to save lines to drop after resuming a pause
    /*
    * Drops random line chosen from pickRandomLine() by making
    * three simultaneous calls to spawnDroplet
    */
    func dropRandomLine() {
        if(dropLines) {
            let chosenLine = pickRandomLine()
        
            let dropLeft = SKAction.runBlock({self.spawnDroplet(1, type: chosenLine[0])})
            let dropMiddle = SKAction.runBlock({self.spawnDroplet(2, type: chosenLine[1])})
            let dropRight = SKAction.runBlock({self.spawnDroplet(3, type: chosenLine[2])})
        
            let dropLine = SKAction.group([dropLeft, dropMiddle, dropRight])
            runAction(dropLine)
            //runAction(dropLineSound) whistle down
        
            GS.totalLinesDropped++;
        }
    }
    
    /*
    * Fetches all possible lines based on diffLevel and
    * uses eggPercentage algorithm to return one of them
    */
    var lastIndexPicked: Int = 0
    func pickRandomLine() -> [Int] {
        let percentage: Int = randomInt(1, max: 100)
        let linesForDifficulty: [[Int]]
        if percentage <= GS.eggPercentage { linesForDifficulty = difficultyArraysG[GS.DiffLevel] }
        else { linesForDifficulty = difficultyArraysB[GS.DiffLevel] }
        
        var randomIndex: Int = Int(arc4random_uniform(UInt32(linesForDifficulty.endIndex)))
        
        if GS.DiffLevel > EASY {
            if randomIndex == lastIndexPicked {
                if randomIndex == 0 { randomIndex++ }
                else { randomIndex-- }
            }
        }
        lastIndexPicked = randomIndex
        return linesForDifficulty[randomIndex]
    }
    
    /*
    * Adds child with physics body of individual droplet
    * to the top of the screen
    */
    
    func spawnDroplet(col: Int, type: Int) {
        var drop: Droplet!
        var somethingDropped = true
        switch type {
        case JOEY:
            drop = Droplet(imageNamed: "Egg")
            drop.name = "joey"
            drop.setScale(0.1)
            break
        case BOOMERANG:
            drop = Droplet(imageNamed: "Boomerang")
            drop.name = "boomerang"
            drop.setScale(0.2)
            break
        default:
            somethingDropped = false
        }
        
        if somethingDropped {
            drop.zPosition = self.zPosition + 3
            var dropletPosX: CGFloat = rightColX
            if(col == 1) {
                dropletPosX = leftColX
            }
            else if(col == 2) {
                dropletPosX = midColX
            }
            drop.position = CGPoint(
                x: dropletPosX,
                y: GameSize!.height + drop.size.height/2)
            
            if(type == JOEY) {
                //Joey animation here
                drop.zRotation = -π / 8.0
                let leftWiggle = SKAction.rotateByAngle(π/4.0, duration: 0.25)
                let rightWiggle = leftWiggle.reversedAction()
                let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle, leftWiggle, rightWiggle])
                let scaleUp = SKAction.scaleBy(1.1, duration: 0.25)
                let scaleDown = scaleUp.reversedAction()
                let fullScale = SKAction.sequence(
                    [scaleUp, scaleDown, scaleUp, scaleDown])
                let group = SKAction.group([fullScale, fullWiggle])
                drop.runAction(SKAction.repeatActionForever(group))
            }
            if(type == BOOMERANG) {
                let halfSpin = SKAction.rotateByAngle(π, duration: 0.5)
                let fullSpin = SKAction.sequence([halfSpin, halfSpin])
                drop.runAction(SKAction.repeatActionForever(fullSpin))
            }
            
            drop.physicsBody = SKPhysicsBody(circleOfRadius: drop.size.width/2)
            addChild(drop)
            
        }
    }
    
    /*********************************************************************************************************
    * CHECK COLLISIONS
    * Function for determining collisions between Kangaroo and droplets
    *********************************************************************************************************/
    func checkCollisions() {
        
        var caughtJoeys: [Droplet] = []
        var missedJoeys: [Droplet] = []
        var fadeJoeys: [Droplet] = []
        var caughtBoomers: [Droplet] = []
        var missedBoomers: [Droplet] = []
        
        enumerateChildNodesWithName("*") { node, _ in
            if node.name == "joey" {
                let joey = node as! Droplet
                if (Int(joey.position.x+0.1) == Int(kangPosX)) {
                    if CGRectIntersectsRect(CGRectInset(joey.frame, 5, 5), self.catchZoneRect) {
                        caughtJoeys.append(joey)
                        joey.name = "done"
                    }
                    else if joey.position.y < dropletCatchBoundaryY {
                        missedJoeys.append(joey)
                        joey.name = "missedJoey"
                    }
                }
                else {
                    if joey.position.y < dropletCatchBoundaryY {
                        missedJoeys.append(joey)
                        joey.name = "missedJoey"
                    }
                }
            }
            if node.name == "missedJoey" {
                let joey = node as! Droplet
                if CGRectIntersectsRect(CGRectInset(joey.frame, 5, 5), self.fadeZoneRect) {
                    fadeJoeys.append(joey)
                    joey.name = "done"
                }
            }
            if node.name == "boomerang" {
                let boomer = node as! Droplet
                if (Int(boomer.position.x+0.1) == Int(kangPosX)) {
                    if CGRectIntersectsRect(CGRectInset(boomer.frame, 5, 5), self.catchZoneRect) {
                        caughtBoomers.append(boomer)
                        boomer.name = "done"
                    }
                    else if boomer.position.y < dropletCatchBoundaryY {
                        missedBoomers.append(boomer)
                        boomer.name = "done"
                    }
                }
                else {
                    if boomer.position.y < dropletCatchBoundaryY {
                        missedBoomers.append(boomer)
                        boomer.name = "done"
                    }
                }
            }
        }
        
        for joey in caughtJoeys {
            kangarooCaughtJoey(joey)
        }
        for joey in missedJoeys {
            kangarooMissedJoey(joey)
        }
        for joey in fadeJoeys {
            stopAndFadeJoey(joey)
        }
        for boomer in caughtBoomers {
            kangarooCaughtBoomer(boomer)
        }
        for boomer in missedBoomers {
            kangarooMissedBoomer(boomer)
        }
        
    }
    
    //Can use pouch idea where joey falls behind pouch and detection is near entrance
    func kangarooCaughtJoey(joey: Droplet) {
        //runAction(caughtJoeySound)
        
        let jumpUp = SKAction.moveByX(0.0, y: 10.0, duration: 0.1)
        let jumpDown = jumpUp.reversedAction()
        let catchAction = SKAction.sequence([jumpUp, jumpDown])
        TheKangaroo!.runAction(catchAction)
        
        joey.removeAllActions()
        joey.runAction(SKAction.removeFromParent())
        
        GS.CurrScore++
        TheHUD?.updateScore()
        
    }
    
    func kangarooMissedJoey(joey: Droplet) {
        //runAction(missedJoeySound) aaahh
        
        //make fade rect like catchzone, in checkcollision if missed hits fadezone, then stop and fade
        let fade = SKAction.fadeAlphaTo(0.3, duration: 0.1)
        joey.runAction(fade)
        
    }
    
    func stopAndFadeJoey(joey: SKSpriteNode) {
        joey.removeFromParent()
        joey.removeAllActions()
        joey.physicsBody = nil
        joey.zRotation = 0
        joey.alpha = 0.3
        joey.position.y = dropletFadeBoundaryY
        //change joey to have frown?
        addChild(joey)
        
        TheHUD?.removeLife("drop\(GS.CurrJoeyLives)")
        GS.CurrJoeyLives--
    
        if(GS.CurrJoeyLives == 0) {
            GS.GameState = .GameOver
        }
        
    }
    
    func kangarooCaughtBoomer(boomer: Droplet) {
        
        //runAction(enemyCollisionSound) ouch!
        // make kangaroo frown

        //not working for some reason after pause...
        TheGameScene!.shakeScreen()
        
        boomer.removeAllActions()
        boomer.runAction(SKAction.removeFromParent())
        
        TheHUD?.removeLife("life\(GS.CurrBoomerangLives)")
        GS.CurrBoomerangLives--
            
        if(GS.CurrBoomerangLives == 0) {
            boomDeath = true
            GS.GameState = .GameOver
        }
  
    }
    
    func kangarooMissedBoomer(boomer: Droplet) {
        let fade = SKAction.fadeAlphaTo(0.0, duration: 0.18)
        let remove = SKAction.removeFromParent()
        boomer.runAction(SKAction.sequence([fade, remove]))
    }
    
    internal func freezeDroplets() {
        removeAllActions()
        enumerateChildNodesWithName("*") { node, _ in
            if node.name == "joey" || node.name == "missedJoey" ||
                node.name == "boomerang" || node.name == "missedBoomer" {
                    let node = node as! Droplet
                    if node.physicsBody?.velocity != nil {
                        node.gravSpeed = (node.physicsBody?.velocity)!
                    }
                    node.removeAllActions()
                    node.physicsBody = nil
            }
        }
    }
    
    internal func unfreezeDroplets() {
        enumerateChildNodesWithName("*") { node, _ in
            if node.name == "joey" || node.name == "missedJoey" {
                let node = node as! Droplet
                node.zRotation = -π / 8.0
                node.size = self.eggInitSize
                let leftWiggle = SKAction.rotateByAngle(π/4.0, duration: 0.25)
                let rightWiggle = leftWiggle.reversedAction()
                let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle, leftWiggle, rightWiggle])
                let scaleUp = SKAction.scaleBy(1.1, duration: 0.25)
                let scaleDown = scaleUp.reversedAction()
                let fullScale = SKAction.sequence(
                    [scaleUp, scaleDown, scaleUp, scaleDown])
                let group = SKAction.group([fullScale, fullWiggle])
                node.runAction(SKAction.repeatActionForever(group))
                node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
                node.physicsBody?.velocity = node.gravSpeed
            }
            if node.name == "boomerang" || node.name == "missedBoomer" {
                let node = node as! Droplet
                let halfSpin = SKAction.rotateByAngle(π, duration: 0.5)
                let fullSpin = SKAction.sequence([halfSpin, halfSpin])
                node.runAction(SKAction.repeatActionForever(fullSpin))
                node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
                node.physicsBody?.velocity = node.gravSpeed
            }
        }
    }

}
