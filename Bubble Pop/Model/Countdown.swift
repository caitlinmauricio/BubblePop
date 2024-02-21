//
//  Countdown.swift
//  Bubble Pop
//
//  Created by caity :T on 24/4/2023.
//

import Foundation
import UIKit

class Countdown: UILabel {
    var remainingTime = 4
    
    // initialise how label will look
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textColor = .black
        self.font = UIFont.systemFont(ofSize: 50)
        self.textAlignment = .center
        self.frame = CGRect(x: 100, y: 350, width: 200, height: 50)
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.text = "Ready..."
        self.flash()
    }
    
    // countdown flash animation
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 1
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    // func to change remainingTime var without changing var code
    func setRemainingTime(startingTime: Int) {
        self.remainingTime = startingTime
    }
    
    // update remainingTime count on var and UILabel
    func count() {
        remainingTime -= 1
        self.text = String(remainingTime)
    }
}
