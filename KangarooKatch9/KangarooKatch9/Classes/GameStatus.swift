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
    
    var CurrScore = 0
    var DiffLevel = V_EASY
    
    var GameMode: GameModeType = .Normal
    var GameState: GameStateType = .GameRunning
    var GameControls: ControlType = .OneHand
    
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
    
    func setHighscore(highscore: Int) {
        userDefaults.setValue(highscore, forKey: "HS")
    }
    
    func getHighscore() -> Int {
        if let highscore = userDefaults.valueForKey("HS") {
            return highscore as! Int
        }
        return 0
    }
    
    func printStatus() {
        print("Curr Joey Lives: \(CurrJoeyLives)")
        print("Curr Boomerang Lives: \(CurrBoomerangLives)")
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
