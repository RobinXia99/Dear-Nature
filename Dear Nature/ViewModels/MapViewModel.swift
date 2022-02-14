//
//  MapViewModel.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-11.
//

import Foundation

class MapViewModel: ObservableObject {
    
    @Published var currentMap: UserMap? = nil
    @Published var myMaps = [UserMap]()
    var mapService = MapService()
    
    func getUserMaps() {
        mapService.loadMaps { mapList in
            self.myMaps = mapList
            self.myMaps.append(UserMap(id: "", uid: "", places: [Place(name: "Cool Place", markerSymbol: "fork.knife.circle.fill", placeInfo: "I like this place", latitude: 37.33233141, longitude: -122.0312186)], mapImage: "", mapName: "Favorite Beaches", isPublic: true, region: "International"))
        }
    }
}
