//
//  Gameplay.swift
//  JamesBond
//
//  Created by Nicholas Bien on 1/1/15.
//  Copyright (c) 2015 Nicholas Bien & Vlad Chilom. All rights reserved.
//

import Foundation

class Gameplay {
    let deck: Deck
    var p1piles = [Pile]()
    var p2piles = [Pile]()
    var middle = [Card]()
    
    init() {
        deck = Deck()
        deck.shuffle()

        for i in 0..<12 {
            var pile = Pile()
            for j in 0..<4 {
                pile.append(deck[i * 4 + j])
            }
            if i < 6 {
                p1piles.append(pile)
            } else {
                p2piles.append(pile)
            }
        }

        for i in 48...51 {
            middle.append(deck[i])
        }
    }

    func exchange(pile: Pile, pileIndex: Int, middleIndex: Int) {
        let temp = pile[pileIndex]
        pile.removeAtIndex(pileIndex)
        pile.insert(middle[middleIndex], atIndex: pileIndex)
        middle[middleIndex] = temp
    }
    
    func swap(pile: Pile, pileIndex1: Int, pileIndex2: Int) {
        let card1 = pile[pileIndex1]
        let card2 = pile[pileIndex2]
        pile.removeAtIndex(pileIndex1)
        pile.insert(card2, atIndex: pileIndex1)
        pile.removeAtIndex(pileIndex2)
        pile.insert(card1, atIndex: pileIndex2)
    }
    
    func gameIsOver() -> Bool {
        return allPilesCompleted(p1piles) || allPilesCompleted(p2piles)
    }
    
    func allPilesCompleted(piles: [Pile]) -> Bool {
        for i in 0..<6 {
            if !piles[i].isCompleted {
                return false
            }
        }
        return true
    }
}