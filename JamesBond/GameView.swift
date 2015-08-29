//
//  GameView.swift
//  JamesBond
//
//  Created by Nicholas Bien on 1/4/15.
//  Copyright (c) 2015 Nicholas Bien & Vlad Chilom. All rights reserved.
//

import Foundation
import UIKit

class GameView: UIView {
    var controller: GameController?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight))
    }
    
    //override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    //    controller?.basicAI()
    //}
}