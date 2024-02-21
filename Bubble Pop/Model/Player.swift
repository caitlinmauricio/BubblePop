//
//  Player.swift
//  Bubble Pop
//
//  Created by caity :T on 3/4/2023.
//

import Foundation

// set player struct variable and make codable to encode and decode into defaults
struct Player: Codable {
    var name : String
    var score : Int
}
