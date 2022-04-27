//
//  ImageUploader.swift
//  SkateSpot
//
//  Created by Nash Schultz on 4/22/22.
//

import Foundation
import FirebaseStorage

class ImageUploader {
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func uploadMedia(data: Data, completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child(randomString(length: 6) + ".png")
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                completion(nil)
            } else {
                storageRef.downloadURL(completion: { (url, error) in
                    completion(url?.absoluteString)
                })
            }
        }
    }
}
