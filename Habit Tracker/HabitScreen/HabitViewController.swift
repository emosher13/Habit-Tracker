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
    @IBOutlet weak var quoteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quoteButton.titleLabel?.font = UIFont(name: "Futura", size: 15.0)
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
            viewModel.removeHabit(at: indexPath.row)
            viewModel.habits.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: .fade)
           }
    }

    //MARK: - Update Progress.

    @objc func updateProgress() {
        let total = viewModel.habits.count
        if total == 0 {
            habitProgress.setProgress(0, animated: true)
            progressLabel.text = "0%"
            return
        }
        let checked = habitTableView.visibleCells.reduce(0) { (count, cell) -> Int in
            if cell.accessoryType == .checkmark {
                return count + 1
            } else {
                return count
            }
        }
        let progress = Float(checked) / Float(total)
        habitProgress.setProgress(progress, animated: true)
        progressLabel.text = "\(Int(progress * 100))%"
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
    
    //MARK: - Quote Button Segue
    
    @IBAction func viewQuote(_ sender: UIButton) {
        performSegue(withIdentifier: K.Segues.quoteSegue, sender: self)
    }
}

extension HabitViewController:  UITableViewDelegate, UITableViewDataSource, HabitViewControllerViewModelDelegate {
    //MARK: - TableView Data
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.habits.isEmpty ? 1 : viewModel.habits.count
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
