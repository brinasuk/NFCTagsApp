//
//  DetailViewController.swift
//
//  Created by Alex Levy on 5/26/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MessageUI
import SafariServices
import Parse

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
    var tag = TagModel()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: DetailHeaderView!

    var ratingKeep = ""
    
    override func viewDidLoad() {
    super.viewDidLoad()

        headerView.ratingImageView.isUserInteractionEnabled = true
        headerView.ratingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))

    
    //        headerView.headerImageView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];

    navigationItem.largeTitleDisplayMode = .never
    
    // Set the table view's delegate and data source
    tableView.delegate = self
    tableView.dataSource = self
    
    // Configure the table view's style
    tableView.separatorStyle = .singleLine
    tableView.contentInsetAdjustmentBehavior = .never
        
        ratingKeep = tag.rating

    

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

        
        
        // DISPLAY DATABASE VALUES
        headerView.titleLabel.text = tag.tagTitle
        headerView.subTitleLabel.text = tag.tagSubTitle
        headerView.priceLabel.text = tag.tagPrice
        headerView.ratingImageView.image = UIImage(named: tag.rating)

        
        // SHOW PHOTO
//        let tagPhotoRef = tag.tagPhotoRef
//        let cloudinaryAction = "Tag"
//        let usePhotoRef:String? = tagPhotoRef
//        let photoNumber = 1
//        let propertyPhotoFileUrl:String? = UIViewController.createNewPhotoURL(cloudinaryAction, withID: usePhotoRef, withNumber: photoNumber) ?? ""
        
        let propertyPhotoFileUrl:String? = String(format: "%@%@-%@-%ld.jpg", SERVERFILENAME, "Tag", tag.tagPhotoRef, 1)
        
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
    

//    @IBAction func imageTapped(sender: AnyObject) {
//        print("Image Tapped.")
//    }
    
    @objc private func imageTapped(_ recognizer: UITapGestureRecognizer) {
        print("image tapped")
        performSegue(withIdentifier: "ShowReview", sender: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
        /*
         TITLE
         SUBTITLE
         PRICE
         */
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
            cell.iconImageView.image = UIImage(named: "company")
            cell.shortTextLabel.text = tag.tagCompany
            cell.selectionStyle = .none
            return cell
            
        case 1: //CONTACT
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(named: "contact")
            cell.shortTextLabel.text = tag.ownerName
            cell.selectionStyle = .none
            return cell
            
        case 2: //PHONE
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(named: "phone")
            cell.shortTextLabel.text = tag.ownerPhone
            cell.selectionStyle = .none
            return cell
            
        case 3: //EMAIL
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(named: "email")
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
            cell.iconImageView.image = UIImage(named: "map")
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
            cell.configure(location: addr)  //NOTE: THIS IS DEFINED IN THE CELL
            cell.selectionStyle = .none
            
            return cell

            
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowMap" {
//            let destinationController = segue.destination as! MapViewController
//            destinationController.tag = tag
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print(segue.identifier!)
        if segue.identifier == "ShowMap" {
            let destinationController = segue.destination as! MapViewController
            //print(tag.tagAddrFull)
            destinationController.tag = tag
            
        } else if segue.identifier == "ShowReview" {
            let destinationController = segue.destination as! ReviewViewController
            destinationController.tag = tag
        }
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
    
    
    
    /*
     //https://www.hackingwithswift.com/example-code/uikit/how-to-send-an-email
     Make sure you add import MessageUI to any Swift file that uses this code, and you’ll also need to conform to the MFMailComposeViewControllerDelegate protocol.
     
     Note that not all users have their device configure to send emails, which is why we need to check the result of canSendMail() before trying to send. Note also that you need to catch the didFinishWith callback in order to dismiss the mail window.
     
     Warning: this code frequently fails in the iOS Simulator. If you want to test it, try on a real device.
     */
    
    @IBAction func contactUsButtonPressed(_ sender: UIBarButtonItem) {
        print("CONTACTUSPRESSED")
        var applicationName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([tag.ownerEmail])
            let subject = tag.tagTitle
            mail.setSubject(subject)
            var message = "I found this on the " + applicationName + " website. Please send me more information.<br><br>"
            message = message + "\(tag.tagTitle ) <br> \(tag.tagSubTitle )<br>\(tag.tagCompany)"
            mail.setMessageBody(message, isHTML: true)
            //NSLog(@"MESSAGE: %@",message);
            
            present(mail, animated: true, completion: nil)
            //present(mail, animated: true)
        } else {
            // show failure alert
            displayMessage(message: "Cannot send Email")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func websiteButtonPressed(_ sender: UIBarButtonItem) {
        print("WEBSITEBUTTONPRESSED")
        let urlString = tag.tagUrl
        if let url = URL(string: urlString ) {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }

    


    


    
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
        sendTo = "alex@hillsoft.com" //TODO: ALEX TEMP FIX FOR TESTING. REMOVE FROM FINAL RELEASE !
        
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
         NSString *usePhotoLink = @"";
         
         //TODO: ADD SUPPORT FOR PHOTO
         if ([_photoId length]==0) {
         usePhotoLink = @"https://photos.homecards.com/rebeacons/property_placeholder.jpg";
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

}
