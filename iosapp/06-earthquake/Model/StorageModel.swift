//
//  StorageModel.swift
//  06-earthquake
//
//  Created by koogawa on 2019/12/28.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import Foundation
//import Firebase
//import FirebaseFirestore
import FirebaseStorage

final class StorageModel {
    
    func uploadImage(uid: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let millsec = Date().timeIntervalSince1970
        let imagePath = "photos/\(uid)/\(Int(millsec))"
        let imageRef = storageRef.child(imagePath)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(data, metadata: metadata) { _, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(imagePath))
        }
    }
    
    func deleteImage(imagePath: String, completion: @escaping (Error?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference(withPath: imagePath)
        storageRef.delete { (error) in
            completion(error)
        }
    }
}
