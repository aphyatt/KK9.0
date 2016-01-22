//
//  GameKitHelper.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 1/6/16.
//  Copyright © 2016 ADAM HYATT. All rights reserved.
//

import GameKit
import Foundation

let PresentAuthenticationViewController = "PresentAuthenticationViewController"
let singleton = GameKitHelper()

class GameKitHelper: NSObject, GKGameCenterControllerDelegate {
    
    var authenticationViewController: UIViewController?
    var lastError: NSError?
    var gameCenterEnabled: Bool
    
    class var sharedInstance: GameKitHelper {
        return singleton
    }
    
    override init() {
        gameCenterEnabled = true
        super.init()
    }
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) in
            self.lastError = error
            
            if viewController != nil {
                self.authenticationViewController = viewController
                
                NSNotificationCenter.defaultCenter().postNotificationName(PresentAuthenticationViewController,
                    object: self)
            } else if localPlayer.authenticated {
                self.gameCenterEnabled = true
            } else {
                self.gameCenterEnabled = false
            }
        }
    }
    
    func reportAchievements(achievements: [GKAchievement]) {
        if !gameCenterEnabled {
            print("Local player is not authenticated")
            return
        }
        GKAchievement.reportAchievements(achievements) {(error) in
            self.lastError = error
        }
    }
    
    func showGKGameCenterViewController(viewController: SKScene!) {
        if !gameCenterEnabled {
            print("Local player is not authenticated")
            return
        }
        
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        gameCenterViewController.viewState = .Leaderboards
        
        let vc: UIViewController = (viewController.view?.window?.rootViewController)!;
        vc.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    func reportHighscore(score: Int64) {
        if !gameCenterEnabled {
            print("Local player is not authenticated")
            return
        }
        
        let scoreReporter = GKScore(
            leaderboardIdentifier: "com.orangedude.KangarooKatch.highscore")
        scoreReporter.value = score
        scoreReporter.context = 0
        
        let scores = [scoreReporter]
        
        GKScore.reportScores(scores) {(error) in
            self.lastError = error
        }
        
    }
    
    // MARK: GKGameCenterControllerDelegate methods
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}