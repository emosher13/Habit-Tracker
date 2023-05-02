//
//  ProgressHistoryViewControllerViewModel.swift
//  Habit Tracker
//
//  Created by Ethan Mosher on 4/24/23.
//

//import Foundation
//
//class ProgressHistoryViewControllerViewModel {
//    
//    let habitViewModel = HabitViewControllerViewModel()
//    var progressHistory: [Int] = []
//    
//    func updateProgressHistory() {
//        let total = habitViewModel.habits.count
//        let checked = habitViewModel.habits.reduce(0) { (count, habit) -> Int in
//            if habit.isChecked {
//                return count + 1
//            } else {
//                return count
//            }
//        }
//        let progress = Int(Float(checked) / Float(total) * 100.0)
//        progressHistory.append(progress)
//        
//        if progressHistory.count > 7 {
//            progressHistory.removeFirst()
//        }
//
//        for i in 0..<habitViewModel.habits.count {
//            habitViewModel.habits[i].isChecked = false
//        }
//    }
//}
