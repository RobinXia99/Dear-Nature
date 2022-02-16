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
        
        db.collection("maps").document(currentUser.uid).collection("userMaps").addSnapshotListener { snapshot, err in
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
        
        let map = UserMap(uid: currentUser.uid, places: [Place](), mapImage: "", mapName: "New Map!", isPublic: false, region: "International")
        
        do {
            _ = try db.collection("maps").document(currentUser.uid).collection("userMaps").addDocument(from: map)
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
                    
                    self.db.collection("maps").document(currentUser.uid).collection("userMaps").document(map.id!).updateData(["mapName": map.mapName, "region": map.region, "isPublic": map.isPublic, "mapImage": url.absoluteString]) { err in
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
            self.db.collection("maps").document(currentUser.uid).collection("userMaps").document(map.id!).updateData(["mapName": map.mapName, "region": map.region, "isPublic": map.isPublic]) { err in
                if let error = err {
                    print("error updating map: \(error)")
                    return
                } else {
                    completion("")
                }
            }
        }
        
        
        
        
        
    }
    
    func deleteMap(map: UserMap, completion: @escaping (_ success: Bool) -> Void) {
        guard let currentUser = auth.currentUser else { return }
        guard auth.currentUser?.uid == map.uid else { return }
        
        db.collection("maps").document(currentUser.uid).collection("userMaps").document(map.id!).delete { err in
            if let err = err {
                print("error deleting map")
            } else {
                if map.mapImage != "" {
                    self.storage.deleteStorageFile(url: map.mapImage)
                    completion(true)
                }
                completion(true)
                
            }
        }
    }
    
}
