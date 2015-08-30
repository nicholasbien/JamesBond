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
    
    func getMiddlePosition(index: Int) -> CGPoint {
        let x = MiddleSeparation + CGFloat(index) * (CardWidth + MiddleSeparation)
        let y = PileHeight + 2 * PileSeparationY
        return CGPoint(x: x, y: y)
    }
    
    func getP1PilePosition(index: Int) -> CGPoint {
        let x = PileSeparationX + CGFloat(index) * (PileWidth + PileSeparationX)
        let y = 2 * CardHeight + PileHeight + 4 * PileSeparationY
        return CGPoint(x: x, y: y)
    }
    
    func getP2PilePosition(index: Int) -> CGPoint {
        let x = PileSeparationX + CGFloat(index) * (PileWidth + PileSeparationX)
        let y = PileSeparationY
        return CGPoint(x: x, y: y)
    }
    
    func getP1CardPosition(index: Int) -> CGPoint {
        let x = MiddleSeparation + CGFloat(index) * (CardWidth + MiddleSeparation)
        let y = CardHeight + PileHeight + 3 * PileSeparationY
        return CGPoint(x: x, y: y)
    }
    
    func dealCards() {        
        for i in 0..<6 {
            let pileView = PileView(pile: gameplay.p1piles[i])
            pileView.frame.origin = getP1PilePosition(i)
            pileView.pileDisplayDelegate = self
            p1pileViews.append(pileView)
            gameView.addSubview(pileView)
        }
        for i in 0..<6 {
            let pileView = PileView(pile: gameplay.p2piles[i])
            pileView.frame.origin = getP2PilePosition(i)
            pileView.userInteractionEnabled = false
            p2pileViews.append(pileView)
            gameView.addSubview(pileView)
        }
        for i in 0..<4 {
            let cardView = CardView(card: gameplay.middle[i])
            cardView.frame.origin = self.getMiddlePosition(i)
            middleDisplay.append(cardView)
            gameView.addSubview(cardView)
            cardView.cardSelectDelegate = self
        }
    }
    /*
    func displayMiddle() {
        for i in 0..<4 {
            let current = middleDisplay[i].card
            let next = gameplay.middle[i]
            if current.rank != next.rank || next.suit != next.suit {
                let cardView = CardView(card: gameplay.middle[i])
            }
            let cardView = CardView(card: gameplay.middle[i])
            cardView.frame.origin.x = MiddleSeparation + CGFloat(i) * (CardWidth + MiddleSeparation)
            cardView.frame.origin.y = PileHeight + 2 * PileSeparationY
            cardView.cardSelectDelegate = self
            if cardView.card.rank == currentCard?.card.rank && cardView.card.suit == currentCard?.card.suit {
                cardView.displaySelectedCard()
                currentCard = cardView
            }
            middleDisplay.append(cardView)
        }
        for cardView in middleDisplay {
            gameView.addSubview(cardView)
            cardView.cardSelectDelegate = self
        }
    }
    */
    
    func displayP1Pile(pileView: PileView) {
        let pileNumber = find(p1pileViews, pileView)
        if self.currentPile != nil {
            for cardView in p1pileDisplay {
                UIView.animateWithDuration(0.25, animations: {
                    if self.currentPile != nil {
                        cardView.frame = self.currentPile!.frame
                    }
                }, completion: { finished in
                    UIView.animateWithDuration(0.1, animations: {
                        cardView.alpha = 0.0
                    }, completion: { finished in
                        cardView.removeFromSuperview()
                    })
                })
            }
        }
        p1pileDisplay.removeAll()
        if pileView != self.currentPile {
            for i in 0..<4 {
                let cardView = CardView(card: pileView.pile[i])
                cardView.frame.size = pileView.frame.size
                cardView.frame.origin = getP1PilePosition(pileNumber!)
                UIView.animateWithDuration(0.25, animations: {
                    cardView.frame = CGRect(origin: self.getP1CardPosition(i), size: CGSize(width: 2 * CardHeight / 3, height: CardHeight))
                })
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
        displayP1Pile(pileView)
        if self.currentPile != pileView {
            if currentPile != nil {
                currentPile?.displayFullPile()
            }
            self.currentPile = pileView
            pileView.displayEmptyPile()
        } else {
            currentPile?.displayFullPile()
            self.currentPile = nil
        }
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
        var middleIndex = find(middleDisplay, self.currentCard!)
        var pileIndex: Int?
        if middleIndex != nil {
            pileIndex = find(self.p1pileDisplay, cardView)!
        } else {
            middleIndex = find(middleDisplay, cardView)!
            pileIndex = find(p1pileDisplay, self.currentCard!)!
        }
        gameplay.exchange(pile, pileIndex: pileIndex!, middleIndex: middleIndex!)
        UIView.animateWithDuration(0.25, animations: {
            self.p1pileDisplay[pileIndex!].frame.origin = self.getMiddlePosition(middleIndex!)
            self.middleDisplay[middleIndex!].frame.origin = self.getP1CardPosition(pileIndex!)
        })
        let temp = p1pileDisplay[pileIndex!]
        p1pileDisplay[pileIndex!] = middleDisplay[middleIndex!]
        middleDisplay[middleIndex!] = temp

        if pile.isCompleted {
            self.pileSelected(currentPile!)
            currentPile = nil
        }
        //displayMiddle()
        //displayP1Pile()
        checkForGameOver()
    }
    
    func swap(cardView: CardView) {
        let pileNumber = find(p1pileViews, self.currentPile!)!
        let pile = gameplay.p1piles[pileNumber]
        let pileIndex1 = find(p1pileDisplay, cardView)!
        let pileIndex2 = find(p1pileDisplay, currentCard!)!
        gameplay.swap(pile, pileIndex1: pileIndex1, pileIndex2: pileIndex2)
        UIView.animateWithDuration(0.25, animations: {
            self.p1pileDisplay[pileIndex1].frame.origin = self.getP1CardPosition(pileIndex2)
            self.p1pileDisplay[pileIndex2].frame.origin = self.getP1CardPosition(pileIndex1)
        })
        let temp = p1pileDisplay[pileIndex1]
        p1pileDisplay[pileIndex1] = p1pileDisplay[pileIndex2]
        p1pileDisplay[pileIndex2] = temp
    }
    
    func checkForGameOver() {
        if self.gameplay.gameIsOver() {
            gameView.userInteractionEnabled = false
            println("The game has ended")
            var message = ""
            let label = UILabel(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight))
            label.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2)
            label.textColor = UIColor.whiteColor()
            label.font = UIFont(name: "Cochin-Bold", size: 20)
            if gameplay.p1Finished() {
                message = "You Win"
                println(message)
                label.text = message
            } else {
                message = "You Lose"
                println(message)
                label.text = message
            }
            gameView.addSubview(label)
        }
    }
    













//////////////////// AI

    

    func basicAI() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            while (!self.gameplay.gameIsOver()) {
                let pileNumber = Int(arc4random_uniform(UInt32(6)))
                let pile = self.gameplay.p2piles[pileNumber]
                
                let target = self.mostCommonRankIn(pile)
                let middleIndex = self.indexOf(target, group: self.gameplay.middle)
                if middleIndex != -1 {
                    println("seeking middle card")
                    for pileIndex in 0..<4 {
                        if pile[pileIndex].rank != target {
                            self.gameplay.exchange(pile, pileIndex: pileIndex, middleIndex: middleIndex)
                            self.p2exchangeMade(pileNumber, pileIndex: pileIndex, middleIndex: middleIndex)
                        }
                    }
                } else {
                    for otherPileNumber in 0..<6 {
                        if pileNumber != otherPileNumber {
                            let pileIndex = self.indexOf(target, group: self.gameplay.p2piles[otherPileNumber].pile)
                            if pileIndex != -1 {
                                println("placing card in middle")
                                let middleIndex = Int(arc4random_uniform(UInt32(4)))
                                self.gameplay.exchange(self.gameplay.p2piles[otherPileNumber], pileIndex: pileIndex,  middleIndex: middleIndex)
                                self.p2exchangeMade(otherPileNumber, pileIndex: pileIndex, middleIndex: middleIndex)
                            } else if Int(arc4random_uniform(UInt32(3))) == 0 {
                                let pileNumber = Int(arc4random_uniform(UInt32(6)))
                                let pile = self.gameplay.p2piles[pileNumber]
                                if !pile.isCompleted {
                                    let pileIndex = Int(arc4random_uniform(UInt32(4)))
                                    let middleIndex = Int(arc4random_uniform(UInt32(4)))
                                    println("exchanging random card")
                                    self.gameplay.exchange(pile, pileIndex: pileIndex, middleIndex:    middleIndex)
                                    self.p2exchangeMade(pileNumber, pileIndex: pileIndex, middleIndex: middleIndex)
                                }
                            }
                        }
                    }
                }
                usleep(DelayTime)
            }
        })
    }

    
    func p2exchangeMade(pileNumber: Int, pileIndex: Int, middleIndex: Int) {
        dispatch_async(dispatch_get_main_queue()) {
            if self.middleDisplay[middleIndex] == self.currentCard {
                self.currentCard = nil
            }
            let cardView = CardView(card: self.gameplay.middle[middleIndex])
            cardView.frame = self.p2pileViews[pileNumber].frame
            self.gameView.addSubview(cardView)
            cardView.cardSelectDelegate = self
            let middleFrame = self.middleDisplay[middleIndex].frame
            UIView.animateWithDuration(0.25, animations: {
                self.middleDisplay[middleIndex].frame = self.p2pileViews[pileNumber].frame
                cardView.frame = middleFrame
            }, completion: { finished in
                UIView.animateWithDuration(0.1, animations: {
                    self.middleDisplay[middleIndex].alpha = 0.0
                }, completion: { finished in
                    self.middleDisplay[middleIndex].removeFromSuperview()
                    self.middleDisplay[middleIndex] = cardView
                })
            })
            
            let pile = self.gameplay.p2piles[pileNumber]
            if pile.isCompleted {
                println("pile completed")
                let position = self.p2pileViews[pileNumber].frame.origin
                self.p2pileViews[pileNumber].removeFromSuperview()
                let pileView = PileView(pile: pile)
                self.p2pileViews[pileNumber] = pileView
                pileView.frame.origin = position
                self.gameView.addSubview(pileView)
            }
            self.checkForGameOver()
        }
        usleep(DelayTime)
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
        let index = find(counts, max)!
        return pile[index].rank
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
