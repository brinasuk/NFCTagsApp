//
//  RestaurantDetailIconTextCellTableViewCell.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 5/27/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

import UIKit

    class RestaurantDetailIconTextCell: UITableViewCell {
        
        @IBOutlet weak var iconImageView: UIImageView!
        
        @IBOutlet weak var shortTextLabel: UILabel! {
            didSet {
                shortTextLabel.numberOfLines = 0
            }
        }
        
}
