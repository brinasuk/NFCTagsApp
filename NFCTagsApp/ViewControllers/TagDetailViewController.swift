//
//  TagDetailViewController.swift
//
//  Created by Alex Levy on 5/26/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TagDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
    var tag = TagModel()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: RestaurantDetailHeaderView!

override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.largeTitleDisplayMode = .never
    
    // Set the table view's delegate and data source
    tableView.delegate = self
    tableView.dataSource = self
    
    // Configure the table view's style
    tableView.separatorStyle = .singleLine
    tableView.contentInsetAdjustmentBehavior = .never
    

//    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//    navigationController?.navigationBar.shadowImage = UIImage()
//    navigationController?.navigationBar.tintColor = .red
//    navigationController?.hidesBarsOnSwipe = false

    showInfo()
    
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
        navigationController?.hidesBarsOnSwipe = false
        //NB: THIS LINE UNHIDES THE NAVIGATION BAR
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupNavigationBar() {
        //Customize the navigation bar
        //The following 2 lines make the Navigation Bar transparant
        
        //    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //    navigationController?.navigationBar.shadowImage = UIImage()
        //    navigationController?.navigationBar.tintColor = .red
        //    navigationController?.hidesBarsOnSwipe = false
        
        //HIDE EMPTY CELLS WHEM YOU HAVE TOO FEW TO FILL THE TABLE
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //METHOD 1
        //        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: .bold) ]
        //        navigationItem.largeTitleDisplayMode = .always
        
        //METHOD2
        if let customFont = UIFont(name: "Rubik-Medium", size: 34.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor .darkText, NSAttributedString.Key.font: customFont ]
        }
        
    }
    
    func showInfo() {
        /*
         TITLE
         SUBTITLE
         PRICE
         
         COMPANY  //CANNOT CHANGE
         CONTACT
         PHONE
         EMAIL  //CANNOT CHANGE
         
         ADDRFULL
         URL
         
         INFO
         */
        
        
        // DISPLAY DATABASE VALUES
        headerView.nameLabel.text = tag.tagTitle
        headerView.typeLabel.text = tag.tagPrice

        
        // SHOW PHOTO
        //headerView.headerImageView.image = UIImage(named: "restaurant")
        let tagPhotoRef = tag.tagPhotoRef
        let cloudinaryAction = "Tag"
        let usePhotoRef:String? = tagPhotoRef
        let photoNumber = 1
        let propertyPhotoFileUrl:String? = UIViewController.createNewPhotoURL(cloudinaryAction, withID: usePhotoRef, withNumber: photoNumber) ?? ""
        
        //        cell.tagImageView.layer.cornerRadius = cell.tagImageView.frame.size.width / 4
        //        cell.tagImageView.layer.masksToBounds = true
        //        cell.tagImageView.clipsToBounds = true
        
        // METHOD 1: ======================================
        //                let url = URL(string: propertyPhotoFileUrl!)!
        //                headerView.headerImageView.image = resizedImage(at: url, for: CGSize(width: 375,height: 358))
        //=================================================
        
        // METHOD 2: ======================================
        let url = URL(string: propertyPhotoFileUrl!)!
        let placeholderImageName = kAppDelegate.placeholderName
        let placeholderImage = UIImage(named: placeholderImageName! as String)!
        headerView.headerImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        //=================================================
    }
    






    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        /*
         TITLE
         SUBTITLE
         PRICE
         */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            
            //COMPANY  //CANNOT CHANGE
            //CONTACT (OWNERNAME)
            //PHONE      (OWNERPHONE)
            //EMAIL  //CANNOT CHANGE
            //ADDRFULL
            //INFO
            //NOT USED HERE: URL
            
        case 0: //PHONE
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(named: "phone")
            cell.shortTextLabel.text = tag.ownerPhone
            cell.selectionStyle = .none
            return cell
            
//        case 1: //EMAIL
//            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
//            cell.iconImageView.image = UIImage(named: "phone")
//            cell.shortTextLabel.text = tag.ownerEmail
//            cell.selectionStyle = .none
//            return cell
            
        case 1:  //ADDRESS
            var addr:String
            addr = tag.tagAddress + " " + tag.tagAddress2 + " " + tag.tagCity
            
            // Ex Showing how to remove TRAILING WHITESPACE
            let myString = "  \t\t  Let's trim all the whitespace  \n \t  \n  "
            let newString = myString.trimmingCharacters(in: CharacterSet.whitespaces)
            print(newString)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(named: "map")
            cell.shortTextLabel.text = addr
            cell.selectionStyle = .none
            return cell
            
        case 2:  //INFO
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            //cell.descriptionLabel.text = restaurant.description
            cell.descriptionLabel.text = tag.tagInfo
            cell.selectionStyle = .none
            
            return cell
            
        case 3:  //MAP TITLE
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailSeparatorCell.self), for: indexPath) as! RestaurantDetailSeparatorCell
            cell.titleLabel.text = "HOW TO GET HERE"
            cell.selectionStyle = .none
            
            return cell
            
        case 4:  //SHOW MAP
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMapCell.self), for: indexPath) as! RestaurantDetailMapCell
            var addr = tag.tagAddress + " " + tag.tagAddress2 + " " + tag.tagCity
            cell.configure(location: addr)  //NOTE: THIS IS DEFINED IN THE CELL
            cell.selectionStyle = .none
            
            return cell

            
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.tag = tag
        }
    }
    
    // MARK: - Status bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
        // MARK: - MISC ROUTINES
    func displayMessage(message:String) {
        let alertView = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
    
    func displayErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
    
    //func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
    //    let options: [CFString: Any] = [
    //        kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
    //        kCGImageSourceCreateThumbnailWithTransform: true,
    //        kCGImageSourceShouldCacheImmediately: true,
    //        kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
    //    ]
    //
    //    guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
    //        let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
    //        else {
    //            return nil
    //    }
    //
    //    return UIImage(cgImage: image)
    //}

}
