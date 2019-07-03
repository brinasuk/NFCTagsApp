//  Converted to Swift 5 by Swiftify v5.0.23396 - https://objectivec2swift.com/
//
//  MaintTableViewController.h
//  Tap2View
//
//  Created by Alex Levy on 12/18/17.
//  Copyright © 2017 Hillside Software. All rights reserved.
//

import Parse
import UIKit
import Kingfisher

let kAppDelegate = UIApplication.shared.delegate as! AppDelegate

private var ownerObjects:[OwnerModel] = []
private var CellIdentifier = "MaintTableViewCell"
private var placeholderImage:UIImage?

class MaintTableView: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Info"
        setupNavigationBar()
        //imageView.kf.indicatorType = .activity
        
        // Customize the TABLEVIEW
        // NOT NECESSARY AFTER iOS 11  tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 92.0 // Use 92.0
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        //        moveDirtyFlag = false
        //        buttonLabel = "Edit"
        //        editing = false
        //        showNavigationButtons()
        //
        //        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didChangePreferredContentSize(_:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        //SET UI CONFIG COLORS
        let backgroundImageName = "art_launch_image"
        let backgroundImage = UIImage(named: backgroundImageName)
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.8
        self.tableView.backgroundView = imageView
        self.tableView.backgroundColor = coralColor
        view.backgroundColor = paleRoseColor
        
        let placeholderImageName = kAppDelegate.placeholderName
        placeholderImage = UIImage(named: placeholderImageName! as String)!
        
        //FORCE A RELOAD OF THE DATA
        kAppDelegate.isDatabaseDirty = true
        
        loadObjects()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }

//    @objc func goBackButtonPressed() {
//        navigationController?.popViewController(animated: true)
//        //[self dismissViewControllerAnimated:YES completion:nil];
//    }
    
    func createPhotoURL(_ useAction: String?, withID useID: String?, withNumber useNumber: Int) -> String? {
        if useID == nil {
            return nil
        }
        var url = ""
        url = String(format: "%@%@-%@-%ld.jpg", SERVERFILENAME, useAction ?? "", useID ?? "", useNumber)
        //NSLog(@"URL: %@",url);
        return url
    }
    
    func loadObjects()
    {
        let query = PFQuery(className: "TagOwnerInfo")
        query.whereKey("ownerEmail", equalTo: kAppDelegate.currentUserEmail!)
        query.whereKey("appName", equalTo: kAppDelegate.appCode!)
                query.order(byDescending: "ownerNumber")
        
        query.limit = 500
        ownerObjects = []  //or removeAll
        var rowCount = 0
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            if let error = error {
                UIViewController.removeSpinner(spinner: sv)
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                // The find succeeded.
                print("Successfully retrieved \(objects.count) OWNER objects.")
                // Do something with the found objects
                
                for object in objects {

                    let createdAt:Date = object.createdAt!
                    let ownerObjectId:String = object.objectId!
                    
                    var appName:String? = kAppDelegate.appName as String?
                    if appName == nil {appName = ""}
                    var ownerName:String? = object["ownerName"] as? String
                    if ownerName == nil {ownerName = ""}
                    var ownerEmail:String? = object["ownerEmail"] as? String
                    if ownerEmail == nil {ownerEmail = ""}
                    
                    let alex = object["ownerPhone"] as? String ?? ""
                    var ownerPhone:String? = object["ownerPhone"] as? String
                    print(alex)
                    print(ownerPhone)
                    if ownerPhone == nil {ownerPhone = ""}
                    
                    var ownerInfo:String? = object["ownerInfo"] as? String
                    if ownerInfo == nil {ownerInfo = ""}
                    
                    var latitude:String? = object["latitude"] as? String
                    if latitude == nil {latitude = ""}
                    var longitude:String? = object["longitude"] as? String
                    if longitude == nil {longitude = ""}
                    var triggerDistance:String? = object["triggerDistance"] as? String
                    if triggerDistance == nil {triggerDistance = ""}
                    var identifier:String? = object["identifier"] as? String
                    if identifier == nil {identifier = ""}
                    var beaconName:String? = object["beaconName"] as? String
                    if beaconName == nil {beaconName = ""}
                    var beaconColor:String? = object["beaconColor"] as? String
                    if beaconColor == nil {beaconColor = ""}
                    var beaconDymo:String? = object["beaconDymo"] as? String
                    if beaconDymo == nil {beaconDymo = ""}
                    
                    var ownerNumber:String? = object["ownerNumber"] as? String
                    if ownerNumber == nil {ownerNumber = ""}
                    var ownerId:String? = object["ownerId"] as? String
                    if ownerId == nil {ownerId = ""}
                    var ownerTitle:String? = object["ownerTitle"] as? String
                    var ownerSubTitle:String? = object["ownerSubTitle"] as? String
                    var ownerCompany:String? = object["ownerCompany"] as? String
                    var ownerUrl:String? = object["ownerUrl"] as? String
                    var ownerAddress:String? = object["ownerAddress"] as? String
                    var ownerAddress2:String? = object["ownerAddress2"] as? String
                    var ownerCity:String? = object["ownerCity"] as? String
                    var ownerState:String? = object["ownerState"] as? String
                    var ownerZip:String? = object["ownerZip"] as? String
                    var ownerCountry:String? = object["ownerCountry"] as? String
                    var ownerPhotoRef:String? = object["ownerPhotoRef"] as? String


                    if ownerNumber == nil {ownerNumber = ""}
                    if ownerTitle == nil {ownerTitle = ""}
                    if ownerSubTitle == nil {ownerSubTitle = ""}
                    if ownerCompany == nil {ownerCompany = ""}
                    if ownerUrl == nil {ownerUrl = ""}
                    if ownerAddress == nil {ownerAddress = ""}
                    if ownerAddress2 == nil {ownerAddress2 = ""}
                    if ownerCity == nil {ownerCity = ""}
                    if ownerState == nil {ownerState = ""}
                    if ownerZip == nil {ownerZip = ""}
                    if ownerCountry == nil {ownerCountry = ""}
                    if ownerPhotoRef == nil {ownerPhotoRef = ""}
                    
                    var ownerAddrFull:String? = object["ownerAddrFull"] as? String
                    if ownerAddrFull == nil {ownerAddrFull = ""}
                    var ownerPrice:String? = object["ownerPrice"] as? String
                    if ownerPrice == nil {ownerPrice = ""}
                    var ownerBeds:String? = object["ownerBeds"] as? String
                    if ownerBeds == nil {ownerBeds = ""}
                    var ownerBaths:String? = object["ownerBaths"] as? String
                    if ownerBaths == nil {ownerBaths = ""}
                    var ownerSqFt:String? = object["ownerSqFt"] as? String
                    if ownerSqFt == nil {ownerSqFt = ""}
                    
                    let newObject = OwnerModel(createdAt: createdAt, ownerObjectId: ownerObjectId,  appName: appName!, ownerName: ownerName!, ownerEmail: ownerEmail!, ownerPhone: ownerPhone!, ownerNumber: ownerNumber!, ownerId: ownerId!, latitude: latitude!, longitude: longitude!, triggerDistance: triggerDistance!, identifier: identifier!, beaconName: beaconName!, beaconColor: beaconColor!, beaconDymo: beaconDymo!, ownerTitle: ownerTitle!, ownerUrl: ownerUrl!, ownerInfo: ownerInfo!,ownerAddress: ownerAddress!, ownerSubTitle: ownerSubTitle!, ownerCompany: ownerCompany!, ownerAddress2: ownerAddress2!, ownerCity: ownerCity!, ownerState: ownerState!, ownerZip: ownerZip!, ownerCountry: ownerCountry!, ownerAddrFull: ownerAddrFull!, ownerPrice: ownerPrice!, ownerBeds: ownerBeds!, ownerBaths: ownerBaths!, ownerSqFt: ownerSqFt!, ownerPhotoRef: ownerPhotoRef!)
                    
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
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let count = self.dataParse.count
        let count = ownerObjects.count
        return count;
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaintTableViewCell", for: indexPath) as! MaintTableViewCell
        
        let owner = ownerObjects[indexPath.row] //The Vige
        
        //let shortAddress = "\(ownerAddress ?? "") \(ownerAddress2 ?? "") \(ownerCity ?? "")"

        cell.tagNumber.text = owner.ownerNumber
        cell.tagTitle.text = owner.ownerTitle
        cell.tagUrl.text = owner.ownerSubTitle
        cell.tagAddress.text = owner.ownerPhotoRef

        //==== IMAGE CODE ============================================================
        //let tagPhotoRef = owner.ownerPhotoRef
        
        let cloudinaryAction = "Tag"
        let usePhotoRef:String? = owner.ownerObjectId
        let photoNumber = 1
        let propertyPhotoFileUrl:String? = createPhotoURL(cloudinaryAction, withID: usePhotoRef, withNumber: photoNumber) ?? ""
        
        cell.tagImageView.layer.cornerRadius = cell.tagImageView.frame.size.width / 4
        cell.tagImageView.layer.masksToBounds = true
        cell.tagImageView.clipsToBounds = true
        
        cell.tagImageView.kf.indicatorType = .activity
        
        // METHOD 1: ======================================
        //        cell.tagImageView?.image = placeholderImage
        //        if let url = URL(string: propertyPhotoFileUrl! ) {
        //            cell.tagImageView.image = resizedImage(at: url, for: CGSize(width: 88,height: 88))
        //        }
        
        
        // METHOD 2: ======================================
        if let url = URL(string: propertyPhotoFileUrl! ) {
//            cell.tagImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
            // Round corner
            let processor = RoundCornerImageProcessor(cornerRadius: 20)
            
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
            
            //cell.tagImageView.kf.setImage(with: url)
            cell.tagImageView.kf.setImage(with: url, options: [.processor(processor)])
        }
        
        //=================================================
        
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.accessoryView = UIImageView(image: UIImage(named: "DisclosureIndicator"))


        cell.tagImageView.contentMode = .scaleAspectFit //APRIL 2018 WAS FILL

        cell.accessoryType = .detailDisclosureButton

        return cell
    }
    


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //TODO: NEVER USE THE FOLLOWING LINE. IT DESTROYS PASSING ANYTHING IN THE SEGUE!!!
        //tableView.deselectRow(at: indexPath, animated: true)

        //let object = objects[indexPath.row] as? PFObject
        //NSLog(@"Object: %@",object);

        //OwnerModel *ownerObject = [self.objects objectAtIndex:indexPath.row];
        //_usePhotoId = object.objectId;


/*
        useObjectId = object?.objectId ?? ""
        usePhotoRef = object?["ownerPhotoRef"] as? String
        useUrl = object?["ownerUrl"] as? String ?? ""
        useTitle = object?["ownerTitle"] as? String ?? ""
        useSubTitle = object?["ownerSubTitle"] as? String ?? ""
        useCompany = object?["ownerCompany"] as? String ?? ""
        useAddress = object?["ownerAddress"] as? String ?? ""
        useInfo = object?["ownerInfo"] as? String ?? ""
        useLatitude = object?["latitude"] as? String ?? ""
        useLongitude = object?["longitude"] as? String ?? ""

        useAddress2 = object?["ownerAddress2"] ?? ""
        useCity = object?["ownerCity"] ?? ""
        useState = object?["ownerState"] ?? ""
        useZip = object?["ownerZip"] ?? ""
        useCountry = object?["ownerCountry"] ?? ""

        if usePhotoRef == nil {
            usePhotoRef = ""
        }
        if useUrl == nil {
            useUrl = ""
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
        if useInfo == nil {
            useInfo = ""
        }
        if useLatitude == nil {
            useLatitude = ""
        }
        if useLongitude == nil {
            useLongitude = ""
        }

        if useAddress2 == nil {
            useAddress2 = ""
        }
        if useCity == nil {
            useCity = ""
        }
        if useState == nil {
            useState = ""
        }
        if useZip == nil {
            useZip = ""
        }
        if useCountry == nil {
            useCountry = ""
        }

*/
        //_ownerModel = self.objects[indexPath.row];
        //NSLog(@"ANSWER0: %@",_ownerModel[@"ownerUrl"]);
        
        //let ownerTag = ownerObjects[indexPath.row]
        performSegue(withIdentifier: "MaintDetailView", sender: self)

    }

    // ** ACCESSORYBUTTONPRESSED **
//    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        //NSLog(@"ACCESSORYBUTTON TAPPED: %ld",(long)indexPath.row);
//
//        let object = objects[indexPath.row] as? PFObject
//        let ownerId = object?["ownerId"] as? String
//        useTitle = object?["ownerTitle"] as? String ?? ""
//
//        //    DQAlertView * alertView = [[DQAlertView alloc] initWithTitle:@"TAG ID" message:ownerId  cancelButtonTitle:@"Ok" otherButtonTitle:nil];
//        //    [alertView show];
//
//        showTagEntries(forOwner: ownerId)
//
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "MaintDetailView" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! NewTagController
                destinationController.owner = ownerObjects[indexPath.row]
            }
        }
    }

    
    /*
// MARK: === Show Beacon List ===
    func showTagEntries(forOwner ownerId: String?) {

        //INITIALIZE THE ARRAY. ALLOW MAX 15 DAYS
        visits = [AnyHashable](repeating: 0, count: 15)
        for x in 0..<15 {
            visits[x] = NSNumber(value: 0)
        }

        let today = Date()
        let gregorian = Calendar(identifier: .gregorian)
        let offsetComponents = DateComponents()
        offsetComponents.day = -14 // note that I'm setting it to -1
        let cutoffDate: Date? = gregorian?.date(byAdding: offsetComponents, to: today, options: [])
        if let cutoffDate = cutoffDate {
            print("END OF THE WORLD: \(cutoffDate)")
        }

        let query = PFQuery(className: "Tags")
        query.whereKey("tagId", equalTo: ownerId)
        query.whereKey("appName", equalTo: kAppDelegate.appCode)
        query.whereKey("createdAt", greaterThan: cutoffDate)
        query.order(byDescending: "createdAt")
        query.limit = 500

        ProgressHUD.show("Searching ...", interaction: false)

        query.findObjectsInBackground(withBlock: { objects, error in
            if error == nil {

                if objects?.count == 0 {
                    let alertView = DQAlertView(title: "Statistics", message: "No Entries Found", cancelButtonTitle: "Ok", otherButtonTitle: nil)
                    alertView.show()
                    ProgressHUD.dismiss()
                    return
                }

                self.statsArray = [AnyHashable](repeating: 0, count: objects?.count ?? 0)

                for object in objects as? [PFObject] ?? [] {

                    let statsItem = TagModel()

                    let createdAt: Date? = object.createdAt() //object[@"currentDate"]; DOES NOT WORK!
                    //NSDate *createdAt = object[@"createdAt"]; //DOES NOT WORK
                    let currentLocale = NSLocale.current as NSLocale
                    Date().description(with: currentLocale)
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "EEE, MMM d, h:mm a"
                    //[dateFormat setDateFormat:@"yyyy-MM-dd hh:mm a"];  //@"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM

                    //                NSString *localDate = [NSString stringWithFormat:@"Date Added: %@", [dateFormat stringFromDate:createdAt]];

                    var tagTitle = object["tagTitle"] as? String
                    var tagSubTitle = object["tagSubTitle"] as? String
                    var tagCompany = object["tagCompany"] as? String
                    var tagAddress = object["tagAddress"] as? String
                    var userName = object["userName"] as? String
                    var userEmail = object["userEmail"] as? String

                    if tagTitle == nil {
                        tagTitle = ""
                    }
                    if tagSubTitle == nil {
                        tagSubTitle = ""
                    }
                    if tagCompany == nil {
                        tagCompany = ""
                    }
                    if tagAddress == nil {
                        tagAddress = ""
                    }
                    if userName == nil {
                        userName = ""
                    }
                    if userEmail == nil {
                        userEmail = ""
                    }

                    statsItem.createdAt = createdAt
                    statsItem.tagTitle = tagTitle
                    statsItem.tagSubTitle = tagSubTitle
                    statsItem.tagCompany = tagCompany
                    statsItem.tagAddress = tagAddress
                    statsItem.userName = userName
                    statsItem.userEmail = userEmail

                    self.statsArray.append(statsItem)

                    // HOW MANY DAYS BACK IS THIS ENTRY? USED FOR CHART
                    let currentDate = Date()
                    let createdDate: Date? = object.createdAt()
                    //NOTE: THESE ARE BOTH UTC DATES. NO NEED TO CONVERT!!
                    var secondsBetween: TimeInterval? = nil
                    if let createdDate = createdDate {
                        secondsBetween = currentDate.timeIntervalSince(createdDate)
                    }
                    var numberOfDays = Int((secondsBetween ?? 0.0) / 86400) // 86400 is the number of seconds in a day (i.e. 60 seconds, times 60 minuts, times 24 hours
                    //NSLog(@"There are %d days in between the two dates.", numberOfDays);
                    // NOTE: TODAY is ZERO, Yesterday is 1 etc
                    if numberOfDays > 15 {
                        numberOfDays = 15 //Some defensive programming
                    }

                    let visit: Int = self.visits[numberOfDays].intValue + 1
                    self.visits[numberOfDays] = NSNumber(value: visit)
                }

                ProgressHUD.dismiss()
                //StatsModel *_statsModel  = [_statsArray objectAtIndex:row];
                self.performSegue(withIdentifier: "StatsView", sender: self)
            } else {
                // Log details of the failure
                //NSLog(@"Error: %@ %@", error, [error userInfo]);
                ProgressHUD.showError(((error as NSError?)?.userInfo)["error"])
            }
        })
    }
 
 */
    
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateRestaurant(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: {
            //            if let rating = segue.identifier {
            //                self.restaurant.rating = rating
            //                self.headerView.ratingImageView.image = UIImage(named: rating)
            //
            //                let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            //                self.headerView.ratingImageView.transform = scaleTransform
            //                self.headerView.ratingImageView.alpha = 0
            //
            //                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
            //                    self.headerView.ratingImageView.transform = .identity
            //                    self.headerView.ratingImageView.alpha = 1
            //                }, completion: nil)
            //            }
        })
    }
}