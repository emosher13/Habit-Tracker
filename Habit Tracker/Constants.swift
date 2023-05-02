//
//  Constants.swift
//  Habit Tracker
//
//  Created by Ethan Mosher on 4/24/23.
//

import Foundation

struct K {
    
    static let cellIdentifier = "habitItemCell"
    
    struct Segues {
        static let habitMainSegue = "goToHabitVC"
        static let progressHistorySegue = "goToProgressVC"
        static let logOutSegue = "logOutSegue"
    }
    
    struct FStore {
        static let collectionName = "habits"
        static let habitName = "habitName"
        static let isChecked = "isChecked"
    }
}
