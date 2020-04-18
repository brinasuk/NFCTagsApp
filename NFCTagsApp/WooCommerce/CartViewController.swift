//
//  CartViewController.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 4/17/20.
//  Copyright © 2020 Hillside Software. All rights reserved.
//


import Parse
import UIKit
import Kingfisher

private var ownerObjects:[CartModel] = []
private var cellIdentifier = "CartItemCell"
private var placeholderImage:UIImage?

    final class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartFooter: CartFooterCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shopping Cart"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        loadObjects()
        
    }
        
            func loadObjects()
            {
                let query = PFQuery(className: "Cart")
                query.whereKey("userEmail", equalTo:kAppDelegate.currentUserEmail!)
                query.order(byDescending: "updatedDate")
                query.order(byAscending: "rating")
                
                query.limit = 30
                ownerObjects = []  //or removeAll
                var rowCount = 0
                
                let sv = UIViewController.displaySpinner(onView: self.view)
                
                query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                    
                    if let error = error {
                        UIViewController.removeSpinner(spinner: sv)
                        // Log details of the failure
                        print(error.localizedDescription)
                    } else if let objects = objects {
                        
                        for object in objects {
                            
                            let createdAt:Date = object.createdAt!
                            let tagObjectId:String = object.objectId! //Used for Photo Name
                            
                            //TODO: SEE HERE HOW IT IS DONE
                            //let alex = object["ownerPhone"] as? String ?? ""
                            //print(alex)
                            
                            let tagTitle = object["tagTitle"] as? String ?? ""
                            let userName = object["userName"] as? String ?? ""
                            let userEmail = object["userEmail"] as? String ?? ""
                            let rating = object["rating"] as? String ?? ""
                            let quantity:Int = object["rating"] as? Int ?? 1

                            let newObject = CartModel(createdAt: createdAt, tagObjectId: tagObjectId, tagTitle: tagTitle, userName: userName, userEmail: userEmail, rating: rating, quantity: quantity)
                            
                            ownerObjects.append(newObject)
                            rowCount = rowCount + 1
                        }
                    }
                    
                    //RUN ON MAIN THREAD
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        UIViewController.removeSpinner(spinner: sv)
                    }
                }
            }
            

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = ownerObjects.count
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cellIdentifier = "CartItemCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CartItemCell
        
        let cart = ownerObjects[indexPath.row] //The Vige
        
        cell.nameLabel.text = cart.tagTitle
        
        //==== IMAGE CODE ======================================
        //        let cloudinaryAction = "Tag"
        //        let usePhotoRef:String? = owner.ownerObjectId
        //        let photoNumber = 1
        //        let propertyPhotoFileUrl:String? = createNewPhotoURL(cloudinaryAction, withID: usePhotoRef, withNumber: photoNumber) ?? ""
        
        
        
        var propertyPhotoFileUrl:String = ""
            propertyPhotoFileUrl = String(format: "%@%@-%@-%ld.jpg", SERVERFILENAME, "Tag", cart.tagObjectId, 1)

        //cell.productImageView.layer.cornerRadius
        //cell.productImageView.frame.size.width
        //cell.productImageView.layer.masksToBounds = true
        //cell.productImageView.clipsToBounds = true
        
        //cell.productImageView.kf.indicatorType = .activity
        
        // METHOD 1: ======================================
        //        cell.tagImageView?.image = placeholderImage
        //        if let url = URL(string: propertyPhotoFileUrl! ) {
        //            cell.tagImageView.image = resizedImage(at: url, for: CGSize(width: 88,height: 88))
        //        }
        
        //print(propertyPhotoFileUrl)
        
        // METHOD 2: ======================================
        if let url = URL(string: propertyPhotoFileUrl ) {
            //            cell.tagImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
            // Round corner
            //let processor = RoundCornerImageProcessor(cornerRadius: 20)
            
            /*
             // Downsampling
             let processor = DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))
             
             // Cropping
             let processor = CroppingImageProcessor(size: CGSize(width: 100, height: 100), anchor: CGPoint(x: 0.5, y: 0.5))
             
             // Blur
             let processor = BlurImageProcessor(blurRadius: 5.0)
             
             // Overlay with a color & fraction
             let processor = OverlayImageProcessor(overlay: .red, fraction: 0.7)
             
             // Tint with a color
             let processor = TintImageProcessor(tint: .blue)
             
             // Adjust color
             let processor = ColorControlsProcessor(brightness: 1.0, contrast: 0.7, saturation: 1.1, inputEV: 0.7)
             
             // Black & White
             let processor = BlackWhiteProcessor()
             
             // Blend (iOS)
             let processor = BlendImageProcessor(blendMode: .darken, alpha: 1.0, backgroundColor: .lightGray)
             
             // Compositing
             let processor = CompositingImageProcessor(compositingOperation: .darken, alpha: 1.0, backgroundColor: .lightGray)
             
             // Use the process in view extension methods.
             imageView.kf.setImage(with: url, options: [.processor(processor)])
             */
            //TODO: FIX SIZE
            let processor = CroppingImageProcessor(size: CGSize(width: 100, height: 100), anchor: CGPoint(x: 0.5, y: 0.5))
            let placeholderImage = UIImage(named: "icons8-camera-1")
            cell.productImageView.kf.setImage(with: url, placeholder: placeholderImage, options: [.processor(processor)])
        }
        
        //=================================================
        
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.accessoryView = UIImageView(image: UIImage(named: "DisclosureIndicator"))
        
        
//        cell.tagImageView.contentMode = .scaleAspectFit //APRIL 2018 WAS FILL
        
        cell.accessoryType = .detailDisclosureButton
        
        cell.backgroundColor = backgroundColor

        
        return cell
    }

}
