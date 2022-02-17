//
//  MapService.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-13.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import UIKit
import SwiftUI

class MapService {
    
    var db = Firestore.firestore()
    var auth = Auth.auth()
    var storage = StorageModel()
    
    
    func loadMaps(completion: @escaping (_ mapList: [UserMap]) -> Void ) {
        
        guard let currentUser = auth.currentUser else { return }
        
        var mapList = [UserMap]()
        
        db.collection("maps").whereField("uid", isEqualTo: currentUser.uid).addSnapshotListener { snapshot, err in
            guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(err!)")
                return
            }
            
            mapList.removeAll()
            
            for document in documents {
                
                let result = Result {
                    try document.data(as: UserMap.self)
                }
                switch result {
                case .success(let map):
                    if let map = map {
                        mapList.append(map)
                    } else {
                        print("Map does not exist")
                    }
                case .failure(let error):
                    print("error reading map: \(error)")
                }
                
                
                /*
                 if let map = UserMap(data: document.data()) {
                 mapList.append(map)
                 }*/
                
            }
            completion(mapList)
        }
        
    }

    
    func createMap() {
        guard let currentUser = auth.currentUser else { return }
        
        let map = UserMap(uid: currentUser.uid, places: [String](), mapImage: "", mapName: "New Map!", isPublic: false, region: "International")
        
        do {
            _ = try db.collection("maps").addDocument(from: map)
        } catch {
            print("Error saving map")
        }
        
    }
    
    func saveChangesToMap(map: UserMap, image: UIImage?, completion: @escaping (_ mapImg: String) -> Void) {
        guard let currentUser = auth.currentUser else { return }
        
        if image != nil {
            storage.saveImageToStorage(image: image) { ref, error in
                ref.downloadURL { url, error in
                    guard let url = url else { return }
                    
                    self.db.collection("maps").document(map.id!).updateData(["mapName": map.mapName, "region": map.region, "isPublic": map.isPublic, "mapImage": url.absoluteString]) { err in
                        if let error = err {
                            print("error updating map: \(error)")
                            return
                        } else {
                            completion(url.absoluteString)
                        }
                    }

                }
            }
        } else {
            self.db.collection("maps").document(map.id!).updateData(["mapName": map.mapName, "region": map.region, "isPublic": map.isPublic]) { err in
                if let error = err {
                    print("error updating map: \(error)")
                    return
                } else {
                    completion("")
                }
            }
        }
        
        
        
        
        
    }
    
    func getPlaces(map: UserMap, completion: @escaping (_ places: [Place]) -> Void) {
        
        guard auth.currentUser != nil else { return }
        
        
        var placesList = [Place]()
        
        db.collection("places").whereField("mapID", isEqualTo: map.id!).addSnapshotListener { snapshot, err in
            guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(err!)")
                return
            }
            
            placesList.removeAll()
            
            for document in documents {
                
                let result = Result {
                    try document.data(as: Place.self)
                }
                switch result {
                case .success(let place):
                    if let place = place {
                        placesList.append(place)
                    } else {
                        print("Place does not exist")
                    }
                case .failure(let error):
                    print("error reading place: \(error)")
                }
                
                
                /*
                 if let map = UserMap(data: document.data()) {
                 mapList.append(map)
                 }*/
                
            }
            completion(placesList)
        }
        
    }
    
    func deleteMap(map: UserMap, completion: @escaping (_ success: Bool) -> Void) {
        guard let currentUser = auth.currentUser else { return }
        guard auth.currentUser?.uid == map.uid else { return }
        
        db.collection("maps").document(map.id!).delete { err in
            if let err = err {
                print("error deleting map \(err)")
            } else {
                if map.mapImage != "" {
                    self.storage.deleteStorageFile(url: map.mapImage)
                    completion(true)
                }
                completion(true)
                
            }
        }
    }
    
    func createPlace(map: UserMap, place: Place, completion: @escaping (_ newPlace: Place) -> Void) {
        guard auth.currentUser?.uid == map.uid else { return }
        
        do {
            _ = try db.collection("places").addDocument(from: place).getDocument() { snapshot, err in
                if err != nil {
                    print("error creating place 1")
                } else {
                    if let document = snapshot {
                        self.db.collection("maps").document(map.id!).updateData(["places": FieldValue.arrayUnion([document.documentID])])
                    }
                    
                }
            }
        } catch {
            print("Error creating place")
        }
        
        /*
        db.collection("maps").document(currentUser.uid).collection("userMaps").document(map.id!).updateData(["places": FieldValue.arrayUnion([placeMap])]) { err in
            
            if let err = err {
                print("error adding place")
            } else {
                completion(place)
            }
        }*/
    }
    
    func updatePlace(map: UserMap, place: Place, placeName: String, markerSymbol: String, placeInfo: String, placeImage: UIImage?, completion: @escaping (_ success: Bool) -> Void) {
        
        
        guard let currentUser = auth.currentUser else { return }
        
        if placeImage != nil {
            storage.saveImageToStorage(image: placeImage) { ref, error in
                ref.downloadURL { url, error in
                    guard let url = url else { return }
                    
                    self.db.collection("places").document(place.id!).updateData(["name": placeName, "placeImage": url.absoluteString, "markerSymbol": markerSymbol, "placeInfo": placeInfo]) { err in
                        if let error = err {
                            print("error updating map: \(error)")
                            return
                        } else {
                            completion(true)
                        }
                    }
                    

                }
            }
        } else {
            
            self.db.collection("places").document(place.id!)
                .updateData(["name": placeName, "markerSymbol": markerSymbol, "placeInfo": placeInfo]) { err in
                if let error = err {
                    print("error updating map: \(error)")
                    return
                } else {
                    completion(true)
                }
            }
        }
        
        
    }
    
    func deletePlace(place: Place, map: UserMap, completion: @escaping (_ success: Bool) -> Void) {
        
        guard auth.currentUser != nil else { return }
        
        self.db.collection("places").document(place.id!).delete() { err in
            if let err = err {
                print("error deleting place \(err)" )
            } else {
                
                self.db.collection("maps").document(map.id!).updateData(["places": FieldValue.arrayRemove([place.id!])])
                
                if place.placeImage != "" {
                    self.storage.deleteStorageFile(url: place.placeImage)
                    completion(true)
                }
                completion(true)
                
            }
        }
        
    }
    
    func getUserMaps(user: User?, completion: @escaping (_ mapList: [UserMap]) -> Void) {
        
        guard let user = user else { return }
        
        var mapList = [UserMap]()
        
        db.collection("maps").whereField("uid", isEqualTo: user.uid).getDocuments { snapshot, err in
            if let err = err {
                print("error getting users maps \(err)")
                return
            } else {
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let result = Result {
                            try document.data(as: UserMap.self)
                        }
                        switch result {
                        case .success(let map):
                            if let map = map {
                                if map.uid == user.uid {
                                    mapList.append(map)
                                }
                            } else {
                                print("map not added")
                            }
                        case .failure(let error):
                            print("error reading map: \(error)")
                        }
                    }
                    completion(mapList)
                }
            }
        }

        
    }
    
    func getUserMapPlaces(map: UserMap, completion: @escaping (_ places: [Place]) -> Void) {
        
        var places = [Place]()
        
        db.collection("places").whereField("mapID", isEqualTo: map.id).getDocuments { snapshot, err in
            if let err = err {
                print("error getting maps places \(err)")
                return
            } else {
                if let snapshot = snapshot {
                    
                    for document in snapshot.documents {
                        let result = Result {
                            try document.data(as: Place.self)
                        }
                        switch result {
                        case .success(let place):
                            if let place = place {
                                if map.id == place.mapID {
                                    places.append(place)
                                }
                            } else {
                                print("places not added")
                            }
                        case .failure(let error):
                            print("error reading places: \(error)")
                        }
                    }
                    completion(places)
                }
            }
        }
        
    }

}
