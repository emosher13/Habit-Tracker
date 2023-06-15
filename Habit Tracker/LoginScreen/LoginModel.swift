//
//  LoginModel.swift
//  Habit Tracker
//
//  Created by Ethan Mosher on 6/15/23.
//

import Foundation
import FirebaseAuth

struct LoginModel {
    func createUser(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(error)
        }
    }
    
    func signIn(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            completion(error)
        }
    }
}

