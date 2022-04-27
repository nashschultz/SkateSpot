//
//  UIImageView+Extensions.swift
//  SkateSpot
//
//  Created by Nash Schultz on 4/19/22.
//

import Foundation
import UIKit

class ImageCache {
    private static var images: [String: UIImage] = [String: UIImage]()
    
    static func loadImage(url: String) -> UIImage? {
        return images[url]
    }
    
    static func addImage(url: String, image: UIImage) {
        images[url] = image
    }
}

extension UIImageView {
    func load(url: URL) {
        if let image = ImageCache.loadImage(url: url.absoluteString) {
            self.image = image
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        ImageCache.addImage(url: url.absoluteString, image: image)
                        return
                    }
                }
            }
        }
        self.image = nil
    }
}
