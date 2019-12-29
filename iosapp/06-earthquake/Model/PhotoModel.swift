//
//  PhotoModel.swift
//  06-earthquake
//
//  Created by koogawa on 2019/12/29.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import Foundation
import FirebaseFirestore

final class PhotoModel {

    let db = Firestore.firestore()
    
    func addPhoto(imagePath: String, latitude: Double, longitude: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        // todo: Auth
        //        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userId = "hoge"
        let data = ["imagePath": imagePath,
                    "location": GeoPoint(latitude: latitude, longitude: longitude),
                    "userId": userId,
                    "createdAt": FieldValue.serverTimestamp(),
                    "updatedAt": FieldValue.serverTimestamp()] as [String: Any]
        db.collection("photos")
            .addDocument(data: data) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
        }
    }
}
