//
//  AuthManager.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-19.
//

import Foundation
import FirebaseAuth

class AuthManager: ObservableObject {
    
    let auth = Auth.auth()
    
    @Published var session: User?
    var isSignedIn: Bool = false
    
    func signIn(email: String, password: String) {
        
        auth.signIn(withEmail: email, password: password) { result, error in
            
            guard result != nil && error == nil else {
                print("Error signing in")
                return
            }
            
            
            if let user = self.auth.currentUser {
                self.isSignedIn.toggle()
                self.session = User (uid: user.uid, username: user.displayName, email: user.email)
            }
            
            
        }
        

    }
    
    func signUp(email: String, password: String, fullName: String, completion:@escaping (Bool) -> ()) {
        
        var didSucceed: Bool = false
        auth.createUser(withEmail: email, password: password) { result, error in
            
            guard result != nil && error == nil else {
                print("Error signing up")
                return
            }
            didSucceed.toggle()
            
            completion(didSucceed)
        }
        
    }
    
}
