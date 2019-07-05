//
//  RestaurantDetailHeaderView.swift
//  FoodPin
//
//  Created by Alex Levy on 5/14/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit



class RestaurantDetailHeaderView: UIView {
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var nameLabel:UILabel! {
        didSet {
            nameLabel.numberOfLines = 0
        }
    }
    @IBOutlet var typeLabel:UILabel! {
        didSet {
            typeLabel.layer.cornerRadius = 5.0
            typeLabel.layer.masksToBounds = true
        }
    }
    //@IBOutlet var heartImageView: UIImageView!
    
    

}
