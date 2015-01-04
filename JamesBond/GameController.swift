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
    
    var p2currentPile: PileView?
    
    init() {
        gameplay = Gameplay()
    }
    
    func dealCards() {        
        for i in 0..<6 {
            let pileView = PileView(pile: gameplay.p1piles[i])
            pileView.frame.origin.x = PileSeparationX + CGFloat(i) * (PileWidth + PileSeparationX)
            pileView.frame.origin.y = 2 * CardHeight + PileHeight + 4 * PileSeparationY
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
            pileView.frame.origin.x = PileSeparationX + CGFloat(i) * (PileWidth + PileSeparationX)
            pileView.frame.origin.y = PileSeparationY
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
        //displayP2Pile()
    }
    
    func displayMiddle() {
        for cardView in middleDisplay {
            cardView.removeFromSuperview()
        }
        middleDisplay.removeAll()
        for i in 0..<4 {
            let cardView = CardView(card: gameplay.middle[i])
            cardView.frame.origin.x = MiddleSeparation + CGFloat(i) * (CardWidth + MiddleSeparation)
            cardView.frame.origin.y = PileHeight + 2 * PileSeparationY
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
                cardView.frame.origin.y = CardHeight + PileHeight + 3 * PileSeparationY
                p1pileDisplay.append(cardView)
            }
            for cardView in p1pileDisplay {
                gameView.addSubview(cardView)
                cardView.cardSelectDelegate = self
            }
        }
    }
    
    func displayP2Pile() {
        p2pileDisplay.removeAll()
        for i in 0..<4 {
            let cardView = CardView(card: self.p2currentPile!.pile[i])
            //cardView.frame.origin.x = MiddleSeparation + CGFloat(i) * (CardWidth + MiddleSeparation)
            //cardView.frame.origin.y = PileHeight + 2 * PileSeparationY
            cardView.userInteractionEnabled = false
            p2pileDisplay.append(cardView)
        }
        /*for cardView in p2pileDisplay {
            gameView.addSubview(cardView)
        }*/
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
    













//////////////////// AI
    
    func basicAI() {
        while (!gameplay.gameIsOver()) {
            let pileNumber = Int(arc4random_uniform(UInt32(5)))
            let pile = gameplay.p2piles[pileNumber]
            let pileIndex = Int(arc4random_uniform(UInt32(3)))
            let middleIndex = Int(arc4random_uniform(UInt32(3)))
            gameplay.exchange(pile, pileIndex: pileIndex, middleIndex: middleIndex)
            if pile.isCompleted {
                p2pileViews[pileNumber] = PileView(pile: pile)
                p2pileViews[pileNumber].displayFullPile()
            }
            displayMiddle()
            sleep(2)
        }
    }
    
    
    

    func mostCommonRankIn(pile: Pile) -> Int {
        var counts = [0, 0, 0, 0]
        for i in 0..<4 {
            let rank = pile[i].rank
            for j in (i + 1)..<4 {
                if pile[j].rank == rank {
                    ++counts[i]
                }
            }
        }
        var max = 0
        for i in 0..<4 {
            if counts[i] > max {
                max = counts[i]
            }
        }
        return pile[max].rank
    }

    func indexOf(rank: Int, group: [Card]) -> Int {
        for i in 0..<4 {
            if group[i].rank == rank {
                return i
            }
        }
        return -1
    }

    func p2Finished() -> Bool {
        for pile in gameplay.p2piles {
            if !pile.isCompleted {
                return false
            }
        }
        return true
    }
    
    func aiLoop() {
        for i in 0..<20 {
            for i in 0..<6 {
                let pile = gameplay.p2piles[i]
                let target = mostCommonRankIn(pile)
                let index = indexOf(target, group: gameplay.middle)
                if index != -1 {
                    for j in 0..<4 {
                        if pile[j].rank != target {
                            //exchange(pile, j, index)
                        }
                    }
                }
                for j in 0..<6 {
                    if i != j {
                        //let index = indexOf(target, gameplay.p2piles[j].pile)
                        if index != -1 {
                            //exchange(p2piles[j], index, Int(arc4random_uniform(UInt32(3))))
                        }
                    }
                }
            }
            if p2Finished() {
                break
            }
        }
    }
}
