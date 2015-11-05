//
//  GameStatus.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 9/15/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit
var GS = GameStatus()

class GameStatus {
    //endless
    let MaxJoeyLives = 6
    let MaxBoomerangLives = 3
    var CurrJoeyLives = 6
    var CurrBoomerangLives = 3
    
    //classic
    var JoeyAmountSelected = 100
    var JoeysCaught = 0
    var JoeysLeft = 100
    var BoomersCaught = 0
    
    var CurrScore = 0
    var DiffLevel = V_EASY
    var DiffLevelSelected = V_EASY
    
    var GameMode: GameModeType = .Classic
    var GameState: GameStateType = .GameRunning
    var GameControls: ControlType = .Thumb
    
    var SoundOn: Bool = true
    var ShakeOn: Bool = true
    
    //Droplet Status
    var timeBetweenLines: NSTimeInterval = 0.5
    var totalGroupsDropped: Int = 0
    var totalLinesDropped: Int = 0
    var currLinesToDrop: Int = 0
    var lineCountBeforeDrops: Int = 0
    var eggPercentage: Int = 100
    var groupWaitTimeMin: CGFloat = 2.0
    var groupWaitTimeMax: CGFloat = 3.0
    var groupAmtMin: Int = 2
    var groupAmtMax: Int = 3
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func setClassicHighscore(highscore: Double) {
        switch GS.DiffLevel {
        case V_EASY:
            userDefaults.setValue(highscore, forKey: "CHS0")
            break
        case EASY:
            userDefaults.setValue(highscore, forKey: "CHS1")
            break
        case MED:
            userDefaults.setValue(highscore, forKey: "CHS2")
            break
        case HARD:
            userDefaults.setValue(highscore, forKey: "CHS3")
            break
        case V_HARD:
            userDefaults.setValue(highscore, forKey: "CHS4")
            break
        default:
            userDefaults.setValue(highscore, forKey: "CHS5")
            break
        }
    }
    
    func getClassicHighscore() -> Double
    {
        switch GS.DiffLevel {
        case V_EASY:
            if let highscore = userDefaults.valueForKey("CHS0")
            {return highscore as! Double}
            break
        case EASY:
            if let highscore = userDefaults.valueForKey("CHS1")
            {return highscore as! Double}
            break
        case MED:
            if let highscore = userDefaults.valueForKey("CHS2")
            {return highscore as! Double}
            break
        case HARD:
            if let highscore = userDefaults.valueForKey("CHS3")
            {return highscore as! Double}
            break
        case V_HARD:
            if let highscore = userDefaults.valueForKey("CHS4")
            {return highscore as! Double}
            break
        default:
            if let highscore = userDefaults.valueForKey("CHS5")
            {return highscore as! Double}
            break
        }
        return 0
    }
    
    func setEndlessHighscore(highscore: Int) {
        userDefaults.setValue(highscore, forKey: "EHS")
    }
    
    func getEndlessHighscore() -> Int {
        if let highscore = userDefaults.valueForKey("EHS") {
            return highscore as! Int
        }
        return 0
    }
    
    func printStatus() {
        print("Curr Joey Lives: \(CurrJoeyLives)")
        print("Curr Boomerang Lives: \(CurrBoomerangLives)")
        print("Joeys Left: \(JoeysLeft)")
        print("Curr Score: \(CurrScore)")
        print("Difficulty Level: \(DiffLevel)")
        print("Game Mode: \(GameMode)")
        print("Game State: \(GameState)")
        print("SoundOn: \(SoundOn)")
        print("ShakeOn: \(ShakeOn)")
        print("timeBetweenLines: \(timeBetweenLines)")
        print("totalGroupsDropped: \(totalGroupsDropped)")
        print("totalLinesDropped: \(totalLinesDropped)")
        print("currLinesToDrop: \(currLinesToDrop)")
        print("lineCountBeforeDrops: \(lineCountBeforeDrops)")
        print("eggPercentage: \(eggPercentage)")
        print("groupWaitTimeMin: \(groupWaitTimeMin)")
        print("groupWaitTimeMax: \(groupWaitTimeMax)")
        print("groupAmtMin: \(groupAmtMin)")
        print("groupAmtMax: \(groupAmtMax)")
    }
    
}
