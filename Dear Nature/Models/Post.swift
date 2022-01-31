//
//  Post.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-30.
//

import Foundation

public struct Post: Codable {
  
    var uid: String
    var caption: String
    var likes: [String]
    var postImage: String
    
}
