//
//  LoginViewController.swift
//  Habit Tracker
//
//  Created by Ethan Mosher on 4/24/23.
//


import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.titleLabel?.font = UIFont(name: "Futura", size: 16.0)
        signUpButton.titleLabel?.font = UIFont(name: "Futura", size: 16.0)
    }
    
    //MARK: - New User Sign Up
    
    @IBAction func newUserSignUp(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: "There was an error creating your account. Email may already be in use. Your Password must be at least 6 characters long.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Try Again", style: .default) { (action) in
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    
                } else {
                    let alert = UIAlertController(title: "Success!", message: "Account Created! You may now sign in with your email and password.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Continue", style: .default) { (action) in
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    //MARK: - Existing User Log In
    
    @IBAction func existingUserLogin(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: "Wrong email and password combination.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Try Again", style: .default) { (action) in
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    
                } else {
                    self.performSegue(withIdentifier: K.Segues.habitMainSegue, sender: self)
                }
            }
        }
    }
}
