//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Simon Ng on 13/8/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    //var restaurant = Restaurant()
    
    @IBOutlet weak var headerView: RestaurantDetailHeaderView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
//        headerView.nameLabel.text = restaurant.name
//        headerView.typeLabel.text = restaurant.type
//        headerView.headerImageView.image = UIImage(named: restaurant.image)
//        headerView.heartImageView.isHidden = (restaurant.isVisited) ? false:true
        
        
        navigationItem.largeTitleDisplayMode = .never
    }
    



}
