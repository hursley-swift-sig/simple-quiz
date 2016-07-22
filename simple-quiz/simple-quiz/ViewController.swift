//
//  ViewController.swift
//  simple-quiz
//
//  Created by Lloyd Roseblade on 11/06/2016.
//  Copyright © 2016 Hursley SIG. All rights reserved.
//

import UIKit
import SwiftyJSON

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
        
        askServerForQuestion() {
            self.showQuestion($0)
        }
    }
    
    @IBAction func trueTapped(sender: AnyObject) {
        showAnswerCorrectness(answer: true)
    }
    

    @IBAction func falseTapped(sender: AnyObject) {
        showAnswerCorrectness(answer: false)
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
    
    func showQuestion(questionText: String) {
        messageLbl.text = questionText
        
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
    
    func showAnswer(answerText: String) {
        messageLbl.text = answerText
    }
    
    func showAnswerCorrectness(answer clientAnswer: Bool) {
        if let url = NSURL(string: "http://localhost:8090/answer") {
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = (clientAnswer ? "true" : "false").dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in                if let resultData = data {
                    let json: JSON = JSON(data: resultData)
                    if let answerCorrect = json["correct"].bool {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.showAnswer(answerCorrect ? "You got it right!" : "You got it wrong!")
                            self.showAnswerButtons(false)
                            self.activateEndGameTimer(self.END_GAME_TIME_DURATION)
                        }
                    } else {
                        // TODO Error: Repsonse does not look valid
                        print("HERE")
                    }
                } else {
                    // TODO Error: Response does not look valid
                    print("HERE2")
                }
            }
            task.resume()
        } else {
            // TODO Error: URL not valid?
            print("HERE3")
        }
    }
    
    func askServerForQuestion(closure: (question: String) -> Void) {
        if let url = NSURL(string: "http://localhost:8090/question") {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in                if let resultData = data {
                let json: JSON = JSON(data: resultData)
                let question = json["question"].string ?? "Error"
                dispatch_async(dispatch_get_main_queue()) {
                    closure(question: question)
                }
            } else {
                // TODO Error: Response does not look valid
                }
            }
            task.resume()
        } else {
            // TODO Error: URL not valid?
        }
    }
    
    func resetGame() {
        askServerForQuestion() {
            self.showQuestion($0)
            self.showAnswerButtons(true)
        }
    }
    
}

