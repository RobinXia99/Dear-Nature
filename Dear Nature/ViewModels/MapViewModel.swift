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
    @Published var currentMapPlaces: [Place]? = nil
    var mapService = MapService()
    
    func getUserMaps() {
        mapService.loadMaps { mapList in
            self.myMaps = mapList
            
            if self.currentMap != nil {
                if let map = self.myMaps.first(where: {$0.id == self.currentMap?.id}) {
                    self.currentMap = map
                } else {
                   print("couldnt update map")
                }
            }
            
            
        }
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
    
    func getPlaces() {
        guard let currentMap = currentMap else { return }
        
        mapService.getPlaces(map: currentMap) { places in
            self.currentMapPlaces = places
        }
    }
    
    func placeMarker(latitude: Double, longitude: Double) {
        guard let currentMap = currentMap else { return }
        
        let newPlace = Place(name: "New Place!", placeImage: "", markerSymbol: "mappin", placeInfo: "", latitude: latitude, longitude: longitude, mapID: currentMap.id!)
        
        mapService.createPlace(map: currentMap, place: newPlace) { _ in
            
        }
        
        
    }
    
    func editPlace(place: Place, placeName: String, placeImage: UIImage?, markerSymbol: String, placeInfo: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let currentMap = currentMap else { return }

        
        mapService.updatePlace(map: currentMap, place: place, placeName: placeName, markerSymbol: markerSymbol, placeInfo: placeInfo, placeImage: placeImage) { _ in
            print("successfully updated place")
            completion(true)
        }
        
    }
    
    func deletePlace(place: Place, completion: @escaping (_ success: Bool) -> Void) {
        
        guard let currentMap = currentMap else { return }
        
        mapService.deletePlace(place: place, map: currentMap) { _ in
            print("place deleted")
            completion(true)
        }
        
    }
    
}
