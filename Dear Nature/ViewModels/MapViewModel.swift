//
//  MapViewModel.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-11.
//

import Foundation
import SwiftUI
import UIKit
import CoreLocation

class MapViewModel: ObservableObject {
    
    @Published var currentMap: UserMap? = nil
    @Published var myMaps = [UserMap]()
    var mapService = MapService()
    
    func getUserMaps() {
        mapService.loadMaps { mapList in
            self.myMaps = mapList
            
        }
    }
    
    func addTestPin() {
        self.myMaps[0].places.append(Place(name: "Nice Place", markerSymbol: "mappin", placeInfo: "This is a cool place", latitude: 37.33233141, longitude: -122.0312186))
    }
    
    func updateCurrentMap(newMapName: String, newRegion: String, isPublic: Bool, mapImage: UIImage?, completion: @escaping (_ success: Bool) -> Void) {
        
        guard self.currentMap != nil else { return }
        
        self.currentMap?.mapName = newMapName
        self.currentMap?.region = newRegion
        self.currentMap?.isPublic = isPublic
        
        
        
        mapService.saveChangesToMap(map: self.currentMap!, image: mapImage) { mapUrl in
            if mapUrl != "" {
                self.currentMap?.mapImage = mapUrl
            }
            completion(true)
        }
        
    }
    
    func deleteMap(completion: @escaping (_ success: Bool) -> Void) {
        guard self.currentMap != nil else { return }
        mapService.deleteMap(map: self.currentMap!) { success in
            self.currentMap = nil
            completion(true)
        }
    }
    
    func placeMarker(location: CLLocationCoordinate2D?) {
        guard let currentMap = currentMap else { return }

        
        
    }
    
}
