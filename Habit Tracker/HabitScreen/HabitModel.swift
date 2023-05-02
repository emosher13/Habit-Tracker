//
//  HabitModel.swift
//  Habit Tracker
//
//  Created by Ethan Mosher on 4/11/23.
//


import Foundation

struct HabitInfo {
    var habitName: String
    var isChecked: Bool
    
    init(habitName: String, isChecked: Bool = false) {
        self.habitName = habitName
        self.isChecked = isChecked
    }
}
