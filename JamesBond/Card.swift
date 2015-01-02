//
//  Card.swift
//  JamesBond
//
//  Created by Nicholas Bien on 1/1/15.
//  Copyright (c) 2015 Nicholas Bien & Vlad Chilom. All rights reserved.
//

import Foundation

struct Card {
    let rank: Int
    let suit: Int
    
    init(rank: Int, suit: Int) {
        self.rank = rank
        self.suit = suit
    }
}