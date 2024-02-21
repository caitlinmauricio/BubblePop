//
//  HighscoreViewController.swift
//  Bubble Pop
//
//  Created by caity :T on 3/4/2023.
//

import Foundation
import UIKit

// array key
let KEY_HIGH_SCORE = "highScore"

class HighscoreViewController: UIViewController {

    @IBOutlet weak var HighscoreTable: UITableView!
    
    var highScore:[Player]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // decode highscore into highScore array
        self.highScore = HighscoreViewController.readHighScore()
        
        // set default highscore if table empty
        if(highScore.count == 0)
        {
            writeDefaultHighScore()
        }
    }
    
    //
    func writeDefaultHighScore() {
        let defaults = UserDefaults.standard
        
        // add default highscore into highScore array
        highScore.append(Player(name: "Player 1", score: 0))
        
        // encode into defaults
        defaults.set(try? PropertyListEncoder().encode(highScore), forKey: KEY_HIGH_SCORE)
    }
    
    func writeLatestHighScore(name: String, score: Int) {
        let defaults = UserDefaults.standard
        
        // decode highscore into highScore array
        highScore = HighscoreViewController.readHighScore()
        // append player name and score to array
        highScore.append(Player(name: name, score: score))
        // sort array from highest to lowest score
        highScore.sort {$0.score > $1.score}
        
        // encode highscore array into defaults
        defaults.set(try? PropertyListEncoder().encode(highScore), forKey: KEY_HIGH_SCORE)
    }
    
    // run in viewDidLoad if want to clear highscore table
    func clearHighScore() {
        let defaults = UserDefaults.standard
        let emptyHighScore:[Player]=[]
        
        // encode an empty array into defaults
        defaults.set(try? PropertyListEncoder().encode(emptyHighScore), forKey: KEY_HIGH_SCORE)
    }
    
    static func readHighScore() -> [Player] {
        // Read from User Defaults
        let defaults = UserDefaults.standard
        
        // store defaults into array
        if let savedArrayData = defaults.value(forKey:KEY_HIGH_SCORE) as? Data {
            // decode array
            if let savedHighScores = try? PropertyListDecoder().decode(Array<Player>.self, from: savedArrayData) {
                // return decoded array
                return savedHighScores
            } else {
                return []
            }
        } else {
            return []
        }
    }
}

// how UITableview will appear on view
extension HighscoreViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // As table view, what cell should I display, when user's at this index?
        
        // Dequed a reusable cell from the table view
        let cell = tableView.dequeueReusableCell(withIdentifier: "highScoreCell", for: indexPath)
        
        // Updated the UI for this Cell
        let score = highScore[indexPath.row]
        
        cell.textLabel?.text = score.name
        cell.detailTextLabel?.text = "Score: \(score.score)"
        
        // Return the cell to TableView
        return cell
        
    }
    
    
}
