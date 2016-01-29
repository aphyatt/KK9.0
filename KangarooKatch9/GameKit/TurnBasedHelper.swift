//
//  TurnBasedHelper.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 1/21/16.
//  Copyright © 2016 ADAM HYATT. All rights reserved.
//

import GameKit
import SpriteKit
import UIKit

let turnBasedHelper = TurnBasedHelper()

class TurnBasedHelper: UIViewController, GKTurnBasedMatchmakerViewControllerDelegate {
    var currMatch: GKTurnBasedMatch?
    
    class var sharedInstance: TurnBasedHelper {
        return turnBasedHelper
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: NSError) {
        print("match failed: \(error)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func turnBasedMatchmakerViewControllerWasCancelled(viewController: GKTurnBasedMatchmakerViewController) {
        print("match cancelled")
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController, didFindMatch match: GKTurnBasedMatch) {
        print("match starting...")
        currMatch = match
        
        let firstPlayer: GKTurnBasedParticipant = (currMatch?.participants?.first)!
        if (firstPlayer.lastTurnDate != nil) {
            print("existing match")
        } else {
            print("new match")
        }
        
        viewController.dismissViewControllerAnimated(true, completion: nil)
        TheMainMenu!.transitionToMultiplayerScene()
    }
    
    func joinTurnBasedMatch(scene: SKScene!) {
        print("Turn Based Match")
        let req = GKMatchRequest()
        req.minPlayers = 2
        req.maxPlayers = 2
        req.defaultNumberOfPlayers = 2
        
        let turnBasedViewController = GKTurnBasedMatchmakerViewController(matchRequest: req)
        turnBasedViewController.turnBasedMatchmakerDelegate = self
        
        let vc: UIViewController = (scene.view?.window?.rootViewController)!;
        vc.presentViewController(turnBasedViewController, animated: true, completion: nil)
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController?, match: GKTurnBasedMatch?) {
        print("Match quit...")
        currMatch = nil
        viewController?.dismissViewControllerAnimated(true, completion: nil)
        //TODO
    }
    
}