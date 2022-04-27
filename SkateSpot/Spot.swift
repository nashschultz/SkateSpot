//
//  Spot.swift
//  SkateSpot
//
//  Created by Nash Schultz on 3/20/22.
//

import Foundation
import UIKit
import FirebaseFirestore

class Spot {
    var id: String?
    var name: String?
    var description: String?
    var rating: Int?
    var image: String?
    var location: GeoPoint?
    
    init(id: String?, name: String, description: String, rating: Int, image: String, location: GeoPoint) {
        self.id = id
        self.name = name
        self.description = description
        self.rating = rating
        self.image = image
        self.location = location
    }
}
