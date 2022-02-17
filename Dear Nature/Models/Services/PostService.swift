//
//  PostService.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-17.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import SwiftUI

class PostService {
    
    private let db = Firestore.firestore()
    private var auth = Auth.auth()
    private let storage = StorageModel()
    
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
                
                self.db.collection("posts").addDocument(data: newPostDictionary)
            }
        }
        
        
        
    }
    
    func getUserPosts(user: User?, completion: @escaping (_ document: QuerySnapshot?) -> Void) {
        guard user != nil else { return }
        db.collection("posts").whereField("uid", isEqualTo: user!.uid).getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                if let error = error {
                    print("error fetching posts: \(error)")
                }
                return
            }
            completion(snapshot)
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
