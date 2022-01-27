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
    
    @Published var isNewUser: Bool = false
    @Published var session: User?
    @Published var isSignedIn: Bool = false
    var db = DatabaseModel()
    
    
    func listen() {
        guard self.auth.currentUser != nil else {return}
        if let userId = auth.currentUser?.uid {
            db.getUser(userId: userId) { user, error in
                print("getting user")
                self.session = user
                self.isSignedIn = true
            }
        }
        
    }
    
    func signIn(email: String, password: String) {
        
        auth.signIn(withEmail: email, password: password) { result, error in
            
            guard result != nil && error == nil else {
                print("Error signing in")
                return
            }
            
            
            if let _ = result?.additionalUserInfo?.isNewUser {
                
                self.isNewUser = true
            }
            
            if let _ = self.auth.currentUser {
                self.isSignedIn.toggle()
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
            
            if let newUser = result?.user {
                let user = User(uid: newUser.uid,
                                fullName: fullName,
                                username: "",
                                email: email,
                                profileImageUrl: "")
                self.db.createUserEntry(user: user)
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
                    
                    
                    let newUser = User(uid: user.uid,
                                       fullName: user.displayName ?? "Full Name",
                                       username: "",
                                       email: user.email!,
                                       profileImageUrl: "")
                    self.db.createUserEntry(user: newUser)
                    
                    
                    self.isSignedIn.toggle()
                }
                
            }
        }
        
    }
    
    
    
    
    
}
