//
//  LoginViewController.swift
//  Habit Tracker
//
//  Created by Ethan Mosher on 4/24/23.
//


import UIKit
import Firebase

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        loginButton.titleLabel?.font = UIFont(name: "Futura", size: 16.0)
        signUpButton.titleLabel?.font = UIFont(name: "Futura", size: 16.0)
    }
    
    //MARK: - New User
    
    @IBAction func newUserSignUp(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            viewModel.createUser(withEmail: email, password: password) { [weak self] error in
                if let error = error {
                    self?.showAlert(title: "Error", message: "There was an error creating your account. Email may already be in use. Your password must be at least 6 characters long.")
                } else {
                    self?.showAlert(title: "Success!", message: "Account Created! You may now sign in with your email and password.")
                }
            }
        }
    }
    
    //MARK: - Existing User
    
    @IBAction func existingUserLogin(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            viewModel.signIn(withEmail: email, password: password) { [weak self] error in
                if let error = error {
                    self?.showAlert(title: "Error", message: "Wrong email and password combination.")
                } else {
                    self?.performSegue(withIdentifier: K.Segues.habitMainSegue, sender: self)
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

