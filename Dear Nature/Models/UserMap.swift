//
//  UserMap.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-10.
//

import Foundation
import FirebaseFirestoreSwift

struct UserMap: Identifiable, Codable, Equatable, Hashable {
    
    
    @DocumentID var id : String?
    var uid: String = ""
    var places: [String] = [String]()
    var mapImage: String = ""
    var mapName: String = "Map Name"
    var isPublic: Bool = true
    var region: String = "International"
    
    /*
    init?(data: [String: Any]) {
        let uid = data["uid"] as? String
        let places = data["places"] as? [Place]
        let mapImage = data["mapImage"] as? String
        let mapName = data["mapName"] as? String
        let isPublic = data["isPublic"] as? Bool
        let region = data["region"] as? String
        
        self.uid = uid ?? ""
        self.places = places ?? [Place]()
        self.mapImage = mapImage ?? ""
        self.mapName = mapName ?? ""
        self.isPublic = isPublic ?? false
        self.region = region ?? ""
    }*/
    
    
}
