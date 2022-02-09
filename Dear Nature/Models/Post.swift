//
//  Post.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-30.
//

import Foundation
import FirebaseFirestoreSwift

struct Post: Codable, Identifiable, Hashable {
    
    @DocumentID var id : String?
    var uid: String = ""
    var caption: String = ""
    var likes: [String] = [String]()
    var postImage: String = ""
    var date: String = ""
    
}
