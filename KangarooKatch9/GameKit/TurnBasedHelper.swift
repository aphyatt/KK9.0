//
//  TurnBasedHelper.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 1/21/16.
//  Copyright © 2016 ADAM HYATT. All rights reserved.
//

import Foundation
import GameKit

let turnBasedHelper = TurnBasedHelper()

class TurnBasedHelper: UIViewController, GKTurnBasedMatchmakerViewControllerDelegate {
    
    class var sharedInstance: TurnBasedHelper {
        return turnBasedHelper
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: NSError) {
        print("match failed: \(error)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func turnBasedMatchmakerViewControllerWasCancelled(viewController: GKTurnBasedMatchmakerViewController) {
        print("match cancelled")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController, didFindMatch match: GKTurnBasedMatch) {
        print("match found")
        
    }
    
    func showTurnBasedViewController(viewController: SKScene!) {
        let req = GKMatchRequest()
        
        req.minPlayers = 2
        req.maxPlayers = 2
        req.defaultNumberOfPlayers = 2
        
        let turnBasedViewController = GKTurnBasedMatchmakerViewController(matchRequest: req)
        turnBasedViewController.turnBasedMatchmakerDelegate = self
        
        let vc: UIViewController = (viewController.view?.window?.rootViewController)!;
        vc.presentViewController(turnBasedViewController, animated: true, completion: nil)
    }
    
    
}