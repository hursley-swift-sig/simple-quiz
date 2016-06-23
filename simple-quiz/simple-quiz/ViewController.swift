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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trueBtn.layer.cornerRadius = 10.0
        falseBtn.layer.cornerRadius = 10.0
        
        

        
    }
    
    @IBAction func trueTapped(sender: AnyObject) {
        
        print("Tapped the True button")
        buttonDisplay()
        messageLbl.text = "You got it right!"
        
        
    }
    

    @IBAction func falseTapped(sender: AnyObject) {
        print("Tapped the False button")
        buttonDisplay()
        messageLbl.text = "You got it wrong!"
        
    }
    
    func buttonDisplay() {
        trueBtn.hidden = true
        falseBtn.hidden = true
    }
    
}

