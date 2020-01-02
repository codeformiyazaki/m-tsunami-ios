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

    func addSnapshotListener(completion: @escaping(Result<Photo, Error>) -> Void) {
        db.collection("photos")
        .addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot, error == nil else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let photo = Photo(data: diff.document.data())
                    completion(.success(photo))
                }
            }
        }
    }

    func fetchPhotos(completion: @escaping(Result<[Photo], Error>) -> Void) {
        db.collection("photos")
            .order(by: "createdAt", descending: true)
            .limit(to: 100)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error)); return
                }
                let photos = (snapshot?.documents ?? []).map { Photo(data: $0.data()) }
                completion(.success(photos))
        }
    }

    func addPhoto(imagePath: String, comment: String?, latitude: Double, longitude: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = UserManager.sharedInstance.userId else { return }

        let data = ["imagePath": imagePath,
                    "comment": comment ?? "",
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
