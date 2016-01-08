//
//  AchievementsHelper.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 1/7/16.
//  Copyright © 2016 ADAM HYATT. All rights reserved.
//

import Foundation
import GameKit

class AchievementsHelper {
    
    struct Constants {
        static let Joey100AchievementId = "com.orangedude.KangarooKatch.100"
        static let Joey250AchievementId = "com.orangedude.KangarooKatch.250"
        static let Joey500AchievementId = "com.orangedude.KangarooKatch.500"
        static let Joey1000AchievementId = "com.orangedude.KangarooKatch.1000"
    }
    
    class func joeysCaughtAchievements(joeys: Int) -> [GKAchievement] {
        var achievements = [GKAchievement]()
        
        var achievementTmp: GKAchievement
        if joeys >= 100 {
            achievementTmp = GKAchievement(
                identifier: Constants.Joey100AchievementId)
            achievementTmp.percentComplete = 100.0
            achievementTmp.showsCompletionBanner = true
            achievements.append(achievementTmp)
        }
        if joeys >= 250 {
            achievementTmp = GKAchievement(
                identifier: Constants.Joey250AchievementId)
            achievementTmp.percentComplete = 100.0
            achievementTmp.showsCompletionBanner = true
            achievements.append(achievementTmp)
        }
        if joeys >= 500 {
            achievementTmp = GKAchievement(
                identifier: Constants.Joey500AchievementId)
            achievementTmp.percentComplete = 100.0
            achievementTmp.showsCompletionBanner = true
            achievements.append(achievementTmp)
        }
        if joeys >= 1000 {
            achievementTmp = GKAchievement(
                identifier: Constants.Joey1000AchievementId)
            achievementTmp.percentComplete = 100.0
            achievementTmp.showsCompletionBanner = true
            achievements.append(achievementTmp)
        }
        
        return achievements
    }
    
}