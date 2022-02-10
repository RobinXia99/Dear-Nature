//
//  Followage.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-10.
//

import Foundation

struct Followage: Codable {
    
    var followers: [String]
    var following: [String]
    
    init?(data: [String: Any]) {
        let followers = data["followers"] as? [String]
        let following = data["following"] as? [String]
        
        self.followers = followers ?? [String]()
        self.following = following ?? [String]()
    }
}


