//
//  CardView.swift
//  JamesBond
//
//  Created by Nicholas Bien on 1/1/15.
//  Copyright (c) 2015 Nicholas Bien & Vlad Chilom. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

protocol CardSelectProtocol {
    var currentCard: CardView? {get set}
    func cardSelected(cardView: CardView)
}

class CardView: UIImageView {
    let card: Card
    var faceUp: Bool
    
    var cardSelectDelegate: CardSelectProtocol?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(card: Card, faceUp: Bool = true, height: CGFloat = CardHeight) {
        self.card = card
        self.faceUp = faceUp
        
        var name = CardBackImage
        
        if faceUp {
            name = "\(card.rank)"
            switch card.suit {
            case 1: name += "s"
            case 2: name += "h"
            case 3: name += "d"
            case 4: name += "c"
            default: break
            }
        }
        
        let image = UIImage(named: name)!
        super.init(image: image)
        
        let width = 2 * height / 3
        
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.backgroundColor = UIColor.clearColor()
        
        self.userInteractionEnabled = true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        cardSelectDelegate?.cardSelected(self)
    }
    
    func displaySelectedCard() {
        self.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), BorderColor)
        self.layer.borderWidth = BorderWidth
    }
    
    func displayUnselectedCard() {
        self.layer.borderWidth = 0
    }
}