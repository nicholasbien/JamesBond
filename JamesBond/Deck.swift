//
//  Deck.swift
//  JamesBond
//
//  Created by Nicholas Bien on 1/1/15.
//  Copyright (c) 2015 Nicholas Bien & Vlad Chilom. All rights reserved.
//

import Foundation

class Deck {
    var deck = [Card]()
    
    init() {
        for rank in 1...13 {
            for suit in 1...4  {
                deck.append(Card(rank: rank, suit: suit))
            }
        }
    }
    
    subscript(index: Int) -> Card {
        return deck[index]
    }
    
    func shuffle() {
        for i in 0..<(deck.count - 1) {
            let j = Int(arc4random_uniform(UInt32(deck.count - i))) + i
            let temp = deck[j]
            deck[j] = deck[i]
            deck[i] = temp
        }
    }
}