//
//  FollowageModel.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-09.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import SwiftUI

class FollowageModel {
    
    private let db = Firestore.firestore()
    private var auth = Auth.auth()
    
    func follow(userId: String, completion: @escaping (_ onSuccess: Bool) -> Void ) {
        guard let user = auth.currentUser else { return }
        
        db.collection("followage").document(user.uid).updateData(["following": FieldValue.arrayUnion([userId])]) { err in
            if let err = err {
                print("error following: \(err)")
            } else {
                print("successfully followed")
                
                self.db.collection("followage").document(userId).updateData(["followers": FieldValue.arrayUnion([user.uid])]) { err in
                    if let err = err {
                        print("error updating other users followers: \(err)")
                    } else {
                        print("successfully updated other users followers")
                        completion(true)
                    }
                }
            }
        }
        
        
    }
    

    func unfollow(userId: String, completion: @escaping (_ onSuccess: Bool) -> Void ) {
    guard let user = auth.currentUser else { return }
    
        db.collection("followage").document(user.uid).updateData(["following": FieldValue.arrayRemove([userId])]) { err in
        if let err = err {
            print("error unfollowing: \(err)")
        } else {
            print("successfully unfollowed")
            
            self.db.collection("followage").document(userId).updateData(["followers": FieldValue.arrayRemove([user.uid])]) { err in
                if let err = err {
                    print("error updating other users followers: \(err)")
                } else {
                    print("successfully updated other users followers")
                    completion(true)
                }
            }
        }
    }
        
    
}
    
    func checkFollowage(userId: String, completion: @escaping (_ onSuccess: [Bool]) -> Void) {
        guard let user = auth.currentUser else { return }
        
        db.collection("followers").document(user.uid).getDocument { snapshot, err in
            guard snapshot != nil else { return }
            
            
        }
        
    }


}


