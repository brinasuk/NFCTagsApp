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
    @IBOutlet var titleLabel:UILabel! {
        didSet {
            titleLabel.numberOfLines = 0
        }
    }
    @IBOutlet var subTitleLabel:UILabel! {
        didSet {
            subTitleLabel.numberOfLines = 0
        }
    }
    @IBOutlet var priceLabel:UILabel! {
        didSet {
            priceLabel.layer.cornerRadius = 5.0
            priceLabel.layer.masksToBounds = true
        }
    }
    //@IBOutlet var heartImageView: UIImageView!
    
    

}
