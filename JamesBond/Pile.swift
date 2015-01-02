//
//  Pile.swift
//  JamesBond
//
//  Created by Nicholas Bien on 1/1/15.
//  Copyright (c) 2015 Nicholas Bien & Vlad Chilom. All rights reserved.
//

import Foundation

class Pile {
    var pile = [Card]()
    var isCompleted = false
    
    subscript(index: Int) -> Card {
        return pile[index]
    }
    
    func append(card: Card) {
        pile.append(card)
        if pile.count == 4 {
            pile.sort({ (lh: Card, rh: Card) in
                if (lh.rank != rh.rank) {
                    return lh.rank < rh.rank
                } else {
                    return lh.suit < rh.suit
                }
            })
            isCompleted = {
                let rank = self.pile[0].rank
                for card in self.pile {
                    if card.rank != rank {
                        return false
                    }
                }
                return true
            }()
        }
    }
    
    func removeAtIndex(index: Int) {
        pile.removeAtIndex(index)
    }
}