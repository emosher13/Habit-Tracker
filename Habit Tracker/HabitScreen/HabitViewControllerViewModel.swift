//
//  HabitViewModel.swift
//  Habit Tracker
//
//  Created by Ethan Mosher on 4/21/23.
//
import Firebase

protocol HabitViewControllerViewModelDelegate: AnyObject {
    func reloadTableView()
    func updateProgress()
}

class HabitViewControllerViewModel {
    
    let db = Firestore.firestore()
    var habits: [HabitInfo] = []
    var progressHistory: [Int] = []
    weak var delegate: HabitViewControllerViewModelDelegate?

    
    init() {
        self.habits = []
        updateProgressHistory()
    }
    
    //MARK: - Add Habit
    
    func addHabit(_ habitName: String) {
        let habit = HabitInfo(habitName: habitName)
        habits.append(habit)
        
        db.collection(K.FStore.collectionName).document(habit.habitName).setData([
            K.FStore.habitName: habit.habitName,
            K.FStore.isChecked: habit.isChecked
        ])
    }
    
    //MARK: - Remove Habit
    
    func removeHabit(at index: Int) {
        let habit = habits[index]
         
         db.collection(K.FStore.collectionName).document(habit.habitName).delete { error in
             if let error = error {
                 print("Error deleting habit: \(error.localizedDescription)")
             } else {
                 print("Habit deleted successfully")
                 self.habits.remove(at: index)
                 self.delegate?.reloadTableView()
             }
         }
    }
     
    //MARK: - Toggle Habit
    
    func toggleHabit(at index: Int) {
        habits[index].isChecked.toggle()
        let habit = habits[index]
        
        db.collection(K.FStore.collectionName).document(habit.habitName).updateData([
            K.FStore.isChecked: habit.isChecked
        ]) { error in
            if let error = error {
                print("Error updating habit: \(error.localizedDescription)")
            } else {
                print("Habit updated successfully")
            }
        }
        
        delegate?.reloadTableView()
    }

    //MARK: - Progress History
    
    func updateProgressHistory() {
        guard habits.count > 0 else { return }
        
        let total = habits.count
        let checked = habits.reduce(0) { (count, habit) -> Int in
            if habit.isChecked {
                return count + 1
            } else {
                return count
            }
        }
        let progress = Int(Float(checked) / Float(total) * 100.0)
        progressHistory.append(progress)
        
        if progressHistory.count > 7 {
            progressHistory.removeFirst()
        }
        
        for i in 0..<habits.count {
            habits[i].isChecked = false
        }
    }
    
    //MARK: - Reload Habits
    
    func loadHabits() {
        habits = []
        db.collection(K.FStore.collectionName).getDocuments { querySnapshot, error in
            if let e = error {
                print(e)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let habitName = data[K.FStore.habitName] as? String, let isChecked = data[K.FStore.isChecked] as? Bool {
                            let newHabit = HabitInfo(habitName: habitName, isChecked: isChecked)
                            self.habits.append(newHabit)
                            self.delegate?.reloadTableView()
                        }
                    }
                }
            }
            self.delegate?.updateProgress()
        }
    }
}
