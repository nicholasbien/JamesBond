//
//  File.swift
//  JamesBond
//
//  Created by Nicholas Bien on 1/1/15.
//  Copyright (c) 2015 Nicholas Bien & Vlad Chilom. All rights reserved.
//

import Foundation
import UIKit

//UI Constants
let ScreenWidth = UIScreen.mainScreen().bounds.size.width
let ScreenHeight = UIScreen.mainScreen().bounds.size.height

let CardHeight = ScreenHeight / 8
let CardWidth = 2 * CardHeight / 3

let CardOverlap = CardHeight / 12

let PileWidth = CardWidth + 3 * CardOverlap

let PileSeparationX = (ScreenWidth - 6 * CardWidth) / 7
let PileSeparationY = (ScreenHeight - 5 * CardHeight) / 6

/*
let PileSeparationX = (ScreenWidth - 3 * PileWidth) / 4
let PileSeparationY = (ScreenHeight - 7 * CardHeight) / 8
*/

let MiddleSeparation = (ScreenWidth - 4 * CardWidth) / 5

let BackgroundImage = "table2x"
let CardBackImage = "cardBack"

let BorderColor: [CGFloat] = [1.0, 1.0, 0.0, 1.0] // yellow
let BorderWidth: CGFloat = 2.0

let PileBorderColor: [CGFloat] = [0.0, 0.0, 0.0, 1.0] // black
let PileBorderWidth = BorderWidth