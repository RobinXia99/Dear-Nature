//
//  StorageModel.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-02.
//

import Foundation
import Firebase
import SwiftUI

class StorageModel {
    private var storage = Storage.storage()
    private var auth = Auth.auth()
    
    
    func saveProfilePictureToStorage(image: UIImage?, completion: @escaping (_ ref: StorageReference, _ error: Error?) -> Void) {
        guard let uid = auth.currentUser?.uid, image != nil else { return }
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
        let ref = storage.reference(withPath: uid)
        ref.putData(imageData, metadata: nil) { metaData, error in
            if let error = error {
                print("Saving PFP failed: \(error)")
                return
            }
            completion(ref,error)
        }
    }
    
    func saveImageToStorage(image: UIImage?, completion: @escaping (_ ref: StorageReference, _ error: Error?) -> Void) {
        guard let uid = auth.currentUser?.uid, image != nil else { return }
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
        let fileName = UUID().uuidString
        let storageRef = storage.reference(withPath: "\(uid)/\(fileName)")
        
        storageRef.putData(imageData, metadata: nil) { metaData, error in
            
            if let error = error {
                print("Saving image failed: \(error)")
                return
            }
            
            completion(storageRef,error)
    }
    
}
    
    func deleteStorageFile(url: String) {
        
        let storageRef = storage.reference(forURL: url)
        
        storageRef.delete { err in
            if let err = err {
                print("could not delete image: \(err)")
            } else {
                print("image successfully deleted")
            }
        }
        
    }
    
    
    
}
