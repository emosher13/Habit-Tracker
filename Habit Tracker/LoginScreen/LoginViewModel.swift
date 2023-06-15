//
//  LoginViewModel.swift
//  Habit Tracker
//
//  Created by Ethan Mosher on 6/15/23.
//

import Foundation

class LoginViewModel {
    private let model = LoginModel()
    
    //MARK: - New User
    
    func createUser(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        model.createUser(withEmail: email, password: password, completion: completion)
    }
    
    //MARK: - Existing User
    
    func signIn(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        model.signIn(withEmail: email, password: password, completion: completion)
    }
}
