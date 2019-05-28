//
//  RestaurantDetailTextCell.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 5/27/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

import UIKit


class RestaurantDetailTextCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 0
        }
    }
}
