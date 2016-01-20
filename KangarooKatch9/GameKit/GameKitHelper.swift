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

protocol GameKitHelperDelegate {
    func matchStarted()
    func matchEnded()
    func matchReceivedData(match: GKMatch, data: NSData, fromPlayer player: String)
}

class GameKitHelper: NSObject, GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate, GKMatchDelegate {
    
    var authenticationViewController: UIViewController?
    var lastError: NSError?
    var gameCenterEnabled: Bool
    
    var delegate: GameKitHelperDelegate?
    var multiplayerMatch: GKMatch?
    var presentingViewController: UIViewController?
    var multiplayerMatchStarted: Bool
    
    class var sharedInstance: GameKitHelper {
        return singleton
    }
    
    override init() {
        gameCenterEnabled = true
        multiplayerMatchStarted = false
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
    
    func findMatch(presentingViewController viewController: UIViewController,
        delegate: GameKitHelperDelegate) {
            
            if !gameCenterEnabled {
                print("Local player is not authenticated")
                return
            }
            
            multiplayerMatchStarted = false
            multiplayerMatch = nil
            self.delegate = delegate
            presentingViewController = viewController
            
            let matchRequest = GKMatchRequest()
            matchRequest.minPlayers = 2
            matchRequest.maxPlayers = 2
            
            let matchMakerViewController = GKMatchmakerViewController(matchRequest: matchRequest)
            matchMakerViewController!.matchmakerDelegate = self
            presentingViewController?.presentViewController(matchMakerViewController!, animated: false, completion:nil)
    }
    
    // MARK: GKGameCenterControllerDelegate methods
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: GKMatchmakerViewControllerDelegate methods
    func matchmakerViewControllerWasCancelled(viewController: GKMatchmakerViewController) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        delegate?.matchEnded()
    }
    
    func matchmakerViewController(viewController: GKMatchmakerViewController, didFailWithError error: NSError) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        print("Error creating a match: \(error.localizedDescription)")
        delegate?.matchEnded()
    }
    
    func matchmakerViewController(viewController: GKMatchmakerViewController, didFindMatch match: GKMatch) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        multiplayerMatch = match
        multiplayerMatch!.delegate = self
        
        if !multiplayerMatchStarted && multiplayerMatch?.expectedPlayerCount == 0 {
            print("Ready to start the match")
            multiplayerMatchStarted = true
            delegate?.matchStarted()
        }
    }
    
    // MARK: GKMatchDelegate methods
    func match(match: GKMatch, didReceiveData data: NSData, fromPlayer playerID: String) {
        if multiplayerMatch != match {
            return
        }
        delegate?.matchReceivedData(match, data: data, fromPlayer: playerID)
    }
    
    func match(match: GKMatch, didFailWithError error: NSError?) {
        if multiplayerMatch != match {
            return
        }
        multiplayerMatchStarted = false
        delegate?.matchEnded()
    }
    
    func match(match: GKMatch, player playerID: String, didChangeState state: GKPlayerConnectionState) {
        if multiplayerMatch != match {
            return
        }
            
        switch state {
        case .StateConnected:
            print("Player connected")
            if !multiplayerMatchStarted && multiplayerMatch?.expectedPlayerCount == 0 {
                print("Ready to start the match")
            }
        case .StateDisconnected:
            print("Player disconnected")
            multiplayerMatchStarted = false
            delegate?.matchEnded()
        case .StateUnknown:
            print("Initial player state")
        }
    }
    
    
    
}