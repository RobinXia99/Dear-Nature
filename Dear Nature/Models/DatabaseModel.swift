//
//  DatabaseModel.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-18.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

class DatabaseModel {
    
    private let db = Firestore.firestore()
    private var auth = Auth.auth()
    
    func createUserEntry(user: User, completion: @escaping (Bool) -> Void) {
        guard let currentUser = auth.currentUser else {return}
        
        let newUser = User(uid: currentUser.uid,
                           fullName: user.fullName,
                           username: user.username ?? currentUser.email,
                           email: currentUser.email!,
                           profileImageUrl: user.profileImageUrl ?? "")
        
        let newUserMap = ["uid": newUser.uid,
                          "fullName": newUser.fullName,
                          "username": user.username,
                          "email": newUser.email,
                          "profileImageUrl": newUser.profileImageUrl]
        
        db.collection("users").document(currentUser.uid).setData(newUserMap as [String : Any], merge: true)
        
        completion(true)
        

    }
    
    func getUser(userId: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
      db.collection("users").document(userId).getDocument { (snapshot, error) in
        let user = try? snapshot?.data(as: User.self)
        completion(user, error)
      }
    }
    
    
    
}
