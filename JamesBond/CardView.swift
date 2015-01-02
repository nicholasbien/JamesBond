//
//  CardView.swift
//  JamesBond
//
//  Created by Nicholas Bien on 1/1/15.
//  Copyright (c) 2015 Nicholas Bien & Vlad Chilom. All rights reserved.
//

import Foundation
import UIKit

class CardView: UIImageView {
    let card: Card
    var faceUp: Bool
    
    private var xOffset: CGFloat = 0.0
    private var yOffset: CGFloat = 0.0
    
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
        let point = touches.anyObject()!.locationInView(self.superview)
        xOffset = point.x - self.center.x
        yOffset = point.y - self.center.y
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let point = touches.anyObject()!.locationInView(self.superview)
        self.center = CGPointMake(point.x - xOffset, point.y - yOffset)
    }
}