//
//  KangarooKatchNavigationController.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 1/6/16.
//  Copyright © 2016 ADAM HYATT. All rights reserved.
//

import UIKit
import GameKit

class KangarooKatchNavigationController: UINavigationController, GameKitHelperDelegate {

    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:
        Selector("showAuthenticationViewController"),
            name: PresentAuthenticationViewController, object: nil)
        
        GameKitHelper.sharedInstance.authenticateLocalPlayer()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAuthenticationViewController() {
        let gameKitHelper = GameKitHelper.sharedInstance
        if let authenticationViewController = gameKitHelper.authenticationViewController {
            topViewController!.presentViewController(authenticationViewController, animated: true,
            completion: nil)
        }
    }
    
    func showMatchMakerViewController() {
        GameKitHelper.sharedInstance.findMatch(presentingViewController: self, delegate: self)
    }
    
    func matchStarted() {
        print("Match has started successfully")
    }
    
    func matchEnded() {
        print("Match has ended")
    }
    
    func matchReceivedData(match: GKMatch, data: NSData, fromPlayer player: String) {
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
