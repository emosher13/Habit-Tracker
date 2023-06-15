//
//  QuoteModel.swift
//  Habit Tracker
//
//  Created by Ethan Mosher on 5/30/23.
//

import Foundation

struct Quote: Codable {
    let text: String
    let author: String
    
    enum CodingKeys: String, CodingKey {
        case text = "q"
        case author = "a"
    }
}

