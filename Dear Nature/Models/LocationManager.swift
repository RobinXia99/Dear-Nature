//
//  LocationManager.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-11.
//

import Foundation

import Foundation
import CoreLocation

class LocationManager : NSObject, CLLocationManagerDelegate{
    let manager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    
    func askPermission () {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        print("Plats updaterad: \(location)")
    }
    
}
