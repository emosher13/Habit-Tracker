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
    }
    
    //MARK: - Add Habit
    
    func addHabit(_ habitName: String) {
        
        let habit = HabitInfo(habitName: habitName, docID: nil)
        habits.append(habit)
        
        var ref: DocumentReference? = nil
        ref = db.collection(K.FStore.collectionName).addDocument(data: [
            K.FStore.habitName: habitName,
            K.FStore.isChecked: false,
        ]) { (error) in
            if let error = error {
                print("Error adding habit: \(error.localizedDescription)")
            } else {
                var newHabit = HabitInfo(habitName: habitName, isChecked: false, docID: nil)
                
                if let documentId = ref?.documentID {
                    newHabit.docID = documentId // Store the document ID on the habit
                }
                
                self.habits.append(newHabit)

                print("Habit added successfully")
            }
        }
    }
    
    //MARK: - Remove Habit
    
    func removeHabit(at index: Int) {
        guard habits.indices.contains(index) else {
            print("Error: Attempted to remove habit at invalid index \(index)")
            return
        }
        
        let habit = habits[index]
        
        if let documentID = habit.docID {
            db.collection(K.FStore.collectionName).document(documentID).getDocument { (document, error) in
                if let document = document, document.exists {
                    self.db.collection(K.FStore.collectionName).document(documentID).delete { error in
                        if let error = error {
                            print("Error deleting habit: \(error.localizedDescription)")
                        } else {
                            print("Habit deleted successfully")
                            self.habits.remove(at: index)
                            self.delegate?.reloadTableView()
                        }
                    }
                } else {
                    print("Error deleting habit: document does not exist")
                }
            }
        } else {
            print("Error deleting habit: document ID is missing")
        }
    }

    //MARK: - Toggle Habit
    
    func toggleHabit(at index: Int) {
        habits[index].isChecked.toggle()
        
        let habit = habits[index]
        
        guard let documentId = habit.docID else {
            print("Error updating habit: missing document ID")
            return
        }
        
        let docRef = db.collection(K.FStore.collectionName).document(documentId)
        docRef.updateData([
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
    
    //MARK: - Midnight Reset
    
    func scheduleUncheckHabitsTask() {

        var components = DateComponents()
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let tomorrowMidnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: tomorrow)!
        let timeInterval = tomorrowMidnight.timeIntervalSince(Date())
        let timer = Timer(fireAt: tomorrowMidnight, interval: 0, target: self, selector: #selector(uncheckHabits), userInfo: nil, repeats: false)
        
        RunLoop.main.add(timer, forMode: .common)
        
        DispatchQueue.global(qos: .background).async {
            Thread.sleep(forTimeInterval: timeInterval)
            RunLoop.main.add(timer, forMode: .common)
            RunLoop.current.run()
        }
    }

    @objc func uncheckHabits() {
        updateHabitsCheckedStatus(false)
        scheduleUncheckHabitsTask()
    }
    
    func updateHabitsCheckedStatus(_ isChecked: Bool) {
        for habit in habits {
            guard let documentID = habit.docID else {
                continue
            }
            
            let docRef = db.collection(K.FStore.collectionName).document(documentID)
            docRef.updateData([
                K.FStore.isChecked: isChecked
            ]) { error in
                if let error = error {
                    print("Error updating habit: \(error.localizedDescription)")
                } else {
                    print("Habit updated successfully")
                }
            }
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
                            let newHabit = HabitInfo(habitName: habitName, isChecked: isChecked, docID: doc.documentID)
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
