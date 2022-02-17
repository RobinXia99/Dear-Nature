//
//  MapInspectViewModel.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-17.
//

import Foundation

class MapInspectViewModel: ObservableObject {
    
    @Published var maps = [UserMap]()
    @Published var places = [Place]()
    var mapService = MapService()
    
    
    func retrieveUsersMaps(user: User?) {
        guard let user = user else { return }
        
        mapService.getUserMaps(user: user) { mapList in
            self.maps = mapList
        }
        
    }
    
    func retrieveMapPlaces(map: UserMap, completion: @escaping (_ success: Bool) -> Void) {
        
        mapService.getUserMapPlaces(map: map) { places in
            self.places = places
            print(self.places)
            completion(true)
        }
    }
    
    
    
}
