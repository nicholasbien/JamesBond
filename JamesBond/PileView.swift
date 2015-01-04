//
//  PileView.swift
//  JamesBond
//
//  Created by Nicholas Bien on 1/2/15.
//  Copyright (c) 2015 Nicholas Bien & Vlad Chilom. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

protocol PileDisplayProtocol {
    var currentPile: PileView? { get set }
    func pileSelected(pileView: PileView)
}

class PileView: UIView {
    let pile: Pile
    var cardView: CardView
    
    var pileDisplayDelegate: PileDisplayProtocol?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(pile: Pile) {
        
        self.pile = pile
        let card = pile[0]
        self.cardView = CardView(card: card, faceUp: false, height: PileHeight)
        self.cardView.userInteractionEnabled = false
        super.init(frame: CGRectMake(0, 0, PileWidth, PileHeight))
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        pileDisplayDelegate?.pileSelected(self)
    }
    
    func displayEmptyPile() {
        self.cardView.removeFromSuperview()
        self.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), PileBorderColor)
        self.layer.borderWidth = PileBorderWidth
    }
    
    func displayFullPile() {
        self.layer.borderWidth = 0
        if !pile.isCompleted {
            self.addSubview(cardView)
        } else {
            let card = pile[0]
            self.cardView = CardView(card: card, faceUp: true, height: PileHeight)
            self.addSubview(cardView)
            self.userInteractionEnabled = false
        }
    }
}