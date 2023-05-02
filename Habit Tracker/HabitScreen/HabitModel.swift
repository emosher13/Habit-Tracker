//
//  HabitModel.swift
//  Habit Tracker
//
//  Created by Ethan Mosher on 4/11/23.
//


import Foundation

struct HabitInfo {
    let habitName: String
    var isChecked: Bool
    var docID: String?
    
    init(habitName: String, isChecked: Bool = false, docID: String?) {
        self.habitName = habitName
        self.isChecked = isChecked
        self.docID = docID
    }
}
