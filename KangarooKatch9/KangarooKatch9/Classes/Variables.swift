//
//  Variables.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 7/17/15.
//  Copyright (c) 2015 ADAM HYATT. All rights reserved.
//

import Foundation
import SpriteKit

enum GameStateType {
    case Countdown
    case GameRunning
    case GameOver
    case Paused
}

enum GameModeType {
    case Normal
    case Multiplayer
}

enum ControlType {
    case OneHand
    case TwoHands
}

let kangColor: SKColor = SKColorWithRGB(189, g: 88, b: 14)
let dropletCatchBoundaryY: CGFloat = 175
let dropletFadeBoundaryY: CGFloat = 65

let allLines: [[Int]] = [ [1,0,0], [1,0,2], [1,2,0], [1,2,2],
    [0,1,0], [0,1,2], [2,1,0], [2,1,2],
    [0,0,1], [0,2,1], [2,0,1], [2,2,1],
    [2,0,0], [0,2,0], [0,0,2], [2,2,0], [0,2,2] ]

let veryEasyLinesG: [[Int]] = [ allLines[0], allLines[4], allLines[8] ]
let veryEasyLinesB: [[Int]] = [ [0] ] //never called

let easyLinesG: [[Int]] = veryEasyLinesG
let easyLinesB: [[Int]] = [ allLines[12], allLines[13], allLines[14] ]

let mediumLinesG: [[Int]] = [ allLines[0], allLines[1], allLines[2], allLines[4], allLines[5],
    allLines[6], allLines[8], allLines[9], allLines[10] ]
let mediumLinesB: [[Int]] = [ allLines[12], allLines[13], allLines[14] ]

let hardLinesG: [[Int]] = [ allLines[0], allLines[1], allLines[2], allLines[3], allLines[4], allLines[5],
    allLines[6], allLines[7], allLines[8], allLines[9], allLines[10], allLines[11] ]
let hardLinesB: [[Int]] = [ allLines[12], allLines[13], allLines[14], allLines[15], allLines[16] ]

let veryHardLinesG: [[Int]] = [ allLines[1], allLines[2], allLines[3], allLines[5],
    allLines[6], allLines[7], allLines[9], allLines[10], allLines[11] ]
let veryHardLinesB: [[Int]] = [ allLines[15], allLines[16] ]

let extremeLinesG: [[Int]] = [ allLines[1], allLines[3], allLines[6], allLines[7],
    allLines[9], allLines[11] ]
let extremeLinesB: [[Int]] = veryHardLinesB

let difficultyArraysG = [ veryEasyLinesG, easyLinesG, mediumLinesG, hardLinesG, veryHardLinesG, extremeLinesG ]
let difficultyArraysB = [ veryEasyLinesB, easyLinesB, mediumLinesB, hardLinesB, veryHardLinesB, extremeLinesB ]