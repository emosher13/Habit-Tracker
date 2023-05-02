//
//  ViewController.swift
//  Habit Tracker
//
//  Created by Ethan Mosher on 3/30/23.
//
import UIKit
import Firebase

class HabitViewController: UIViewController {
    
    let db = Firestore.firestore()
    let viewModel = HabitViewControllerViewModel()
    var timer: Timer?
    
    @IBOutlet weak var habitTableView: UITableView!
    @IBOutlet weak var habitProgress: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var resultsButton: UIButton!
    
    @IBAction func viewWeeklyProgress(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsButton.titleLabel?.font = UIFont(name: "Futura", size: 15.0)
        habitTableView.dataSource = self
        habitTableView.delegate = self
        scheduleTimer()
        
        viewModel.delegate = self
        viewModel.loadHabits()
    }
    
    //MARK: - User Log Out
    
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: K.Segues.logOutSegue, sender: self)
        } catch let signOutError as NSError {
            print("Error signing out", signOutError)
        }
    }
    
    //MARK: - Add New Habit
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Habit", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let habitName = textField.text else { return }
            self.viewModel.addHabit(habitName)
            self.habitTableView.reloadData()
            self.updateProgress()
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "New Habit"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - Swipe to Delete
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _ = viewModel.habits[indexPath.row]
            viewModel.habits.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: .fade)
            viewModel.removeHabit(at: indexPath.row)
           }
    }

    //MARK: - Update Progress.
    
    @objc func updateProgress() {
        let habits = viewModel.habits
        
        for var habit in habits {
            let docRef = db.collection(K.FStore.collectionName).document(habit.habitName)
            docRef.updateData([
                K.FStore.isChecked: habit.isChecked
            ]) { error in
                if let error = error {
                    print("Error updating habit: \(error.localizedDescription)")
                } else {
                    print("Habit updated successfully")
                }
            }
            habit.isChecked = false
        }
        viewModel.updateProgressHistory()
        viewModel.delegate?.updateProgress()
    }
    
    //MARK: - Set Midnight Timer
    
    func scheduleTimer() {
            let calendar = Calendar.current
            let now = Date()
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: now)!
            let midnight = calendar.startOfDay(for: tomorrow)
            
            timer = Timer(fireAt: midnight, interval: 0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: .common)
        }
}


extension HabitViewController:  UITableViewDelegate, UITableViewDataSource, HabitViewControllerViewModelDelegate {
    //MARK: - TableView Data
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitItemCell", for: indexPath)
        let habit = viewModel.habits[indexPath.row]
        cell.textLabel?.text = habit.habitName
        cell.accessoryType = habit.isChecked ? .checkmark : .none
        return cell
    }
    
    //MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.toggleHabit(at: indexPath.row)
        tableView.reloadData()
        updateProgress()
    }
    
    //MARK: - Load TableView Data
    
    func reloadTableView() {
        habitTableView.reloadData()
    }
    
}
