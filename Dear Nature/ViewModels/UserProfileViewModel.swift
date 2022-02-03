//
//  UserProfileViewModel.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-03.
//

import Foundation
import FirebaseAuth
import Firebase

class UserProfileViewModel: ObservableObject {
    
    var auth = Auth.auth()
    var db = DatabaseModel()
    @Published var userPosts = [Post]()
    
    func getUserPosts() {
        guard auth.currentUser != nil else { return }
        db.fetchUserPosts() { snapshot in
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
            
            print(self.userPosts)
            
            
        }
     }
    
}
