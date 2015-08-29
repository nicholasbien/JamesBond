//
//  ViewController.swift
//  JamesBond
//
//  Created by Nicholas Bien on 1/1/15.
//  Copyright (c) 2015 Nicholas Bien & Vlad Chilom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var controller: GameController
    
    required init(coder aDecoder: NSCoder) {
        controller = GameController()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let gameView = GameView()
        gameView.controller = self.controller
        let background = UIImage(named: BackgroundImage)
        let backgroundView = UIImageView(image: background)
        self.view.addSubview(backgroundView)
        self.view.addSubview(gameView)
        controller.gameView = gameView
        controller.dealCards()
        //controller.basicAI()
        
            delay(2) {
               self.controller.basicAI()
        }

    }
    
    func update() {
        controller.basicAI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), closure)
    }



}

