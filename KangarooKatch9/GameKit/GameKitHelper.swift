//
//  GameKitHelper.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 1/6/16.
//  Copyright © 2016 ADAM HYATT. All rights reserved.
//

import GameKit
import Foundation

let singleton = GameKitHelper()
let PresentAuthenticationViewController = "PresentAuthenticationViewController"

class GameKitHelper: NSObject {
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
}