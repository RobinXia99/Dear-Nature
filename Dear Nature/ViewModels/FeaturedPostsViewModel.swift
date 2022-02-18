//
//  FeaturedPostsViewModel.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-17.
//

import Foundation


class FeaturedPostsViewModel: ObservableObject {

    var postService = PostService()
    @Published var posts = [Post]()
    
    
    func getFollowingPosts(user: User, completion: @escaping (_ finished: Bool) -> Void) {
        
        postService.checkFollowage(userId: user.uid) { followage in
            for following in followage.following {
                self.postService.getFollowingPosts(uid: following) { postList in
                    self.posts.append(contentsOf: postList)
                }
            }

        }
        posts.shuffle()
        completion(true)
        
    }
    
}
