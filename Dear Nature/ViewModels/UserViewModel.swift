//
//  UserProfileViewModel.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-03.
//

import Foundation
import FirebaseAuth
import Firebase

class UserViewModel: ObservableObject {
    
    var auth = Auth.auth()
    var db = DatabaseModel()
    @Published var userPosts = [Post]()
    @Published var otherUserPosts = [Post]()
    
    func getUserPosts(user: User?) {
        guard user != nil else { return }
        db.getUserPosts(user: user) { snapshot in
            guard let snapshot = snapshot else {
                return
            }

            self.userPosts.removeAll()
            
            for document in snapshot.documents {
                let result = Result {
                    try document.data(as: Post.self)
                }
                switch result {
                case .success(let post):
                    if let post = post {
                        self.userPosts.append(post)
                    } else {
                        print("post does not exist")
                    }
                case .failure(let error):
                    print("error decoding post: \(error)")
                }
            }
            
            
            
        }
     }
    
    func getFollowers(userId: String) {
        
        
        
    }
    
    
    
}
