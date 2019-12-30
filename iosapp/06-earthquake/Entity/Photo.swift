//
//  Photo.swift
//  06-earthquake
//
//  Created by koogawa on 2019/12/30.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Photo {

    var userId: String
    var imagePath: String
    var location: GeoPoint
    var createdAt: Timestamp?
    var updatedAt: Timestamp?

    init(data: [String: Any]) {
        userId    = data["userId"] as? String ?? ""
        imagePath = data["imagePath"] as? String ?? ""
        location  = data["location"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
        createdAt = data["createdAt"] as? Timestamp
        updatedAt = data["updatedAt"] as? Timestamp
    }
}
