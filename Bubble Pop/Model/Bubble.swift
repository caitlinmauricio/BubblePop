//
//  Bubble.swift
//  Bubble Pop
//
//  Created by caity :T on 3/4/2023.
//

import Foundation
import UIKit

class Bubble: UIButton {
    // initialise xposition, yposition, radius as random int and double to be able to change
    let xPosition = Int.random(in: 45...295)
    let yPosition = Int.random(in: 215...725)
    let radius = Double.random(in: 20...25)
    
    // initialise how bubble will look
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.color = self.color_probability()
        self.backgroundColor = colors_ui[color]
        self.frame = CGRect(x: xPosition, y: yPosition, width: Int(radius*2.00), height: Int(radius*2.00))
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
    }
    
    // animation of bubble
    func animation() {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 0.6
        springAnimation.fromValue = 1
        springAnimation.toValue = 0.8
        springAnimation.repeatCount = 1
        springAnimation.initialVelocity = 0.5
        springAnimation.damping = 1
        
        layer.add(springAnimation, forKey: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    // bubble color types
    var colors = ["Red", "Pink", "Green", "Blue", "Black"]
    
    // default color
    var color = "Red"
    
    // set color for color type
    var colors_ui = [
        "Red": UIColor(red: 231/255.0, green: 51/255.0, blue: 35/255.0, alpha: 1),
        "Pink": UIColor(red: 175/255.0, green: 44/255.0, blue: 129/255.0, alpha: 1),
        "Green": UIColor(red: 59/255.0, green: 125/255.0, blue: 33/255.0, alpha: 1),
        "Blue": UIColor(red: 0/255.0, green: 29/255.0, blue: 244/255.0, alpha: 1),
        "Black": UIColor.black
    ]
    
    // score assigned to color type
    var score_matrix = [
        "Red": 1,
        "Pink": 2,
        "Green": 5,
        "Blue": 8,
        "Black": 10
    ]
    
    // probability of bubble color type appearing
    func color_probability() -> String {
        let prob = Int.random(in: 1...100)
        
        switch prob {
            case let x where x <= 40:
                return "Red"
            case let x where x <= 70:
                return "Pink"
            case let x where x <= 85:
                return "Green"
            case let x where x <= 95:
                return "Blue"
            case let x where x <= 100:
                return "Black"
        default:
            return "Red"
        }

    }
    
    // retrieve score matrix for bubble color type
    func get_score() -> Int {
        return self.score_matrix[self.color]!
    }
    
    static func checkOverlap(c1: Bubble, c2: Bubble) -> Bool {
        // calculate distance between bubbles
        // distance = sqrt((x1x2)^2 + (y1y2)^2)
        let x1x2 = Double(c1.xPosition - c2.xPosition)
        let y1y2 = Double(c1.yPosition - c2.yPosition)
        let distance = sqrt(pow(x1x2, 2) + pow(y1y2, 2))
        
        // cases where distance of circles will overlap
        switch distance {
        case let d where d <= (c1.radius - c2.radius):
            return false
        case let d where d <= (c2.radius - c1.radius):
            return false
        case let d where d <= (c1.radius + c2.radius):
            return false
        // if all cases false, return true not overlapping
        default:
            return true
        }
        
    }
    
    // check if bubbles is overlapping with all bubbles shown in view
    static func checkCurrentBubbles(bubble: Bubble, bubbles:[Bubble]) -> Bool {
        for b in bubbles {
            if !checkOverlap(c1: bubble, c2: b) {
                return false
            }
        }
        
        return true
    }
}
