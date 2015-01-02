//
//  PileView.swift
//  JamesBond
//
//  Created by Nicholas Bien on 1/2/15.
//  Copyright (c) 2015 Nicholas Bien & Vlad Chilom. All rights reserved.
//

import Foundation
import UIKit

class PileView: UIView {
    let pile: Pile
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(pile: Pile) {
        self.pile = pile
        super.init(frame: CGRectMake(0, 0, PileWidth, CardHeight))
        let card = pile[0]
        let cardView = CardView(card: card, faceUp: pile.isCompleted)
        self.addSubview(cardView)

        /*
        for i in 0..<4 {
            let card = pile[i]
            let cardView = CardView(card: card, faceUp: !pile.isCompleted)
            cardView.userInteractionEnabled = false
            self.addSubview(cardView)
            cardView.center.x += CGFloat(i) * CardOverlap
            
            self.userInteractionEnabled = true
        }
        */
    }
}