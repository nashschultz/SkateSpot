//
//  SkateSpotTableViewCell.swift
//  SkateSpot
//
//  Created by Nash Schultz on 3/20/22.
//

import UIKit

class SkateSpotTableViewCell: UITableViewCell {
    
    @IBOutlet weak var spotImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        spotImageView.layer.cornerRadius = spotImageView.frame.height / 2
        spotImageView.backgroundColor = .systemGray5
    }
    
    func setUp(spot: Spot) {
        if let imageUrl = spot.image, let url = URL(string: imageUrl) {
            spotImageView.load(url: url)
        }
        titleLabel.text = spot.name
    }
}
