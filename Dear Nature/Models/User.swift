//
//  User.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-19.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable, Hashable {
    
    @DocumentID var id : String?
    var uid: String
    var fullName: String?
    var username: String?
    var email: String
    var profileImageUrl: String?
    
}
