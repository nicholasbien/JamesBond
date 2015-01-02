//
//  GameController.swift
//  JamesBond
//
//  Created by Nicholas Bien on 1/1/15.
//  Copyright (c) 2015 Nicholas Bien & Vlad Chilom. All rights reserved.
//

import Foundation
import UIKit

class GameController {
    var gameView: UIView!
    
    let gameplay: Gameplay
    
    init() {
        gameplay = Gameplay()
    }
    
    func dealCards() {        
        for i in 0..<6 {
            let pileView = PileView(pile: gameplay.p1piles[i])
            pileView.frame.origin.x = PileSeparationX + CGFloat(i % 3) * (PileWidth + PileSeparationX)
            if i < 3 {
                pileView.frame.origin.y = PileSeparationY + 5 * (CardHeight + PileSeparationY)
            } else {
                pileView.frame.origin.y = PileSeparationY + 6 * (CardHeight + PileSeparationY)
            }
            gameView.addSubview(pileView)
        }
        
        for i in 0..<6 {
            let pileView = PileView(pile: gameplay.p2piles[i])
            pileView.frame.origin.x = PileSeparationX + CGFloat(i % 3) * (PileWidth + PileSeparationX)
            if i < 3 {
                pileView.frame.origin.y = PileSeparationY
            } else {
                pileView.frame.origin.y = PileSeparationY + (CardHeight + PileSeparationY)
            }
            gameView.addSubview(pileView)
        }
        
        for i in 0..<4 {
            let cardView = CardView(card: gameplay.middle[i])
            cardView.frame.origin.x = MiddleSeparation + CGFloat(i) * (CardWidth + MiddleSeparation)
            cardView.frame.origin.y = PileSeparationY + 3 * (CardHeight + PileSeparationY)
            gameView.addSubview(cardView)
        }
    }
}