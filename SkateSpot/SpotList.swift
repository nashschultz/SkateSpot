//
//  SpotList.swift
//  SkateSpot
//
//  Created by Nash Schultz on 3/20/22.
//

import Foundation
import FirebaseFirestore

class SpotList {
    
    var spots: [Spot] = [Spot]()
    var db: Firestore
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadSpots(updateTable: @escaping () -> Void) {
        db.collection("spots").getDocuments { snapshot, err in
            if let err = err {
                print(err)
            } else {
                for doc in snapshot?.documents ?? [] {
                    let data = doc.data()
                    let spot = Spot(id: doc.documentID,
                                    name: data["name"] as? String ?? "",
                                    description: data["description"] as? String ?? "",
                                    rating: data["rating"] as? Int ?? 0,
                                    image: data["image"] as? String ?? "",
                                    location: data["location"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0))
                    self.spots.append(spot)
                }
            }
            updateTable()
        }
    }
    
    func addSpot(spot: Spot) {
        let document = Firestore.firestore().collection("spots").addDocument(data: [
            "name": spot.name as Any,
            "description": spot.description as Any,
            "image": spot.image ?? "",
            "location": spot.location as Any,
            "rating": 0])
        spot.id = document.documentID
        spots.append(spot)
    }
    
    func removeSpot(spot: Spot) {
        if let id = spot.id {
            Firestore.firestore().collection("spots").document(id).delete()
        }
        spots.removeAll(where: { $0.id == spot.id })
    }
    
    func rateSpot(spot: Spot, val: Int) {
        if let id = spot.id {
            Firestore.firestore().collection("spots").document(id).updateData(["rating": FieldValue.increment(Int64(val))])
        }
        spot.rating = (spot.rating ?? 0) + val
    }
}
