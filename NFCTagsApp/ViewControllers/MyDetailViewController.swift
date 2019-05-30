//
//  MyDetailViewController.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 5/26/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MyDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

var tag = TagModel()
@IBOutlet var tableView: UITableView!
@IBOutlet var headerView: RestaurantDetailHeaderView!


//var restaurant = Restaurant()
//    @IBOutlet weak var headerView: RestaurantDetailHeaderView!

override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.largeTitleDisplayMode = .never
    
    // Set the table view's delegate and data source
    tableView.delegate = self
    tableView.dataSource = self
    
    // Configure the table view's style
    tableView.separatorStyle = .singleLine
    
    // Customize the navigation bar
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.tintColor = .red
    navigationController?.hidesBarsOnSwipe = false
    
    tableView.contentInsetAdjustmentBehavior = .never
    
    
    
    // DISPLAY DATABASE VALUES
    headerView.nameLabel.text = tag.tagTitle
    headerView.typeLabel.text = tag.tagSubTitle
    //headerView.headerImageView.image = UIImage(named: "restaurant")
    
    // SHOW PHOTO
    let tagPhotoRef = tag.tagPhotoRef
    let cloudinaryAction = "Tag"
    let usePhotoRef:String? = tagPhotoRef
    let photoNumber = 1
    let propertyPhotoFileUrl:String? = createPhotoURL(cloudinaryAction, withID: usePhotoRef, withNumber: photoNumber) ?? ""
    
    //print(propertyPhotoFileUrl)
    
    //        cell.tagImageView.layer.cornerRadius = cell.tagImageView.frame.size.width / 4
    //        cell.tagImageView.layer.masksToBounds = true
    //        cell.tagImageView.clipsToBounds = true
    
    // METHOD 1: ======================================
    //                let url = URL(string: propertyPhotoFileUrl!)!
    //                headerView.headerImageView.image = resizedImage(at: url, for: CGSize(width: 375,height: 358))
    //=================================================
    
    // METHOD 2: ======================================
    let url = URL(string: propertyPhotoFileUrl!)!
    let placeholderImage = UIImage(named: "Photo-Unavailbale-300-Square")!
    headerView.headerImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
    //=================================================
    
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        //NB: THIS LINE UNHIDES THE NAVIGATION BUTTON
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

func createPhotoURL(_ useAction: String?, withID useID: String?, withNumber useNumber: Int) -> String? {
    if useID == nil {
        return nil
    }
    var url = ""
    url = String(format: "%@%@-%@-%ld.jpg", SERVERFILENAME, useAction ?? "", useID ?? "", useNumber)
    //NSLog(@"URL: %@",url);
    return url
    
}

func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
    let options: [CFString: Any] = [
        kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceShouldCacheImmediately: true,
        kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
    ]
    
    guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
        let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
        else {
            return nil
    }
    
    return UIImage(cgImage: image)
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(named: "phone")
            //cell.shortTextLabel.text = restaurant.phone
            cell.shortTextLabel.text = tag.tagId
            cell.selectionStyle = .none
            
            return cell
        case 1:
            var addr:String
            addr = tag.tagAddress + " " + tag.tagAddress2 + " " + tag.tagCity
//            let myString = "  \t\t  Let's trim all the whitespace  \n \t  \n  "
//            let trimmedString = myString.stringByTrimmingCharactersInSet(
//                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(named: "map")
            cell.shortTextLabel.text = addr
            cell.selectionStyle = .none

            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            //cell.descriptionLabel.text = restaurant.description
            cell.descriptionLabel.text = tag.tagInfo
            cell.selectionStyle = .none
            
            return cell
            
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
