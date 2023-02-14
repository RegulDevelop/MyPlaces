//
//  CustomTableViewCell.swift
//  MyPlaces
//
//  Created by Anton Tyurin on 09.02.2023.
//

import UIKit
import Cosmos

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfPlace: UIImageView! {
        didSet {
            // skruglyaem kartinku, vysotu stroki delem na 2
            imageOfPlace.layer.cornerRadius = imageOfPlace.frame.size.height / 2
            // obrezka izobrajeniya po granicam imageView
            imageOfPlace.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet var cosmosView: CosmosView! {
        didSet {
            cosmosView.settings.updateOnTouch = false
        }
    }
    
    
}
