//
//  SettingViewController.swift
//  Bubble Pop
//
//  Created by caity :T on 3/4/2023.
//

import Foundation
import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var bubbleSlider: UISlider!
    
    var playerName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // store settings in gameviewcontroller when button is pressed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame" {
            let vc = segue.destination as! GameViewController;
            vc.remainingTime = Int(timeSlider.value)
            vc.bubbleLimit = Int(bubbleSlider.value)
            vc.playerName = playerName
        }
    }


}
