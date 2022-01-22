//
//  AuthViewModel.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-19.
//

import Foundation
import FirebaseAuth
import Firebase
import GoogleSignIn

class AuthViewModel: ObservableObject {
    
    let auth = Auth.auth()
    
    @Published var session: User?
    var isSignedIn: Bool = false
    
    func listen() {
        
        if let user = self.auth.currentUser {
            self.session = User(uid: user.uid, username: user.displayName, email: user.email)
            self.isSignedIn.toggle()
        }
        
    }
    
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
    
    func googleSignIn() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: rootViewController) { [unowned self] user, error in

          if let error = error {
            // ...
            return
          }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)

            auth.signIn(with: credential) { authResult, error in
                
                guard authResult != nil && error == nil else {
                    print("Error signing in")
                    return
                }
                
                if let user = self.auth.currentUser {
                    self.isSignedIn.toggle()
                    self.session = User (uid: user.uid, username: user.displayName, email: user.email)
                }
                
            }
        }
        
    }
    
    
    
    
    
}
