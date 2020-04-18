
//
//  DetailViewController.swift
//
//  Created by Alex Levy on 5/26/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

import UIKit
//import Alamofire
//import AlamofireImage
import Kingfisher
import MessageUI
import SafariServices
import Parse
import AVFoundation
import Alertift

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
    var tag = TagModel()
    var player: AVAudioPlayer?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: DetailHeaderView!

    @IBOutlet weak var noteButton: UIBarButtonItem!

    var ratingKeep = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDarkMode()

        headerView.ratingImageView.isUserInteractionEnabled = true
        headerView.ratingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        
        navigationItem.largeTitleDisplayMode = .never
        
        // Set the table view's delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Configure the table view's style
        tableView.separatorStyle = .singleLine
        tableView.contentInsetAdjustmentBehavior = .never
        
        ratingKeep = tag.rating
        
        showInfo()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //hideNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    func hideNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
            navigationController?.navigationBar.tintColor = mainColor
        
        
        //NB: THIS LINE UNHIDES THE NAVIGATION BAR
        //YOU ABSOLUTELY WANT THE BACK BUTTON. JUST MAKE EVERYTHING ELSE TRANSPARENT
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        // ADD THIS
        navigationController?.navigationBar.backgroundColor = .clear

        if #available(iOS 13.0, *) {
        let transparentAppearance = UINavigationBarAppearance()
            transparentAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = transparentAppearance
        navigationController?.navigationBar.standardAppearance = transparentAppearance
        }
    }
    
    func  setupDarkMode() {
    if (kAppDelegate.isDarkMode == true)
    {if #available(iOS 13.0, *) {overrideUserInterfaceStyle = .dark}
    } else {
        kAppDelegate.isDarkMode = false  // Fallback on earlier versions
        }
    }
    
    func showInfo() {
        // DISPLAY DATABASE VALUES
        headerView.titleLabel.text = tag.tagTitle
        headerView.subTitleLabel.text = tag.tagSubTitle
        //TODO: WINE APP ONLY
        headerView.subTitleLabel.text = tag.tagSubTitle + ". " + tag.tagCountry
        headerView.priceLabel.text = tag.tagPrice
        headerView.ratingImageView.image = UIImage(named: tag.rating)
        
        
        // SHOW PHOTO
        //        let tagPhotoRef = tag.tagPhotoRef
        //        let cloudinaryAction = "Tag"
        //        let usePhotoRef:String? = tagPhotoRef
        //        let photoNumber = 1
        //        let propertyPhotoFileUrl:String? = UIViewController.createNewPhotoURL(cloudinaryAction, withID: usePhotoRef, withNumber: photoNumber) ?? ""
    
        
        var propertyPhotoFileUrl:String = ""
        if (tag.tagPhotoRef == "") {
            propertyPhotoFileUrl = "icons8-camera-1"}
        else {
            propertyPhotoFileUrl = String(format: "%@%@-%@-%ld.jpg", SERVERFILENAME, "Tag", tag.tagPhotoRef, 1)
        }
        
        //"https://photos.homecards.com/rebeacons/Tag-bEGrwzfWdV-1.jpg"
        
        //        cell.tagImageView.layer.cornerRadius = cell.tagImageView.frame.size.width / 4
        //        cell.tagImageView.layer.masksToBounds = true
        //        cell.tagImageView.clipsToBounds = true
        
        // METHOD 1: ======================================
        //                let url = URL(string: propertyPhotoFileUrl!)!
        //                headerView.headerImageView.image = resizedImage(at: url, for: CGSize(width: 375,height: 358))
        //=================================================
        
        //print(propertyPhotoFileUrl)
        
        // METHOD 2: ======================================
        //        let url = URL(string: propertyPhotoFileUrl!)!
        //        let placeholderImageName = kAppDelegate.placeholderName
        //        let placeholderImage = UIImage(named: placeholderImageName! as String)!
        //        headerView.headerImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        
        //=================================================
        
        // METHOD 3: KINGFISHER ============================
        //                let propertyPhotoFileUrl = "https://photos.homecards.com/rebeacons/Tag-bEGrwzfWdV-1.jpg"
        
        //print(propertyPhotoFileUrl)
        //        let url = URL(string: propertyPhotoFileUrl!)!
        //        photoImageView.kf.setImage(with: url)
        //                photoImageView.kf.setImage(with: url, options: [.transition(.fade(2.0))])
        
        let url = URL(string: propertyPhotoFileUrl)
        //Size refer to the size which you want to resize your original image
        
        let placeholderImage = UIImage(named: "icons8-camera-1")
        //TODO: Fix SIZE Width and Height. Plug in correct values
        let processor = ResizingImageProcessor.init(referenceSize: CGSize(width: 375, height: 200), mode: .aspectFit)
        
        headerView.headerImageView.kf.indicatorType = .activity
        headerView.headerImageView.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1.0)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                //self.imageToUpload = (self.photoImageView.image ?? UIImage())! //or UIImage(
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                //self.imageToUpload = nil
                print("Job failed: \(error.localizedDescription)")
            }
        }
        //=================================================
    }
    
    
    
    @objc private func imageTapped(_ recognizer: UITapGestureRecognizer) {
        //print("image tapped")
        performSegue(withIdentifier: "ShowReview", sender: self)
    }
    
    // MARK: - Action Buttons Pressed
    
    @IBAction func cartButtonPressed(_ sender: Any) {
        
        let tagTitle = tag.tagTitle

                let sv = UIViewController.displaySpinner(onView: self.view)
                //WE DO HAVE A TAG. SEE IF YOU CAN FIND IT IN THE DATABASE
                let query = PFQuery(className: "Cart")
                query.whereKey("tagObjectId", equalTo: self.tag.tagObjectId)
                query.whereKey("userEmail", equalTo: kAppDelegate.currentUserEmail!)

                query.getFirstObjectInBackground {(object: PFObject?, error: Error?) in
                    if let error = error {
                        // NO MATCH FOUND
                        UIViewController.removeSpinner(spinner: sv)
                        
                        let message = "Add '" + tagTitle + "' to Cart?"
                        print("NO MATCH FOUND")
                        Alertift.alert(title: "Shopping Cart",message: message)
                            .action(.default("Yes"), isPreferred: true) { (_, _, _) in
                                self.addToCart()
                                
                            }
                            .action(.cancel("No")) { (_, _, _) in
                                //DO NOTHING
                            }
                            .show()

                    } else if let object = object {
                        UIViewController.removeSpinner(spinner: sv)
                        
                        //var cartObjectId = object["ObjectId"] as String
                        let message = "Remove '" + tagTitle + "' from Cart?"
                        let cartObjectId = object.objectId
                        print(cartObjectId ?? "NoWAYS")
                        Alertift.alert(title: "Shopping Cart",message: message)
                            .action(.default("Yes"), isPreferred: true) { (_, _, _) in

                                
                                                object.deleteInBackground {
                                                    (success: Bool, error: Error?) in
                                                    if (success) {
                                                        UIViewController.removeSpinner(spinner: sv)
                                                        print("The object has been deleted.")
                                                        self.displayMessage(message: "Successfully Removed")
                                                    } else {
                                                        UIViewController.removeSpinner(spinner: sv)
                                                        print ("There was a problem, check error.description")
                                                        self.displayErrorMessage(message: "Cannot delete Info")
                                                    }
                                                }
                                
                            }
                            .action(.cancel("No")) { (_, _, _) in
                                //DO NOTHING
                            }
                            .show()

                    }
                }
        

    }
    
    @IBAction func noteButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "NOTESEGUE", sender: self)
    }
    
    @IBAction func mapButtonPressed(_ sender: Any) {
        /* DOES NOT WORK - DELETE
        let vc = instantiateViewController(withIdentifier: "THNotesTextView") as! THNotesTextView
        self.dismiss(animated: false, completion: nil)
        self.presentingViewController?.present(vc, animated: false, completion: nil)
        
        var instanceOfCustomObject = THNotesTextView()
        //instanceOfCustomObject.someProperty = "Hello World"
        //print(instanceOfCustomObject.someProperty)
        //instanceOfCustomObject.someMethod()
        
        */
        
        performSegue(withIdentifier: "SwiftyMap", sender: self)
    }
    
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        let activityController: UIActivityViewController
        let textToShare = "Check out: " + tag.tagTitle
        
        if let url = URL.init(string: tag.tagUrl)
        {
            let imageData: NSData = ((headerView.headerImageView.image!.jpegData(compressionQuality: 0.25)  as NSData?)!)
            let shareAll = [textToShare , imageData, url] as [Any?]
            activityController = UIActivityViewController(activityItems: shareAll as [Any], applicationActivities: nil)
        } else {
            activityController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        }
        self.present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func websiteButtonPressed(_ sender: UIBarButtonItem) {
        //print("WEBSITEBUTTONPRESSED")
        let urlString = tag.tagUrl
        if let url = URL(string: urlString ) {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
            //open (scheme: urlString)
        } else {
            displayMessage(message: "Invalid Web URL")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {

            //0 COMPANY  //CANNOT CHANGE
            //1 CONTACT (OWNERNAME)
            //2 PHONE      (OWNERPHONE)
            //3 EMAIL  //CANNOT CHANGE
            //4 ADDRFULL
            //5 INFO
            //NOT USED HERE: URL
            
        case 0: //COMPANY
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            
            if #available(iOS 13.0, *) {
                let companyImage = UIImage(systemName: "rectangle.stack.person.crop")!
                let dmCompanyImage = companyImage.withTintColor(.label, renderingMode: .alwaysOriginal)
                cell.iconImageView.image = dmCompanyImage
            } else {
                cell.iconImageView.image = UIImage(named: "company")
            }
            
            cell.shortTextLabel.text = tag.tagCompany
            cell.selectionStyle = .none
            return cell
            
        case 1: //CONTACT
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            
            if #available(iOS 13.0, *) {
                let contactImage = UIImage(systemName: "person")!
                let dmContactImage = contactImage.withTintColor(.label, renderingMode: .alwaysOriginal)
                cell.iconImageView.image = dmContactImage
            } else {
                cell.iconImageView.image = UIImage(named: "contact")
            }
            
            cell.shortTextLabel.text = tag.ownerName
            cell.selectionStyle = .none
            return cell
            
        case 2: //PHONE
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            
            if #available(iOS 13.0, *) {
                let phoneImage = UIImage(systemName: "phone")!
                let dmPhoneImage = phoneImage.withTintColor(.label, renderingMode: .alwaysOriginal)
                cell.iconImageView.image = dmPhoneImage
            } else {
                cell.iconImageView.image = UIImage(named: "phone")
            }
            
            cell.shortTextLabel.text = tag.ownerPhone
            cell.selectionStyle = .none
            return cell
            
        case 3: //EMAIL
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            
            if #available(iOS 13.0, *) {
                let emailImage = UIImage(systemName: "envelope")!
                let dmEmailImage = emailImage.withTintColor(.label, renderingMode: .alwaysOriginal)
                cell.iconImageView.image = dmEmailImage
            } else {
                cell.iconImageView.image = UIImage(named: "email")
            }
            
            cell.shortTextLabel.text = tag.ownerEmail
            cell.selectionStyle = .none
            return cell
            
        ////////////////////////////////////////
        case 4:  //ADDRESS
            var addr:String
            addr = tag.tagAddress + " " + tag.tagAddress2 + " " + tag.tagCity
            
            //            // Ex Showing how to remove TRAILING WHITESPACE
            //            let myString = "  \t\t  Let's trim all the whitespace  \n \t  \n  "
            //            let newString = myString.trimmingCharacters(in: CharacterSet.whitespaces)
            //            print(newString)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            
            if #available(iOS 13.0, *) {
                let mapImage = UIImage(systemName: "map")!
                let dmMapImage = mapImage.withTintColor(.label, renderingMode: .alwaysOriginal)
                cell.iconImageView.image = dmMapImage
            } else {
                cell.iconImageView.image = UIImage(named: "map")
            }
            
            cell.shortTextLabel.text = addr
            cell.selectionStyle = .none
            return cell
            
        case 5:  //INFO
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            //cell.descriptionLabel.text = restaurant.description
            cell.descriptionLabel.text = tag.tagInfo
            cell.selectionStyle = .none
            
            return cell
            
        case 6:  //MAP TITLE
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailSeparatorCell.self), for: indexPath) as! RestaurantDetailSeparatorCell
            cell.titleLabel.text = "MAP"  //HOW TO GET HERE
            cell.selectionStyle = .none
            
            return cell
            
        case 7:  //SHOW MAP
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMapCell.self), for: indexPath) as! RestaurantDetailMapCell
            //var addr = tag.tagAddress + " " + tag.tagAddress2 + " " + tag.tagCity
            let addr = tag.tagAddrFull
            //TODO: SWIFTY MAP USES LAT/LON. CHOOSE ONE WAY OR THE OTHER
            cell.configure(location: addr)  //NOTE: THIS IS DEFINED IN THE CELL
            cell.selectionStyle = .none
            
            return cell
            
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print(segue.identifier!)
        if segue.identifier == "ShowReview" {
            let destinationController = segue.destination as! ReviewViewController
            destinationController.tag = tag
        }
            
//        else if segue.identifier == "SwiftyMap" {
//            let destinationController = segue.destination as! SwiftyMapController
//            destinationController.tag = tag
//        }
            
        else if segue.identifier == "SwiftyMap" {
            let destinationController = segue.destination as! SwiftyMapController
            destinationController.tag = tag
        }
        
        else if segue.identifier == "NOTESEGUE" {
            let destinationController = segue.destination as! NotesViewController

            //PASS THE FOLLOWING 4 VARIABLES TO THE NOTES VIEWCONTROLLER
            destinationController.currentTagId = tag.tagObjectId
            destinationController.currentPhotoRef = tag.tagPhotoRef
            destinationController.currentNoteOwner = kAppDelegate.currentUserEmail!
            destinationController.currentNoteTagTitle = tag.tagTitle
        }
        
//        else if segue.identifier == "CARTSEGUE" {
//            let destinationController = segue.destination as! NotesViewController
//
//            //PASS THE FOLLOWING 4 VARIABLES TO THE NOTES VIEWCONTROLLER
//            destinationController.currentTagId = tag.tagObjectId
//            destinationController.currentPhotoRef = tag.tagPhotoRef
//            destinationController.currentNoteOwner = kAppDelegate.currentUserEmail!
//            destinationController.currentNoteTagTitle = tag.tagTitle
//        }
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateRestaurant(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: {
            if var rating = segue.identifier {
                
                print(rating)
                if rating == "none" {rating = ""}
                
                if rating != self.tag.rating {
                    self.tag.rating = rating
                    self.ratingKeep = rating
                    self.updateRating(passRating: rating)
                    self.headerView.ratingImageView.image = UIImage(named: rating)
                }
                
                let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                self.headerView.ratingImageView.transform = scaleTransform
                self.headerView.ratingImageView.alpha = 0
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
                    self.headerView.ratingImageView.transform = .identity
                    self.headerView.ratingImageView.alpha = 1
                }, completion: nil)
            }
            
            
        })
        
        
    }
    
    func updateRating(passRating:String) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        let query = PFQuery(className: "Tags")
        
        query.whereKey("objectId", equalTo: tag.tagObjectId)
        //print(owner.ownerObjectId)
        query.getFirstObjectInBackground {(object: PFObject?, error: Error?) in
            if let error = error {
                // NO MATCH FOUND
                UIViewController.removeSpinner(spinner: sv)
                print(error.localizedDescription)
                self.displayErrorMessage(message: error.localizedDescription)
            } else if let object = object {
                object["rating"] = passRating
                
                object.saveInBackground {
                    (success: Bool, error: Error?) in
                    if (success) {
                        UIViewController.removeSpinner(spinner: sv)
                        print("The object has been saved.")
                    } else {
                        UIViewController.removeSpinner(spinner: sv)
                        print ("There was a problem, check error.description")
                        self.displayErrorMessage(message: "Cannot save Info")
                    }
                }
            }
        }
    }
    
    
    // MARK: - Status bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - MISC ROUTINES
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
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
    
    
    
    
    /*
     //https://www.hackingwithswift.com/example-code/uikit/how-to-send-an-email
     Make sure you add import MessageUI to any Swift file that uses this code, and you’ll also need to conform to the MFMailComposeViewControllerDelegate protocol.
     
     Note that not all users have their device configure to send emails, which is why we need to check the result of canSendMail() before trying to send. Note also that you need to catch the didFinishWith callback in order to dismiss the mail window.
     
     Warning: this code frequently fails in the iOS Simulator. If you want to test it, try on a real device.
     */
    
    @IBAction func contactUsButtonPressed(_ sender: UIBarButtonItem) {
        
//        print("Bundle.main.infoDictionary - \(Bundle.main.infoDictionary)")
//        print("Bundle.main.localizedInfoDictionary - \(Bundle.main.localizedInfoDictionary)")
        
        let applicationName:String = (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String)!
        print("App Display Name - \(applicationName)")
        
        
        if MFMailComposeViewController.canSendMail()  {
            
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([tag.ownerEmail])
            let subject = tag.tagTitle
            mail.setSubject(subject)
            var message = "I found this while using the " + applicationName + " app. Please send me more information.<br><br>"
            message = message + "\(tag.tagTitle ) <br> \(tag.tagSubTitle )<br>\(tag.tagCompany)"
            
            message = message + "<br><br>From: \(tag.userName)<br>"
            
            let imageData: NSData = (headerView.headerImageView.image!.jpegData(compressionQuality: 0.75)  as NSData?)!
            mail.addAttachmentData(imageData as Data, mimeType: "image/jpeg", fileName: "image.jpg")
            
            mail.setMessageBody(message, isHTML: true)
            self.present(mail, animated: true, completion: nil)
            
        } else {
            displayMessage(message: "Cannot send Email")
            return
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        switch (result) {
        case .cancelled:
            self.dismiss(animated: true, completion: nil)
        case .sent:
            //NOTE: DONT WASTE YOUR TIME. NONE OF THE OLLOWING WORK
            //SOME EVEN HANG UP YOUR APP!!!!!
            
            // create a sound ID, in this case its the tweet sound.
            //let systemSoundID: SystemSoundID = 4095 //VIBRATE
            //let systemSoundID: SystemSoundID = 1303 //MAIL SENT
            
            //AudioServicesPlaySystemSound (systemSoundID)
            //AudioServicesPlayAlertSound(SystemSoundID(1303))   //MAIL SENT
            //playSound()
            
            //USE THIS. IT WORKS!!
            AudioServicesPlayAlertSound(SystemSoundID(1303))   //1303 MAIL SENT  //VIBRATE 4095
            
            self.dismiss(animated: true, completion: nil)
        case .failed:
            self.dismiss(animated: true, completion: {
                let sendMailErrorAlert = UIAlertController.init(title: "Failed",
                                                                message: "Unable to send email. Please check your email " +
                    "settings and try again.", preferredStyle: .alert)
                sendMailErrorAlert.addAction(UIAlertAction.init(title: "OK",
                                                                style: .default, handler: nil))
                self.present(sendMailErrorAlert,
                             animated: true, completion: nil)
            })
        default:
            break;
        }
    }
    

    
/*
    func findInCart(useTagObjectId:String) {
                let sv = UIViewController.displaySpinner(onView: self.view)
                
                //WE DO HAVE A TAG. SEE IF YOU CAN FIND IT IN THE DATABASE
                let query = PFQuery(className: "Cart")
                query.whereKey("tagObjectId", equalTo: useTagObjectId )
                //TODO: PUT BACK query.whereKey("ownerId", equalTo: tag )
                query.getFirstObjectInBackground {(object: PFObject?, error: Error?) in
                    UIViewController.removeSpinner(spinner: sv)
                    if error != nil {
                        // NO MATCH FOUND
                        print("NO MATCH FOUND")

                    } else {
                        print("FOUND")
                    }
    }
    */
    
    func addToCart () {
        // ADD TO CART TABLE
        let cart = PFObject(className:"Cart")
        let sv = UIViewController.displaySpinner(onView: self.view)
        //let ownerEmail = object["ownerEmail"] as? String ?? ""
        let tagTitle = tag.tagTitle
        
        cart["tagTitle"] = tagTitle
        cart["tagObjectId"] = tag.tagObjectId
        
        cart["userName"] = self.kAppDelegate.currentUserName
        cart["userEmail"] = self.kAppDelegate.currentUserEmail
        cart["quantity"] = 1
        //TODO: FINISH ADD ALL ITEMS
        
        /*
        tag["ownerName"] = ownerName
        tag["ownerEmail"] = ownerEmail
        tag["ownerPhone"] = ownerPhone
        tag["appCode"] = ownerAppCode
        tag["sequence"] = NSNumber(value: 1000) //TODO: ALEX STILL NEED TO FIX THIS
        
        tag["userName"] = self.kAppDelegate.currentUserName
        tag["userEmail"] = self.kAppDelegate.currentUserEmail
        
        tag["tagPhotoRef"] = ownerObjectId  /// ownerPhotoRef is NO LONGER USED!
        tag["tagId"] = ownerId
        tag["tagTitle"] = ownerTitle
        tag["tagSubTitle"] = ownerSubTitle
        tag["tagCompany"] = ownerCompany
        tag["tagUrl"] = ownerUrl
        
        tag["tagInfo"] = ownerInfo
        
        tag["tagAddress"] = ownerAddress
        tag["tagAddress2"] = ownerAddress2
        tag["tagCity"] = ownerCity
        tag["tagState"] = ownerState
        tag["tagZip"] = ownerZip
        tag["tagCountry"] = ownerCountry
        
        tag["tagAddrFull"] = ownerAddrFull
        tag["tagPrice"] = ownerPrice
 */

        cart.saveInBackground {
            (success: Bool, error: Error?) in
            if (success) {
                // The object has been saved.
                UIViewController.removeSpinner(spinner: sv)
                self.displayMessage(message: "Successfully Added")
            } else {
                // There was a problem, check error.description
                UIViewController.removeSpinner(spinner: sv)
                self.displayErrorMessage(message: "Unable to add to Cart!")
            }
    }
}

}
    
    
    
    
//    func playSound() {
//        guard let url = Bundle.main.url(forResource: "click", withExtension: "mp3") else { return }
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//            /* iOS 10 and earlier require the following line:
//             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
//
//            guard let player = player else { return }
//
//            player.play()
//
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }


/*
 var usePhotoLink = String(format: "%@%@-%@-%ld.jpg", SERVERFILENAME, "Tag", tag.tagPhotoRef, 1)
 
 let url = URL(string: usePhotoLink )!
 let downloader = ImageDownloader.default
 downloader.downloadImage(with: url) { result in
 switch result {
 
 case .success(let value):
 
 print("Image: \(value.image). Got from: \(value.cacheType)")
 let image:Image = value.image
 if let jpegData:Data = image.jpegData(compressionQuality: 1.0) {
 
 let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(),
 isDirectory: true)
 let temporaryFileURL =
 temporaryDirectoryURL.appendingPathComponent("mailpic.jpg")
 
 print(temporaryFileURL)
 
 let data: Data = jpegData
 try data.write(to: temporaryFileURL,
 options: .atomic)
 
 
 }
 //                let data: Data = jpegData
 //                try data.write(to: temporaryFileURL,
 //                               options: .atomic)
 case .failure(let error):
 print(error)
 }
 }
 
 */

//        if let url = URL(string: usePhotoLink ) {
//            let resource = ImageResource(downloadURL: url)
//            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil )
//            { result in
//                switch result {
//                case .success(let value):
//
//                    print("Image: \(value.image). Got from: \(value.cacheType)")
//                    let image:Image = value.image
//                    if let jpegData:Data = image.jpegData(compressionQuality: 1.0) {
//
//                        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(),
//                                                        isDirectory: true)
//                        let temporaryFileURL =
//                            temporaryDirectoryURL.appendingPathComponent("mailpic.jpg")
//
//                        print(temporaryFileURL)
//
//                        let data: Data = jpegData
//                        try data.write(to: temporaryFileURL,
//                                       options: .atomic)
//
//
//                    }
//
//                case .failure(let msg):
//                    print("NO PHOTO: \(msg)")
//
//
//                }
//            }
//        }


/*
 if let url = URL(string: usePhotoLink ) {
 let resource = ImageResource(downloadURL: url)
 
 KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
 switch result {
 case .success(let value):
 
 print("Image: \(value.image). Got from: \(value.cacheType)")
 let image:Image = value.image
 if let jpegData = image.jpegData(compressionQuality: 1.0) {
 mail.addAttachmentData(jpegData,
 mimeType: "image/jpg",
 fileName: "Image")
 mail.setMessageBody(message, isHTML: true)
 self.present(mail, animated: true, completion: nil)
 }
 
 case .failure(let msg):
 print("NO PHOTO: \(msg)")
 //NO PHOTO. DONT WORRY. JUST PRESENT EMMAIL
 mail.setMessageBody(message, isHTML: true)
 self.present(mail, animated: true, completion: nil)
 }
 }
 */


//    func downloadImage(`with` urlString : String){
//        guard let url = URL.init(string: urlString) else {
//            return
//        }
//        let resource = ImageResource(downloadURL: url)
//
//        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
//            switch result {
//            case .success(let value):
//                print("Image: \(value.image). Got from: \(value.cacheType)")
//            case .failure(let error):
//                print("Error: \(error)")
//            }
//        }
//    }


//BEACON TAPPED MADISON22
// WHENEVER THE USER TAPS A BEACON, SEND THE LEAD TO THE OWNER
/*
 func sendGrid(_ useTitle: String?, usingSubTitle useSubTitle: String?, usingCompany useCompany: String?, usingAddress useAddress: String?, usingOwnerEmail useOwnerEmail: String?) {
 
 let sendgrid = SendGrid.apiUser("hillside_ios", apiKey: "46inh2@sa&12")
 let email = SendGridEmail()
 
 let dateFormat = DateFormatter()
 dateFormat.dateFormat = "EEE, MMM d, h:mm a"
 //[dateFormat setDateFormat:@"yyyy-MM-dd hh:mm a"];  //@"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
 
 let dateSubmitted = "\(dateFormat.string(from: Date()))"
 
 var sendTo: String
 //SEND LEAD TO OWNER
 sendTo = useOwnerEmail ?? ""
 
 let message = "The following Beacon was tapped: <br><br>"
 
 var body = "<h1><b>Beacon Tapped</b></h1>"
 
 body = body + ("<h3>")
 
 body = body + ("<p><b>Date: </b>")
 body = body + (dateSubmitted)
 body = body + ("</p>")
 
 body = body + ("</b><p><b>From: </b>")
 body = body + (kAppDelegate.currentUserName)
 body = body + ("</p>")
 body = body + ("</b><p><b>Email: </b>")
 body = body + (kAppDelegate.currentUserEmail)
 body = body + ("</p>")
 
 body = body + ("</b><p><b>Message: </b>")
 body = body + (message)
 
 
 
 body = body + ("<p><b>Title: </b>")
 body = body + (useTitle ?? "")
 body = body + ("</p>")
 
 body = body + ("<p><b>SubTitle: </b>")
 body = body + (useSubTitle ?? "")
 body = body + ("</p>")
 
 body = body + ("<p><b>Company: </b>")
 body = body + (useCompany ?? "")
 body = body + ("</p>")
 
 body = body + ("<p><b>Address: </b>")
 body = body + (useAddress ?? "")
 body = body + ("</p>")
 
 
 
 body = body + ("</h3>")
 
 
 body = body + ("</p>") //NSString *photoLink = [NSString stringWithFormat:@"<br><p>Click for Photo Link <a href=\"%@\">here</a></p><br>",_finderPhotoFileUrl];
 */


/*
 //TODO: ADD SUPPORT FOR PHOTO
 NSString *usePhotoLink = @"";
 if ([_photoId length]==0) {
 
 usePhotoLink = "https://photos.homecards.com/rebeacons/property_placeholder.jpg"
 } else {
 usePhotoLink = _finderPhotoFileUrl;
 }
 NSString *imageLink = [NSString stringWithFormat:@"<br><p><img src=\"%@\" alt=\"Check that you allow images in your email or no image was provided\" scale=\"0\"></p><br>",usePhotoLink];
 body = [body stringByAppendingString:imageLink];
 */

/*
 body = body + ("<br>")
 
 email.subject = "Beacon Tapped"
 email.from = kAppDelegate.currentUserEmail
 //NSLog(@"NAME: %@  EMAIL: %@",kAppDelegate.currentUserName,kAppDelegate.currentUserEmail);
 email.to = sendTo
 email.html = body
 sendgrid.send(withWeb: email)
 */


// MARK: - TABLECELL ACTIONS
//SEND TEXT MADISON22
//    func showSMS() {
/*
 if !MFMessageComposeViewController.canSendText() {
 let warningAlert = UIAlertView(title: "Error", message: "Your device doesn't support SMS!", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "")
 warningAlert.show()
 return
 }
 
 //NSLog(@"index path : %ld", row);
 let object = listingsArray[row] as? TagModel
 
 
 var currentOwnerEmail = object?["ownerEmail"] as? String
 if currentOwnerEmail == nil {
 currentOwnerEmail = ""
 }
 
 var useTitle = object?["tagTitle"] as? String
 var useAddress = object?["tagAddress"] as? String
 var useSubTitle = object?["tagSubTitle"] as? String
 var useCompany = object?["tagCompany"] as? String
 var currentPropertyAddress = object?["tagAddress"] as? String
 
 if currentPropertyAddress == nil {
 currentPropertyAddress = ""
 }
 if useTitle == nil {
 useTitle = ""
 }
 if useSubTitle == nil {
 useSubTitle = ""
 }
 if useCompany == nil {
 useCompany = ""
 }
 if useAddress == nil {
 useAddress = ""
 }
 
 let message = "\(useTitle ?? "") \(useSubTitle ?? "") \(useCompany ?? "")"
 //NSLog(@"MESSAGE: %@",message);
 
 let recipents = [currentOwnerEmail]
 //NSString *message = currentPropertyAddress;
 
 
 let messageController = MFMessageComposeViewController()
 messageController.messageComposeDelegate = self
 messageController.recipients = recipents
 messageController.body = message
 
 // Present message view controller on screen
 present(messageController, animated: true)
 */

/*
 func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
 switch result {
 case .cancelled:
 break
 case .failed:
 let warningAlert = UIAlertView(title: "Error", message: "Failed to send SMS!", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "")
 warningAlert.show()
 case .sent:
 break
 default:
 break
 }
 dismiss(animated: true)
 }
 */

//    func getImage(_ url:String,handler: @escaping (UIImage?)->Void) {
//        print(url)
//
//        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(),
//                                        isDirectory: true)
//        let temporaryFileURL =
//            temporaryDirectoryURL.appendingPathComponent("mailpic.jpg")
//
//        print(temporaryFileURL)
//        Alamofire.request(url, method: .get).responseImage { response in
//            if let data = response.result.value {
//                handler(data)
//            } else {
//                handler(nil)
//            }
//        }
//    }


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


//func getTemporaryFileURL() -> URL {
//    let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(),
//                                    isDirectory: true)
//    let temporaryFileURL =
//        temporaryDirectoryURL.appendingPathComponent("mailpic.jpg")
//
//    print(temporaryFileURL)
//    return temporaryFileURL
//}

/*
 func alex2  () {
 let tempFileURL = getTemporaryFileURL()
 do {
 let fileURL: URL = tempFileURL
 try FileManager.default.removeItem(at: fileURL)
 }
 catch let error as NSError {
 print("Ooops! Something went wrong: \(error)")
 }
 var usePhotoLink = String(format: "%@%@-%@-%ld.jpg", SERVERFILENAME, "Tag", tag.tagPhotoRef, 1)
 if let url = URL(string: usePhotoLink) {
 URLSession.shared.downloadTask(with: url) { location, response, error in
 guard let location = location else {
 print("download error:", error ?? "")
 return
 }
 // move the downloaded file from the temporary location url to your app documents directory
 do {
 try FileManager.default.moveItem(at: location, to: tempFileURL)
 print("DONE!")
 } catch {
 print(error)
 }
 }.resume()
 }
 }
 */


