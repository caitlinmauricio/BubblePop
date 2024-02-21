//
//  MainViewController.swift
//  Bubble Pop
//
//  Created by caity :T on 3/4/2023.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var playerNameLabel: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide error label from view
        errorLabel.isHidden = true
    }
    
    @IBAction func playGame(_ sender: Any) {
        // show error label on view if UIlabel empty
        if playerNameLabel.text!.isEmpty {
            errorLabel.isHidden = false
            errorLabel.text = "*enter name first"
        } else {
            // navigate to settingsviewcontroller
            let vc = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.navigationItem.setHidesBackButton(false, animated: true)
            // store player name in settingsviewcontroller
            vc.playerName = playerNameLabel.text!
        }
    }
}
