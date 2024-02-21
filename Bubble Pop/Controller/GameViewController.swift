//
//  GameViewController.swift
//  Bubble Pop
//
//  Created by caity :T on 3/4/2023.
//

import Foundation
import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var highestScoreLabel: UILabel!
    
    var gameTimer = Timer()
    var bubbleLimit = 15
    var currentBubble = [Bubble]()
    var lastPoppedBubble: String?
    var remainingTime = 60
    var second = 0.00
    var maxTime = 0.00
    var intervalToRefresh = 0.00
    var playerName = ""
    var current_score = 0
    var highestScore = 0
    var countdown = Countdown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update UI labels
        remainingTimeLabel.text = String(remainingTime)
        highestScoreLabel.text = String(highestScore)
        
        // start countdown before game
        initiateCountdown()
        
        // initialise var as double of remainingtime to do calculations
        maxTime = Double(remainingTime)
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) {
            timer in
            // store seconds passed since timer started
            self.second += 0.25
            // while remainingTime of countdown is more than 0, operate countdown, when it hits 0, operate game.
            self.countdown.remainingTime > 0 ? self.operateCountdown() : self.operateGame()
        }
    }
    
    // add countdown to view and set remaining time
    func initiateCountdown() {
        self.view.addSubview(countdown)
        countdown.setRemainingTime(startingTime: 4)
    }
    
    
    func operateCountdown(){
        // operate countdown every 1 second interval
        if(self.second.truncatingRemainder(dividingBy: 1) == 0.00) {
            countdown.count()
        }
        
        //remove countdown from view when timer hits 0 and restart second to 0 for speed rate calculations
        if(countdown.remainingTime == 0) {
            countdown.removeFromSuperview()
            self.second = 0.00
        }
    }
    
    func operateGame() {
        // counting func for game time runs at an interval of every 1 second
        if(self.second.truncatingRemainder(dividingBy: 1) == 0.00) {
            self.counting()
        }
        
        if (self.currentBubble.count <= self.bubbleLimit) {
            // set speed of bubble refreshing
            self.intervalToRefresh = self.setSpeedRefresh()
            // refresh bubble every game second
            if(self.second.truncatingRemainder(dividingBy: self.intervalToRefresh) == 0.00) {
                self.bubbleRefresh()
            }
        }
    }
    
    func counting() {
        // reduce time by 1 second and update label
        remainingTime -= 1
        remainingTimeLabel.text = String(remainingTime)
        
        if remainingTime == 0 {
            // stop timer when hits 0
            gameTimer.invalidate()
            // segue to highscoreviewcontroller when timer hits 0
            let vc = storyboard?.instantiateViewController(withIdentifier: "HighscoreViewController") as! HighscoreViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.navigationItem.setHidesBackButton(true, animated: true)
            // update current player score when timer hits 0
            vc.writeLatestHighScore(name: playerName, score: current_score)
        }
    }
    
    func generateBubble() {
        // initialise bubble object
        let bubble = Bubble()
        
        // check if current bubble generating will overlap
        if Bubble.checkCurrentBubbles(bubble: bubble, bubbles: currentBubble) {
            bubble.animation()
            bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
            currentBubble.append(bubble)
            self.view.addSubview(bubble)
        }
    }
    
    @IBAction func bubblePressed(_ sender: Bubble) {
        // get score
        getScore(sender)
        // update score label
        scoreLabel.text = String(self.current_score)
        
        // remove bubble from currentBubble array
        if let index = currentBubble.firstIndex(of: sender) {
            currentBubble.remove(at: index)
        }
        
        // remove bubble from superview
        deleteBubble(bubble: sender)
    }
    
    func deleteBubble(bubble: Bubble) {
        // remove bubble from currentBubble array
        if let index = currentBubble.firstIndex(of: bubble) {
            currentBubble.remove(at: index)
        }
        
        // remove bubble from superview
        bubble.removeFromSuperview()
    }
    
    func bubbleRefresh() {
        // delete random number of bubbles
        if((currentBubble.count-1) > 1) {
            let randomNo = Int.random(in: 1...(currentBubble.count-1))
            for _ in 0...randomNo {
                deleteBubble(bubble: currentBubble.randomElement()!)
            }
        }
        
        // add no. of bubble to match bubblelimit count
        while currentBubble.count < bubbleLimit {
            self.generateBubble()
        }
    }
    
    func setSpeedRefresh() -> Double {
        // refresh bubbles depending on seconds passed since timer started
        switch second {
        case 0.00 ... maxTime*0.5:
            intervalToRefresh = 1.00
        case maxTime*0.5...maxTime*0.75:
            intervalToRefresh = 0.5
        case maxTime*0.75...maxTime:
            intervalToRefresh = 0.25
        default:
            intervalToRefresh = 1.00
        }
        
        return intervalToRefresh
    }
    
    func getScore(_ sender: Bubble) {
        if (lastPoppedBubble != nil && lastPoppedBubble == sender.color) {
            // score if two bubble colours tapped in a row
            self.current_score += Int(ceil(Double(sender.score_matrix[sender.color]!) * 1.5))
        } else {
            // normal score
            self.current_score += Int(ceil(Double(sender.score_matrix[sender.color]!)))
        }
        
        // update popped bubble type
        lastPoppedBubble = sender.color
    }
    
    func setHighestScore() {
        // error handling : only show highest score when array has values
        if(HighscoreViewController.readHighScore().count > 0) {
            highestScore = HighscoreViewController.readHighScore()[0].score
        }
    }
}
