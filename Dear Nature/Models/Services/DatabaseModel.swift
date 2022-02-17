//
//  DatabaseModel.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-18.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import SwiftUI

class DatabaseModel {
    
    private let db = Firestore.firestore()
    private var auth = Auth.auth()
    private let storage = StorageModel()
    
    
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
        
        let followageMap = ["followers": [String](), "following": [String]()]
        
        db.collection("users").document(currentUser.uid).setData(newUserMap as [String : Any], merge: true)
        db.collection("followage").document(currentUser.uid).setData(followageMap)
        
        completion(true)
        

    }
    
    func getUser(userId: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
     
        /*
        db.collection("users").document(userId).getDocument { (snapshot, error) in
        let user = try? snapshot?.data(as: User.self)
        completion(user, error)
      }*/
        
        guard self.auth.currentUser != nil else { return }
        
        db.collection("users").document(userId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                let result = Result {
                    try document.data(as: User.self)
                }
                switch result {
                case .success(let user):
                    if let user = user {
                        completion(user,error)
                    }
                case .failure(let error):
                    print("error getting user \(error)")
                }
            }
        

        
    }
    
    func saveProfilePictureToFirebase(image: UIImage?) {
        guard let uid = auth.currentUser?.uid, image != nil else { return }
        storage.saveProfilePictureToStorage(image: image) { ref , error in
            ref.downloadURL { url, error in
                guard let url = url else { return }
                self.db.collection("users").document(uid).updateData(["profileImageUrl": url.absoluteString])
            }
        }
            
            
        }
    
    func makePost(image: UIImage?, caption: String) {
        guard let uid = auth.currentUser?.uid, image != nil else { return }
        
        var newPost = Post()
        let dateFormatter : DateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        
        storage.saveImageToStorage(image: image) { ref , error in
            ref.downloadURL { url, error in
                guard let url = url else { return }
                
                
                
                newPost.uid = uid
                newPost.caption = caption
                newPost.likes = [String]()
                newPost.postImage = url.absoluteString
                newPost.date = dateFormatter.string(from: date)
                
                let newPostDictionary = ["uid" : newPost.uid,
                                           "caption" : newPost.caption,
                                           "likes" : newPost.likes,
                                         "postImage" : newPost.postImage,
                                         "date" : newPost.date] as [String : Any]
                
                self.db.collection("posts").document(uid).collection("userposts").addDocument(data: newPostDictionary)
            }
        }
        
        
        
    }
    
    func getUserPosts(user: User?, completion: @escaping (_ document: QuerySnapshot?) -> Void) {
        guard user != nil else { return }
        db.collection("posts").document(user!.uid).collection("userposts").getDocuments() { snapshot, error in
            guard let snapshot = snapshot else {
                if let error = error {
                    print("error fetching posts: \(error)")
                }
                return
            }
            completion(snapshot)
        }
    }
    
    func getUserList(completion: @escaping (_ users: [User]) -> Void) {
        var listOfUsers = [User]()
        
        db.collection("users").whereField("username", isNotEqualTo: "").getDocuments() { snap, err in
            
            guard let snap = snap else {
                if let error = err {
                    print("error searching for user: \(error)")
                }
                return
            }
            
            listOfUsers.removeAll()
            
            for document in snap.documents {
                let result = Result {
                    try document.data(as: User.self)
                }
                switch result {
                case .success(let user):
                    if let user = user {
                        if user.uid != self.auth.currentUser?.uid {
                            listOfUsers.append(user)
                        }
                    } else {
                        print("user does not exist")
                    }
                case .failure(let error):
                    print("error reading user: \(error)")
                }
            }
            
            completion(listOfUsers)
        }
    }
    
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
    
    func checkFollowage(userId: String, completion: @escaping (_ followage: Followage) -> Void) {
         
        db.collection("followage").document(userId).getDocument { document, err in
            if let document = document, document.exists {
                
                guard let retrievedData = document.data() else { return }

                if let followage = Followage(data: retrievedData) {
                    completion(followage)
                }
                
                
                
            }

            
            
            
            
        }
        
    }
    
    
    }
    
    
    
