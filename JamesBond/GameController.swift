//
//  GameController.swift
//  JamesBond
//
//  Created by Nicholas Bien on 1/1/15.
//  Copyright (c) 2015 Nicholas Bien & Vlad Chilom. All rights reserved.
//

import Foundation
import UIKit

class GameController: CardSelectProtocol, PileDisplayProtocol {
    var gameView: UIView!
    
    let gameplay: Gameplay
    
    var p1pileViews: [PileView] = []
    var p2pileViews: [PileView] = []
    
    var p1pileDisplay: [CardView] = []
    var p2pileDisplay: [CardView] = []
    var middleDisplay: [CardView] = []
    
    var currentCard: CardView?
    var currentPile: PileView?
    
    init() {
        gameplay = Gameplay()
    }
    
    func dealCards() {        
        for i in 0..<6 {
            let pileView = PileView(pile: gameplay.p1piles[i])
            pileView.frame.origin.x = PileSeparationX + CGFloat(i) * (CardWidth + PileSeparationX)
            pileView.frame.origin.y = PileSeparationY + 4 * (CardHeight + PileSeparationY)
            /*
            pileView.frame.origin.x = PileSeparationX + CGFloat(i % 3) * (PileWidth + PileSeparationX)
            if i < 3 {
                pileView.frame.origin.y = PileSeparationY + 5 * (CardHeight + PileSeparationY)
            } else {
                pileView.frame.origin.y = PileSeparationY + 6 * (CardHeight + PileSeparationY)
            }
            */
            pileView.pileDisplayDelegate = self
            p1pileViews.append(pileView)
        }
        for pileView in p1pileViews {
            gameView.addSubview(pileView)
        }
        
        for i in 0..<6 {
            let pileView = PileView(pile: gameplay.p2piles[i])
            pileView.frame.origin.x = PileSeparationX + CGFloat(i) * (CardWidth + PileSeparationX)
            pileView.frame.origin.y = PileSeparationY + 0 * (CardHeight + PileSeparationY)
            /*
            pileView.frame.origin.x = PileSeparationX + CGFloat(i % 3) * (PileWidth + PileSeparationX)
            if i < 3 {
                pileView.frame.origin.y = PileSeparationY
            } else {
                pileView.frame.origin.y = PileSeparationY + (CardHeight + PileSeparationY)
            }
            */
            pileView.userInteractionEnabled = false
            p2pileViews.append(pileView)
        }
        for pileView in p2pileViews {
            gameView.addSubview(pileView)
        }
        displayMiddle()
    }
    
    func displayMiddle() {
        for cardView in middleDisplay {
            cardView.removeFromSuperview()
        }
        middleDisplay.removeAll()
        for i in 0..<4 {
            let cardView = CardView(card: gameplay.middle[i])
            cardView.frame.origin.x = MiddleSeparation + CGFloat(i) * (CardWidth + MiddleSeparation)
            cardView.frame.origin.y = PileSeparationY + 2 * (CardHeight + PileSeparationY)
            cardView.cardSelectDelegate = self
            middleDisplay.append(cardView)
        }
        for cardView in middleDisplay {
            gameView.addSubview(cardView)
            cardView.cardSelectDelegate = self
        }
    }
    
    func displayP1Pile() {
        for cardView in p1pileDisplay {
            cardView.removeFromSuperview()
        }
        p1pileDisplay.removeAll()
        if currentPile != nil {
            for i in 0..<4 {
                let cardView = CardView(card: self.currentPile!.pile[i])
                cardView.frame.origin.x = MiddleSeparation + CGFloat(i) * (CardWidth + MiddleSeparation)
                cardView.frame.origin.y = PileSeparationY + 3 * (CardHeight + PileSeparationY)
                p1pileDisplay.append(cardView)
            }
            for cardView in p1pileDisplay {
                gameView.addSubview(cardView)
                cardView.cardSelectDelegate = self
            }
        }
    }
    
    func pileSelected(pileView: PileView) {
        if self.currentPile? != pileView {
            if currentPile != nil {
                currentPile?.displayFullPile()
            }
            self.currentPile = pileView
            pileView.displayEmptyPile()
        } else {
            currentPile?.displayFullPile()
            self.currentPile = nil
        }
        displayP1Pile()
    }
    
    func cardSelected(cardView: CardView) {
        if self.currentCard != cardView {
            if self.currentCard == nil {
                cardView.displaySelectedCard()
                self.currentCard = cardView
            } else if readyForExchange(cardView) {
                self.exchange(cardView)
                currentCard?.displayUnselectedCard()
                self.currentCard = nil
            } else if readyForSwap(cardView) {
                self.swap(cardView)
                currentCard?.displayUnselectedCard()
                self.currentCard = nil
            } else {
                currentCard?.displayUnselectedCard()
                cardView.displaySelectedCard()
                self.currentCard = cardView
            }
        } else {
            cardView.displayUnselectedCard()
            self.currentCard = nil
        }
    }
    
    func readyForExchange(cardView: CardView) -> Bool {
        if find(middleDisplay, self.currentCard!) != nil && find(p1pileDisplay, cardView) != nil {
            return true
        }
        if find(p1pileDisplay, self.currentCard!) != nil && find(middleDisplay, cardView) != nil {
            return true
        }
        return false
    }
    
    func readyForSwap(cardView: CardView) -> Bool {
        return find(p1pileDisplay, self.currentCard!) != nil && find(p1pileDisplay, cardView) != nil
    }
    
    func exchange(cardView: CardView) {
        let pileNumber = find(p1pileViews, self.currentPile!)!
        let pile = gameplay.p1piles[pileNumber]
        if let middleIndex = find(middleDisplay, self.currentCard!) {
            let pileIndex = find(p1pileDisplay, cardView)!
            gameplay.exchange(pile, pileIndex: pileIndex, middleIndex: middleIndex)
        } else if let middleIndex = find(middleDisplay, cardView) {
            let pileIndex = find(p1pileDisplay, self.currentCard!)!
            gameplay.exchange(pile, pileIndex: pileIndex, middleIndex: middleIndex)
        }
        if pile.isCompleted {
            self.pileSelected(currentPile!)
            currentPile = nil
        }
        displayMiddle()
        displayP1Pile()
    }
    
    func swap(cardView: CardView) {
        let pileNumber = find(p1pileViews, self.currentPile!)!
        let pile = gameplay.p1piles[pileNumber]
        let pileIndex1 = find(p1pileDisplay, cardView)!
        let pileIndex2 = find(p1pileDisplay, currentCard!)!
        gameplay.swap(pile, pileIndex1: pileIndex1, pileIndex2: pileIndex2)
        displayP1Pile()
    }
}