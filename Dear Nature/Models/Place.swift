//
//  Place.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-10.
//

import Foundation
import CoreLocation
import FirebaseFirestoreSwift

struct Place : Identifiable, Codable {
    
    @DocumentID var id: String?
    
    var name: String = "New Place!"
    var placeImage: String = ""
    var markerSymbol: String = "mappin"
    var placeInfo: String = ""
    var latitude: Double
    var longitude: Double
    var mapID: String
    var coordinate: CLLocationCoordinate2D {
        
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
    }
    
}
