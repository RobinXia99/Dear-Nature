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
        
        db.collection("users").document(currentUser.uid).setData(newUserMap as [String : Any], merge: true)
        
        completion(true)
        

    }
    
    func getUser(userId: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
     
        /*
        db.collection("users").document(userId).getDocument { (snapshot, error) in
        let user = try? snapshot?.data(as: User.self)
        completion(user, error)
      }*/
        
        guard self.auth.currentUser != nil else { return }
        
        let listener = db.collection("users").document(userId)
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
                    print("error mapping the document \(error)")
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
        storage.savePostImageToStorage(image: image) { ref , error in
            ref.downloadURL { url, error in
                guard let url = url else { return }
                
                newPost.uid = uid
                newPost.caption = caption
                newPost.likes = [String]()
                newPost.postImage = url.absoluteString
                
                let newPostDictionary = ["uid" : newPost.uid,
                                           "caption" : newPost.caption,
                                           "likes" : newPost.likes,
                                         "postImage" : newPost.postImage,
                                         "date" : newPost.date] as [String : Any]
                
                self.db.collection("posts").document(uid).collection("userposts").addDocument(data: newPostDictionary)
            }
        }
        
        
        
    }
    
    func fetchUserPosts(completion: @escaping (_ document: QuerySnapshot?) -> Void) {
        guard let currentUser = auth.currentUser else { return }
        db.collection("posts").document(currentUser.uid).collection("userposts").getDocuments() { snapshot, error in
            guard let snapshot = snapshot else {
                if let error = error {
                    print("error fetching posts: \(error)")
                }
                return
            }
            completion(snapshot)
        }
    }
    
    }
    
    
    
