//
//  ViewController.swift
//  simple-quiz
//
//  Created by Lloyd Roseblade on 11/06/2016.
//  Copyright © 2016 Hursley SIG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var trueBtn: UIButton!
    @IBOutlet weak var falseBtn: UIButton!
    @IBOutlet weak var messageLbl: UILabel!
    
    
    //Determine the device's screen dimensions
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    //Constant that defines duration before game resets
    let END_GAME_TIME_DURATION: NSTimeInterval = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trueBtn.layer.cornerRadius = 10.0
        falseBtn.layer.cornerRadius = 10.0
        
        //Animate the falling messageLbl, including ease in/out and spring bounce
        UIView.animateWithDuration(
            2.5,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.0,
            options: .CurveEaseInOut,
            animations: {
                self.messageLbl.center = CGPoint(x: self.screenWidth / 2, y: self.screenHeight + 1500)
            },
            completion: nil
        )
        
    }
    
    @IBAction func trueTapped(sender: AnyObject) {
        
        showAnswerButtons(false)
        messageLbl.text = "You got it right!"
        activateEndGameTimer(END_GAME_TIME_DURATION)
        
    }
    

    @IBAction func falseTapped(sender: AnyObject) {
        
        showAnswerButtons(false)
        messageLbl.text = "You got it wrong!"
        activateEndGameTimer(END_GAME_TIME_DURATION)
    }
    
    func showAnswerButtons(show: Bool) {
        
        if show {
            trueBtn.hidden = false
            falseBtn.hidden = false
        } else {
            trueBtn.hidden = true
            falseBtn.hidden = true
        }
        
    }

    func activateEndGameTimer(duration: NSTimeInterval) {
        NSTimer.scheduledTimerWithTimeInterval(duration, target:self, selector: #selector(ViewController.resetGame), userInfo: nil, repeats: false)
    }
    
    func resetGame() {
        showAnswerButtons(true)
        messageLbl.text = "As far as has ever been reported, no one has ever seen an Ostrich bury its head in the sand. True or False?"
    }
    
}

