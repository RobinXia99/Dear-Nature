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
    var postService = PostService()
    @Published var userPosts = [Post]()
    @Published var following = 0
    @Published var followers = 0
    @Published var isFollowing = false
    
    func getUserPosts(user: User?) {
        guard user != nil else { return }
        postService.getUserPosts(user: user) { snapshot in
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
    
    func getAllPosts() {
        
        postService.getAllPosts { postsList in
            self.userPosts = postsList
        }
        
    }
    
    func follow(userId: String) {
        postService.follow(userId: userId) { completion in
            if completion && self.isFollowing == false {
                print("followed")
                self.isFollowing = true
                self.followers += 1
                
            }
        }
    }
    
    func unfollow(userId: String) {
        postService.unfollow(userId: userId) { completion in
            if completion && self.isFollowing == true {
                print("unfollowed")
                self.isFollowing = false
                self.followers -= 1
            }
        }
    }
    
    func getFollowage(userId: String) {
        
        guard let uid = auth.currentUser?.uid else { return }
        
        postService.checkFollowage(userId: userId) { followage in
            self.followers = followage.followers.count
            self.following = followage.following.count
            self.isFollowing = false
            
            if followage.followers.contains(uid) {
                self.isFollowing = true
                print("isFollowing: \(self.isFollowing)")
            }

        }
    }
    
}
