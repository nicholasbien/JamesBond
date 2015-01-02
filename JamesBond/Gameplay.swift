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

    func exchange(pile: Pile, index: Int, middleIndex: Int) {
        let temp = pile[index]
        pile.removeAtIndex(index)
        pile.append(middle[middleIndex])
        middle[middleIndex] = temp
    }
}