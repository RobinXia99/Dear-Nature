//
//  MapService.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-13.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

class MapService {
    
    var db = Firestore.firestore()
    var auth = Auth.auth()
    
    
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
    
}
