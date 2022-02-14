//
//  Place.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-10.
//

import Foundation
import CoreLocation

struct Place : Identifiable, Codable {
    
    var id = UUID()
    
    var name: String
    var placeImage: String?
    var markerSymbol: String
    var placeInfo: String
    var latitude: Double
    var longitude: Double
    var coordinate: CLLocationCoordinate2D {
        
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
    }
    
}
