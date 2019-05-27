//
//  MyDetailViewController.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 5/26/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

import UIKit

class MyDetailViewController: UIViewController {
    

    @IBOutlet weak var headerView: TagDetailHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    var myNameLabel:String?
    
    //var restaurant = Restaurant()
//    @IBOutlet weak var headerView: RestaurantDetailHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.nameLabel.text = myNameLabel
        headerView.typeLabel.text = "POOCHIE"
        
        
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
