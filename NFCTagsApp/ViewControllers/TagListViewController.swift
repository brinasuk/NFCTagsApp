import UIKit
import CoreNFC
import VYNFCKit
import Parse
import Alamofire
import AlamofireImage
import SafariServices
import Alertift
import Kingfisher
import AVFoundation

enum ProfileType: String {
    case guest = "Guest"
    case host = "Host"
}

class TagListViewController:UIViewController,SFSafariViewControllerDelegate, NFCNDEFReaderSessionDelegate, UITableViewDelegate {
    
    var currentProfile = ProfileType.guest
    
    let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
    private var tagObjects:[TagModel] = []
    //private var dataParse:NSMutableArray = NSMutableArray()
    
    private var scanResults: String? = ""
    
    var currentRow:Int = 0
    var rowCount:Int = 0
    
    var deleteObjectId:String = ""    //USED BY DELETE
    
    var placeholderImage:UIImage?
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMaintenance: UIBarButtonItem!
    @IBOutlet weak var btnSignIn: UIBarButtonItem!
    
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    

    
//    @IBAction func didPressSwitchProfile(_ sender: Any) {
//        currentProfile = currentProfile == .guest ? .host : .guest
//        configureFor(profileType: currentProfile)
//    }
    
//    func configureFor(profileType: ProfileType) {
//        title = profileType.rawValue
//        ShortcutParser.shared.registerShortcuts(for: profileType)
//    }
    
    // MARK: - PROGRAM LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configureFor(profileType: currentProfile)

        
        let applicationName:String = (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String)!
        print("App Display Name - \(applicationName)")
        
        self.title = applicationName 
        
        // SEE IF YOU HAVE A USER ALREADY LOGGED IN
        
        
        //CRITICAL:  CLEAS CACHE!!
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        
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
        
        //SET THE SCANBUTTON DEFAULTS
        let myColor = royalBlue
        scanButton.backgroundColor = myColor
        scanButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        scanButton.layer.cornerRadius = scanButton.frame.height/2
        scanButton.layer.masksToBounds = true
        scanButton.tintColor = .white
        
        //MAKE THE STATUSLABEL CORNERS ROUNDED
        statusView.backgroundColor = paleRoseColor //or CORAL
        
        statusLabel.layer.cornerRadius = 5.0
        statusLabel.layer.masksToBounds = true
        statusLabel.backgroundColor = .white
        statusLabel.textColor = royalBlue
        statusLabel.font.withSize(16.0)
        
        //SET UI CONFIG COLORS
        let backgroundImageName = "art_launch_image"
        let backgroundImage = UIImage(named: backgroundImageName)
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.8
        self.tableView.backgroundView = imageView
        self.tableView.backgroundColor = coralColor
        toolBar.barTintColor = .white //pinkColor  //paleRoseColor//.white // coralColor
        view.backgroundColor = paleRoseColor
        
        
        // THIS IS CRITICAL HERE. IF USER NOT LOGGED IN THEN FORCE A LOGIN
        // FOR SOME REASON DOES NOT WORK IN FORM_WILLLOAD ????
        let currentUser = PFUser.current()
        if currentUser == nil {
            showLoginScreen()
        }
        
        //FORCE A RELOAD OF THE DATA
        kAppDelegate.isDatabaseDirty = true
    }
    
    func setupNavigationBar() {
        //HIDE EMPTY CELLS WHEM YOU HAVE TOO FEW TO FILL THE TABLE
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = paleRoseColor
        
        //Customize the navigation bar
        //The following 2 lines make the Navigation Bar transparant
        //       navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        navigationController?.navigationBar.shadowImage = UIImage()
        //        navigationController?.navigationBar.prefersLargeTitles = true
        //        navigationController?.hidesBarsOnSwipe = true
        //
        
        
        //METHOD 1
        //        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: .bold) ]
        //        navigationItem.largeTitleDisplayMode = .always
        
        //METHOD2
        if let customFont = UIFont(name: "Rubik-Medium", size: 34.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor .darkText, NSAttributedString.Key.font: customFont ]
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayMessage(message: kAppDelegate.deeplink ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        
        
        setupNavigationBar()
        
        
        // SEE IF YOU HAVE A USER ALREADY LOGGED IN
        let currentUser = PFUser.current()
        if currentUser == nil {
            showLoginScreen()
        } else {
            showCurrentUserInfo()   //UPDATE CURRENT USER INFO
        }
        
        if (kAppDelegate.isDatabaseDirty == true) {
            //GET INFO FOR NEW USER IF NEW LOGIN or DATA CHANGED!!
            //TODO: THIS STATEMENT IS CRITICAL. RELOAD THE PHOTO/DATA AFTER MAINT CHANGES.
            loadTagTable() //GET INFO FOR NEW USER
            kAppDelegate.isDatabaseDirty = false
        }
        
        
    }
    
    // MARK: - ACTION BUTTONS PRESSED
    @IBAction func scanButtonPressed(_ sender: Any) {
        scanResults = ""
        let session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
        session.alertMessage = "Hold your iPhone near the tag to learn more about this item."
        session.begin()
        bounce(scanButton)
    }
    
    @IBAction func signinButtonPressed(_ sender: Any) {
        
        let currentUser = PFUser.current()
        if currentUser != nil {
            Alertift.alert(title: kAppDelegate.currentUserName!,message: "Are you sure you wish to Sign Out?")
                .action(.default("Yes"), isPreferred: true) { (_, _, _) in
                    print("YES!")
                    self.actionLogout()
                }
                .action(.cancel("No")) { (_, _, _) in
                    print("No/Cancel Clicked");
                }
                .show()
            
        } else {
            showLoginScreen()
        }
    }
    
    @IBAction private func btnMaintenancePressed(_ sender: Any) {
        // BUTTON IS HIDDEN FROM EVERYDAY JOE USERS
        //TODO: PUT BACK  performSegue(withIdentifier: "MaintTableView", sender: self)
    }
    
    @IBAction private func btnAugRealityPressed(_ sender: Any) {
        // CHECK FOR ARKit AVAILABILITY
        // THE FOLLOWING DOES NOT WORK! CODE MOVED TO THE BUTTON PRESS IN XCODE
        
        //    if (ARWorldTrackingConfiguration.isSupported) {
        //
        //        let alertController = UIAlertController(title: "Hardware not supported", message: "This app requires support for 'World Tracking' that is only available on iOS devices with an A9 processor or newer. " +
        //                                                "Please quit the application.", preferredStyle: UIAlertController.Style.alert)
        //        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        //        present(alertController, animated: true, completion: nil)
        //    }
        
        //        let navigationController = storyboard.instantiateViewController(withIdentifier: "AugView") as? UINavigationController
        //
        //        if let navigationController = navigationController {
        //            present(navigationController, animated: true)
        
    }
    
    @IBAction func tryButtonPressed(_ sender: Any) {
        /*
         
         //        Alertift.alert(title: "Sample 1", message: "Simple alert!")
         //            //.image (UIImage(named: "warning"))
         //            .action(.default("OK"))
         //            .show()
         
         //        let alertImage: UIImage = UIImage(named: "warning")!
         //            Alertift.alert(title: "Alert with image", message: "You can add image simpley. call `alertift.image()`")
         //                .image(alertImage)
         //                .action(.default("OK"))
         //                .show()
         
         let alertImage: UIImage = UIImage(named: "warning2")!
         Alertift.alert(title: "Alertift", message: "Alertift is swifty, modern, and awesome UIAlertController wrapper.")
         .image(alertImage)
         .titleTextColor(.red)
         .messageTextColor(.blue)
         .action(.default("Hi Vige")) { (action, index, _) in
         print(action, index)
         print ("LOVE THE VIGE")
         }
         
         //            .action(.default("⭐")) { (action, index, _) in
         //                print(action, index)
         //            }
         
         //            .finally { [weak self] (action, index, _) in
         //                print(action, index)
         //                //self?.showAlertWithActionImage()
         //            }
         .show(on: self)
         */
        
        
        /*
         Alertift.alert(title: "Sample 2",message: "Do you like 🍣?")
         .action(.default("Yes"), isPreferred: true) { (_, _, _) in
         Alertift.alert(message: "🍣🍣🍣")
         .action(.default("Close"))
         .show()
         }
         .action(.cancel("No")) { (_, _, _) in
         Alertift.alert(message: "😂😂😂")
         .action(.destructive("Close"))
         .show()
         }
         .show()
         */
    }
    
    
    
    
    // MARK: - NFC READER DELEGATES
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        //THIS ERROR ALWAYS COMES UP, EVEN ON A SUCCESSFUL SCAN. ????
        //DO NOT SHOW THIS MESSAGE TO THE USER EVER
        if error.localizedDescription == "Feature not supported" {
            displayMessage(message: "NFC Tag scan not supported")
        }
        print(error.localizedDescription)
        
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            
            // THE FOLLOWING 3 LINES ADDED BY ALEX
            var response:String = ""  //MESSAGE WITH RETURNED PAYLOAD
            var textPayload:String = ""  //THIS IS THE TEXT WE ARE LOOKING FOR!! BINGO!!
            var urlString:String = "" //EXTRACT A URL IF POSSIBLE
            
            //VIBRATE
            AudioServicesPlayAlertSound(SystemSoundID(4095))   //1303 MAIL SENT  //VIBRATE 4095
            
            
            //NSLog(@"IDENTIFIER: %@", message.ide)
            
            //        for message in messages {
            //            for record in message.records {
            //                print(record.identifier)
            //                print(record.payload)
            //                print(record.type)
            //                print(record.typeNameFormat)
            //            }
            //        }
            
            for payload in message.records {
                guard let parsedPayload = VYNFCNDEFPayloadParser.parse(payload) else {
                    continue
                }
                
                if let parsedPayload = parsedPayload as? VYNFCNDEFTextPayload {
                    response = "[Text payload]\n"
                    response = String(format: "%@%@", response, parsedPayload.text)
                    textPayload = parsedPayload.text
                } else if let parsedPayload = parsedPayload as? VYNFCNDEFURIPayload {
                    response = "[URI payload]\n"
                    response = String(format: "%@%@", response, parsedPayload.uriString)
                    // urlString ADDED BY ALEX !!!!!
                    urlString = parsedPayload.uriString
                } else if let parsedPayload = parsedPayload as? VYNFCNDEFTextXVCardPayload {
                    response = "[TextXVCard payload]\n"
                    response = String(format: "%@%@", response, parsedPayload.text)
                } else if let sp = parsedPayload as? VYNFCNDEFSmartPosterPayload {
                    response = "[SmartPoster payload]\n"
                    for textPayload in sp.payloadTexts {
                        if let textPayload = textPayload as? VYNFCNDEFTextPayload {
                            response = String(format: "%@%@\n", response, textPayload.text)
                        }
                    }
                    response = String(format: "%@%@", response, sp.payloadURI.uriString)
                    // urlString ADDED BY ALEX !!!!!
                    urlString = sp.payloadURI.uriString
                } else if let wifi = parsedPayload as? VYNFCNDEFWifiSimpleConfigPayload {
                    for case let credential as VYNFCNDEFWifiSimpleConfigCredential in wifi.credentials {
                        response = String(format: "%@SSID: %@\nPassword: %@\nMac Address: %@\nAuth Type: %@\nEncrypt Type: %@",
                                          response, credential.ssid, credential.networkKey, credential.macAddress,
                                          VYNFCNDEFWifiSimpleConfigCredential.authTypeString(credential.authType),
                                          VYNFCNDEFWifiSimpleConfigCredential.encryptTypeString(credential.encryptType)
                        )
                    }
                    if let version2 = wifi.version2 {
                        response = String(format: "%@\nVersion2: %@", response, version2.version)
                    }
                } else {
                    response = "Parsed but unhandled payload type"
                }
                
                NSLog("%@", response)
                
                //============================================
                DispatchQueue.main.async(execute: {
                    // IF THERE IS A TEXT PAYLOAD THEN PARSE AND SHOW IT !!!!!
                    if textPayload.count > 0 {  // ans ADDED BY ALEX
                        // Close NFC reader session and open URI after delay. Not all can be opened on iOS.
                        session.invalidate()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                            
                            // AFTER SUCCESSFULLY SCANNING THE TAG, LOOKUP THE INFO THE OWNER HAS SAVED FOR IT
                            
                            //TODO: HUGE FIX HERE
                            self.lookupTagIfo(textPayload)
                        })
                    }
                    
                    // IF THERE IS A VALID URL HERE THEN SHOW IT
                    if urlString.count > 0 {
                        // Close NFC reader session and open URI after delay. Not all can be opened on iOS.
                        session.invalidate()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                            // The following replaces showwebview
                            if let url = URL(string: urlString ) {
                                let safariVC = SFSafariViewController(url: url)
                                self.present(safariVC, animated: true, completion: nil)
                            }
                            
                        })
                    }
                })
            }
        }
    }
    
    //func showWebPagez(_ urlString: String?) {
    //    // Close NFC reader session and open URI after delay. Not all can be opened on iOS.
    //    //session.invalidate()
    //
    //    if let url = URL(string: urlString ?? "") {
    //        let safariVC = SFSafariViewController(url: url)
    //        present(safariVC, animated: true, completion: nil)
    //    }
    //}
    
    // MARK: - PARSE QUERIES
    
    // AFTER SUCCESSFULLY SCANNING A TAG, LOOKUP THE MATCHING OWNER INFO
    func lookupTagIfo(_ passTagId: String?) {
        //tagId = "info@kcontemporaryart.com:102" //TODO: REMOVE
        print("PASSED TAGID: \(passTagId ?? "")")
        let useTagId:String? = passTagId
        
        //        //UPDATED JULY2019. ADDED OPTION TO SPECIFY APPCODE in TAG AFTER PIPE DELIMETER
        //        let tagString = passTagId ?? ""
        //        let arr = tagString.split(separator: "|")
        //        let useTagId:String = String(arr[0])
        //        let arrCount = arr.count
        //        if arrCount > 0 {  //THE APPCODE IS IN THE TAG. USE IT!
        //            kAppDelegate.appCode = arr[1] as NSString
        //        }
        //        print("USE TAGID: \(useTagId)")
        //        print("APPCODE: \(String(describing: kAppDelegate.appCode))")
        
        
        
        ///let str = "Andrew, Ben, John, Paul, Peter, Laura"
        ///let array = str.components(separatedBy: ", ")
        
        //        let sayHello = "Hello Swift 4 2017";
        //        let result = sayHello.split(separator: " ")
        //        print(result) result.count
        
        
        //AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        //or: AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        //AudioServicesPlaySystemSound(1103) // SMSReceived (see SystemSoundID below)
        
        //beaconAlert?.dismiss()
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        let query = PFQuery(className: "TagOwnerInfo")
        query.whereKey("ownerId", equalTo: useTagId!)
        query.getFirstObjectInBackground {(object: PFObject?, error: Error?) in
            if let error = error {
                // NO MATCH FOUND
                UIViewController.removeSpinner(spinner: sv)
                print(error.localizedDescription)
                self.displayErrorMessage(message: error.localizedDescription)
            } else if let object = object {
                // The query succeeded with a matching result
                //print("HERE WE ARE!!")
                //print(object)
                let ownerObjectId = object.objectId
                let ownerEmail = object["ownerEmail"] as? String ?? ""
                let ownerName = object["ownerName"] as? String ?? ""
                let ownerPhone = object["ownerPhone"] as? String ?? ""
                let ownerAppCode = object["ownerAppCode"] as? String ?? ""
                
                ///let ownerPhotoRef = object["ownerPhotoRef"] as? String ?? ""
                
                let ownerId = object["ownerId"] as? String ?? ""
                let ownerUrl = object["ownerUrl"] as? String ?? ""
                let ownerTitle = object["ownerTitle"] as? String ?? ""
                let ownerSubTitle = object["ownerSubTitle"] as? String ?? ""
                let ownerCompany = object["ownerCompany"] as? String ?? ""
                
                
                let ownerInfo = object["ownerInfo"] as? String ?? ""
                let ownerAddress = object["ownerAddress"] as? String ?? ""
                let ownerAddress2 = object["ownerAddress2"] as? String ?? ""
                let ownerCity = object["ownerCity"] as? String ?? ""
                let ownerState = object["ownerState"] as? String ?? ""
                let ownerZip = object["ownerZip"] as? String ?? ""
                let ownerCountry = object["ownerCountry"] as? String ?? ""
                
                let ownerAddrFull = object["ownerAddrFull"] as? String ?? ""
                let ownerPrice = object["ownerPrice"] as? String ?? ""
                let ownerBeds = object["ownerBeds"] as? String ?? ""
                let ownerBaths = object["ownerBaths"] as? String ?? ""
                let ownerSqFt = object["ownerSqFt"] as? String ?? ""
                
                let beaconDymo = object["beaconDymo"] as? String ?? ""
                let beaconColor = object["beaconColor"] as? String ?? ""
                
                let latitude = object["latitude"] as? String ?? "0.0"
                let longitude = object["longitude"] as? String ?? "0.0"
                
                let triggerDistance = object["triggerDistance"] as? Double ?? 0.5
                
                //IF THIS IS NOT A VALID URL THEN BAIL OUT!!!
                guard let url = URL.init(string: ownerUrl)
                    else { return }
                
                
                // ADD TO TAGS TABLE
                let tag = PFObject(className:"Tags")
                
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
                tag["tagBeds"] = ownerBeds
                tag["tagBaths"] = ownerBaths
                tag["tagSqFt"] = ownerSqFt
                
                tag["beaconDymo"] = beaconDymo
                tag["beaconColor"] = beaconColor
                tag["latitude"] = latitude
                tag["longitude"] = longitude
                
                let latitudeD = Double(latitude)
                let longitudeD = Double(longitude)
                
                let point = PFGeoPoint(latitude: latitudeD!, longitude: longitudeD!)
                tag["location"] = point
                
                tag["triggerDistance"] = triggerDistance
                
                tag.saveInBackground {
                    (success: Bool, error: Error?) in
                    if (success) {
                        // The object has been saved.
                        //self.displayMessage(message: "SUCCESS")
                        UIViewController.removeSpinner(spinner: sv)
                        print ("SAVED TAG WITH URL: \(ownerUrl)")
                        self.loadTagTable()  //DISPLAY NEW DATA
                        if let url = URL(string: ownerUrl ) {
                            let safariVC = SFSafariViewController(url: url)
                            self.present(safariVC, animated: true, completion: nil)
                        }
                        
                        // SEND THE FOLLOWING OWNER INFO TO SENDGRID
                        //TODO: PUT BACK?
                        //                            if kAppDelegate.sendEmailLead == true {
                        //                                self.sendGrid(myTitle, usingSubTitle: mySubTitle, usingCompany: myCompany, usingAddress: myAddress, usingOwnerEmail: myEmail)
                        //                            }
                    } else {
                        // There was a problem, check error.description
                        UIViewController.removeSpinner(spinner: sv)
                        self.displayMessage(message: "FAILED!")
                    }
                }
                print("Successfully added to TAGS table")
            }
        }
    }
    
    func loadTagTable()
    {
        let query = PFQuery(className:"Tags")
        
        let userEmail = kAppDelegate.currentUserEmail as String?
        ///let appCode = kAppDelegate.appCode as String?
        ///REMOVE APPCODE query.whereKey("appCode", equalTo: appCode!)
        query.whereKey("userEmail", equalTo: userEmail!)
        query.order(byDescending: "createdAt")
        
        //query.whereKey("tagTitle", equalTo: "Vige")
        query.limit = 500
        //dataParse = []
        tagObjects = []  //or removeAll
        var rowCount = 0
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            if let error = error {
                UIViewController.removeSpinner(spinner: sv)
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                // The find succeeded.
                print("Successfully retrieved \(objects.count) TAG objects.")
                // Do something with the found objects
                
                for object in objects {
                    
                    //self.dataParse.add(object)
                    
                    //                    let createdAt: Date? = object.createdAt()
                    //
                    //
                    //                    let cellDataParse:PFObject = self.dataParse.object(at: rowCount) as! PFObject
                    //                    //let objectTagX = object.objectId
                    //
                    //                    var ownerEmail = object["ownerEmail"] as? String
                    //                    if ownerEmail == nil {ownerEmail = ""}
                    //
                    //                    var tagTitle:String? = cellDataParse["tagTitle"] as? String
                    //                    // LONG VERSION: var tagTitle:String? = cellDataParse.object(forKey: "tagTitle") as? String
                    //                    if tagTitle == nil {tagTitle = ""}
                    //
                    //                    print(tagTitle as Any)
                    
                    let cellDataParse:PFObject = object
                    
                    let createdAt:Date = object.createdAt!
                    let tagObjectId:String = object.objectId!
                    
                    
                    var userName:String? = cellDataParse["userName"] as? String
                    if (userName == nil) {userName = ""}
                    var userEmail:String? = cellDataParse["userEmail"] as? String
                    if (userEmail == nil) {userEmail = ""}
                    var ownerName:String? = cellDataParse["ownerName"] as? String
                    if (ownerName == nil) {ownerName = ""}
                    var ownerEmail:String? = cellDataParse["ownerEmail"] as? String
                    if (ownerEmail == nil) {ownerEmail = ""}
                    
                    //TODO: SEE HOW IT IS DONE
                    //let alex = object["ownerPhone"] as? String ?? ""
                    //print(alex)
                    
                    var ownerPhone:String? = cellDataParse["ownerPhone"] as? String
                    //print(ownerPhone)
                    if (ownerPhone == nil) {ownerPhone = ""}
                    
                    var appCode:String? = cellDataParse["appCode"] as? String
                    if (appCode == nil) {appCode = ""}
                    var beaconDymo:String? = cellDataParse["beaconDymo"] as? String
                    if (beaconDymo == nil) {beaconDymo = ""}
                    var beaconColor:String? = cellDataParse["beaconColor"] as? String
                    if (beaconColor == nil) {beaconColor = ""}
                    
                    var tagPhotoRef:String? = cellDataParse["tagPhotoRef"] as? String
                    if (tagPhotoRef == nil) {tagPhotoRef = ""}
                    
                    var tagId:String? = cellDataParse["tagId"] as? String
                    if (tagId == nil) {tagId = ""}
                    var tagTitle:String? = cellDataParse["tagTitle"] as? String
                    if (tagTitle == nil) {tagTitle = ""}
                    
                    var tagUrl:String? = cellDataParse["tagUrl"] as? String
                    if (tagUrl == nil) {tagUrl = ""}
                    var tagInfo:String? = cellDataParse["tagInfo"] as? String
                    if (tagInfo == nil) {tagInfo = ""}
                    var tagAddress:String? = cellDataParse["tagAddress"] as? String
                    if (tagAddress == nil) {tagAddress = ""}
                    
                    var latitude:String? = cellDataParse["latitude"] as? String
                    if (latitude == nil) {latitude = ""}
                    var longitude:String? = cellDataParse["longitude"] as? String
                    if (longitude == nil) {longitude = ""}
                    
                    var tagSubTitle:String? = cellDataParse["tagSubTitle"] as? String
                    if (tagSubTitle == nil) {tagSubTitle = ""}
                    var tagCompany:String? = cellDataParse["tagCompany"] as? String
                    if (tagCompany == nil) {tagCompany = ""}
                    var tagAddress2:String? = cellDataParse["tagAddress2"] as? String
                    if (tagAddress2 == nil) {tagAddress2 = ""}
                    var tagCity:String? = cellDataParse["tagCity"] as? String
                    if (tagCity == nil) {tagCity = ""}
                    var tagState:String? = cellDataParse["tagState"] as? String   //Provence, County
                    if (tagState == nil) {tagState = ""}
                    var tagZip:String? = cellDataParse["tagZip"] as? String
                    if (tagZip == nil) {tagZip = ""}
                    var tagCountry:String? = cellDataParse["tagCountry"] as? String
                    if (tagCountry == nil) {tagCountry = ""}
                    
                    var tagAddrFull:String? = cellDataParse["tagAddrFull"] as? String
                    if (tagAddrFull == nil) {tagAddrFull = ""}
                    var tagPrice:String? = cellDataParse["tagPrice"] as? String
                    if (tagPrice == nil) {tagPrice = ""}
                    var tagBeds:String? = cellDataParse["tagBeds"] as? String
                    if (tagBeds == nil) {tagBeds = ""}
                    var tagBaths:String? = cellDataParse["tagBaths"] as? String
                    if (tagBaths == nil) {tagBaths = ""}
                    var tagSqFt:String? = cellDataParse["tagSqFt"] as? String
                    if (tagSqFt == nil) {tagSqFt = ""}
                    
                    var triggerDistance:String? = cellDataParse["triggerDistance"] as? String
                    if (triggerDistance == nil) {triggerDistance = ""}
                    var sequence:String? = cellDataParse["sequence"] as? String
                    if (sequence == nil) {sequence = ""}
                    
                    
                    //NEW: ADDED RATING
                    var rating:String? = cellDataParse["rating"] as? String
                    if (rating == nil) {rating = ""}
                    
                    let newObject = TagModel(createdAt: createdAt,tagObjectId: tagObjectId, userName: userName!, userEmail: userEmail!, ownerName: ownerName!, ownerEmail:ownerEmail!, ownerPhone:ownerPhone!, appCode: appCode!, beaconDymo: beaconDymo!, beaconColor: beaconColor!, tagPhotoRef: tagPhotoRef!, tagId: tagId!, tagTitle: tagTitle!, tagUrl: tagUrl!, tagInfo: tagInfo!, tagAddress: tagAddress!, latitude: latitude!, longitude: longitude!, tagSubTitle: tagSubTitle!, tagCompany: tagCompany!, tagAddress2: tagAddress2!, tagCity: tagCity!, tagState: tagState!, tagZip: tagZip!, tagCountry: tagCountry!,tagAddrFull: tagAddrFull!,tagPrice: tagPrice!,  tagBeds: tagBeds!,tagBaths: tagBaths!,tagSqFt: tagSqFt!, triggerDistance: triggerDistance!, sequence: sequence!, rating: rating!)
                    
                    self.tagObjects.append(newObject)
                    //self.dataParse.add(object)
                    rowCount = rowCount + 1
                    
                    // ============================================================
                    // TODO: THE FOLLOWING ARE ALL OPTIONAL AND CAN ALL BE NIL !!
                    // ============================================================
                    
                    // NB: Sequence is Numeric!!
                    //var sequence = cellDataParse.object(forKey: "sequence") as? Double
                    //print (sequence as Any)
                    
                }
            }
            
            
            
            //RUN ON MAIN THREAD
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if rowCount == 0 {
                    let welcome = "Welcome " + self.kAppDelegate.currentUserName!
                    let message = "Please tap the button below to \nScan nearby Tags for Information"
                    let alertView = UIAlertController(title: welcome, message: message, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                    }
                    alertView.addAction(OKAction)
                    if let presenter = alertView.popoverPresentationController {
                        presenter.sourceView = self.view
                        presenter.sourceRect = self.view.bounds
                    }
                    self.present(alertView, animated: true, completion:nil)
                }
            }
            //let sv = UIViewController.displaySpinner(onView: self.view)
            UIViewController.removeSpinner(spinner: sv)
            
        }
    }
}

// MARK: - Table view
// TODO: CODE TO REMOVE A ROW

extension TagListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let count = self.dataParse.count
        rowCount = self.tagObjects.count
        
        if (rowCount > 0) {
            statusLabel.text = "Tap or swipe left for more options"
        } else {
            statusLabel.text = "Welcome " + kAppDelegate.currentUserName!
        }
        
        //        if rowCount == 0 {
        //            let welcome = "Welcome " + self.kAppDelegate.currentUserName!
        //            let message = "Please tap the button below to \nScan nearby Tags for Information"
        //            let alertView = UIAlertController(title: welcome, message: message, preferredStyle: .alert)
        //            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        //            }
        //            alertView.addAction(OKAction)
        //            if let presenter = alertView.popoverPresentationController {
        //                presenter.sourceView = self.view
        //                presenter.sourceRect = self.view.bounds
        //            }
        //            self.present(alertView, animated: true, completion:nil)
        //        }
        
        
        
        return rowCount;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // if editingStyle == .delete {
        // CODE MOVED TO: trailingSwipeActionsConfigurationForRowAt
        // }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AuteurTableViewCell
        
        let tag = self.tagObjects[indexPath.row] //The Vige
        
        cell.tagTitle.text = tag.tagTitle
        cell.tagSubTitle.text = tag.tagSubTitle
        cell.tagCompany.text = tag.tagCompany
        
        //TODO: Implement currentLocale = NSLocale.current as NSLocale
        //let date = cellDataParse.object(forKey: "createdAt") as? Date ?? NSDate() as Date
        let date = tag.createdAt
        let format = DateFormatter()
        format.dateFormat = "EEE, MMM d, h:mm a"
        //@"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
        let formattedDate = format.string(from: date)
        cell.dateAdded.text = "Date Added: " + formattedDate
        
        /*
         https://photos.homecards.com/rebeacons/Tag-082C63FE-9AA8-4967-BC04-8F3D6AAF63DA-1.jpg
         */
        
        //        let tagPhotoRef = tag.tagPhotoRef
        //
        //        let cloudinaryAction = "Tag"
        //        let usePhotoRef:String? = tagPhotoRef
        //        let photoNumber = 1
        //        let propertyPhotoFileUrl:String? = UIViewController.createNewPhotoURL(cloudinaryAction, withID: usePhotoRef, withNumber: photoNumber) ?? ""
        
        let tagPhotoFileUrl:String? = String(format: "%@%@-%@-%ld.jpg", SERVERFILENAME, "Tag", tag.tagPhotoRef, 1)
        
        cell.tagImageView.layer.cornerRadius = cell.tagImageView.frame.size.width / 4
        cell.tagImageView.layer.masksToBounds = true
        cell.tagImageView.clipsToBounds = true
        
        // METHOD 1: ======================================
        //        cell.tagImageView?.image = placeholderImage
        //        if let url = URL(string: propertyPhotoFileUrl! ) {
        //            cell.tagImageView.image = resizedImage(at: url, for: CGSize(width: 88,height: 88))
        //        }
        
        
        // METHOD 2: ======================================
        //        if let url = URL(string: propertyPhotoFileUrl! ) {
        //          cell.tagImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        //        }
        // METHOD 2: ======================================
        //TODO: USE CONSISTANT PHOTO METHOD
        if let url = URL(string: tagPhotoFileUrl! ) {
            //            cell.tagImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
            // Round corner
            //var processor = RoundCornerImageProcessor(cornerRadius: 20)
            
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
            
            //TODO: FIX SIZE
            let processor = CroppingImageProcessor(size: CGSize(width: 100, height: 100), anchor: CGPoint(x: 0.5, y: 0.5))
            let placeholderImage = UIImage(named: "icons8-camera-1")
            cell.tagImageView.kf.setImage(with: url, placeholder: placeholderImage, options: [.processor(processor)])
            
            cell.tagImageView.contentMode = .scaleAspectFit //APRIL 2018 WAS FILL
            
        }
        //=================================================

        
        cell.tagTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        cell.tagSubTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        cell.tagCompany.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        cell.dateAdded.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        //THE FOLLOWING MESS UP THE SIZE OF THE CELL !!!
        //DO NOT PUT THEM BACK !!!!
        //cell.accessoryType = .detailDisclosureButton
        //cell.accessoryView = UIImageView(image: UIImage(named: "DisclosureIndicator"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tableView.deselectRow(at: indexPath, animated: true)
        
        self.currentRow = indexPath.row
        
        
        //let theVige = self.tagObjects[indexPath.row]
        //let vige = theVige.tagTitle
        //print("VIGE: \(vige)")
        
        
        //TODO:      PUT THE FOLLOWING LINES BACK
        //        let cellDataParse:PFObject = self.dataParse.object(at: indexPath.row) as! PFObject
        //
        //        var tagUrl:String? = cellDataParse.object(forKey: "tagUrl") as? String
        //        if tagUrl == nil {tagUrl = ""}
        //
        //        if tagUrl != "" {
        //            // Close NFC reader session and open URI after delay. Not all can be opened on iOS.
        //            //session.invalidate()
        //            if let url = URL(string: tagUrl ?? "") {
        //                let safariVC = SFSafariViewController(url: url)
        //                present(safariVC, animated: true, completion: nil)
        //            }
        //        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cell.backgroundColor = UIColor.black
        //cell.backgroundColor = UIColor(white:1, alpha: 0.5)
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        setEditing(true, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        setEditing(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        //            let objectToMove = listingsArray[fromIndexPath.row]
        //            listingsArray.remove(at: fromIndexPath.row)
        //            listingsArray.insert(objectToMove, at: toIndexPath.row)
        //            moveDirtyFlag = true
    }
    
    //        guard let url = URL.init(string: "https://en.wikipedia.org/wiki/\(title)")
    //            else { return }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print(segue.identifier!)
        if segue.identifier == "TagDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! DetailViewController
                destinationController.tag = self.tagObjects[indexPath.row]
            }
        }
        
        if segue.identifier == "SwiftyMap2" {
            
            print (currentRow)
            let destinationController = segue.destination as! SwiftyMapController
            destinationController.tag = self.tagObjects[currentRow]
            
        }
    }
    
    
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if let destination = segue.destination as? AuteurDetailViewController,
    //            let indexPath = tableView.indexPathForSelectedRow {
    //            //TODO: FIX THIS destination.selectedAuteur = auteurs[indexPath.row]
    //            //            if let indexPath = tableView.indexPathForSelectedRow {
    //            //                let destinationController = segue.destination as! RestaurantDetailViewController
    //            //                destinationController.restaurantImageName = restaurantImages[indexPath.row]
    //            //                destinationController.restaurantName = restaurantNames[indexPath.row]
    //            //                destinationController.restaurantType = restaurantTypes[indexPath.row]
    //            //                destinationController.restaurantLocation = restaurantLocations[indexPath.row]
    //            //            }
    //        }
    //    }
    
    /*
     //TODO: ALEX PUT BACK
     // MARK: - Table view delegate 2
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
     let delete = UIContextualAction(style: .destructive, title: "DELETE", handler: { action, sourceView, completionHandler in
     //NSLog(@"index path of delete: %@", indexPath);
     print ("REMOVE ROW")
     
     // delete from server
     let cellDataParse:PFObject = self.dataParse.object(at: indexPath.row) as! PFObject
     self.objectId = cellDataParse.objectId ?? ""
     let query = PFQuery(className: "Tags")
     
     query.getObjectInBackground(withId: self.objectId) { (object: PFObject?, error: Error?) in
     if let error = error {
     // The query failed
     print(error.localizedDescription)
     //self.displayMessage(message: error.localizedDescription)
     } else if let object = object {
     // The query succeeded with a matching result
     print("SUCCESS + \(self.objectId)")
     object.deleteInBackground()
     
     //self.tableView.deleteRows(at: [indexPath], with: .automatic)
     //self.dataParse.remove(indexPath.row)
     //completionHandler(true)
     //self.displayMessage(message: "Successfully Deleted")
     //self.tableView.reloadData()
     self.showTagTable() //VALENTINA 0
     } else {
     // The query succeeded but no matching result was found
     //self.displayMessage(message: "No Record Found")
     print("NO MATCH FOUND")
     }
     }
     
     completionHandler(true)
     })
     delete.backgroundColor = UIColor.red //arbitrary color
     //delete.image = [HCMPlugin bundleImageWithName:@"contactInfoDelete20x20"];
     
     let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
     swipeActionConfig.performsFirstActionWithFullSwipe = false
     return swipeActionConfig
     }
     
     //mapAction
     func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
     
     //MoreInfo
     let moreInfoAction = UIContextualAction(style: .normal, title: "More", handler: { action, sourceView, completionHandler in
     
     /*
     self.row = indexPath.row
     self.moreInfo()
     */
     completionHandler(true)
     })
     moreInfoAction.backgroundColor = .blue
     
     //map
     let mapAction = UIContextualAction(style: .normal, title: "Map", handler: { action, sourceView, completionHandler in
     //                                                                           NSLog(@"index path : %ld", (long)indexPath.row);
     /*
     self.showMapView(indexPath)
     */
     completionHandler(true)
     })
     mapAction.backgroundColor = UIColor.purple //arbitrary color
     
     //text
     let smsAction = UIContextualAction(style: .normal, title: "Text", handler: { action, sourceView, completionHandler in
     //                                                                           NSLog(@"index path : %ld", (long)indexPath.row);
     /*
     self.row = indexPath.row
     self.showSMS()
     */
     
     completionHandler(true)
     })
     smsAction.backgroundColor = UIColor.blue //arbitrary color
     
     //rate
     let rateAction = UIContextualAction(style: .normal, title: "Rate", handler: { action, sourceView, completionHandler in
     //                                                                           NSLog(@"index path : %ld", (long)indexPath.row);
     /*
     self.row = indexPath.row
     self.rateAlert()
     */
     completionHandler(true)
     })
     //rateAction.backgroundColor = UIColor.steelBlue()
     rateAction.backgroundColor = UIColor(red: 38.0/255.0, green: 162.0/255.0, blue: 78.0/255.0, alpha: 1.0)
     
     //-------------------------------------------------//
     let swipeActionConfig = UISwipeActionsConfiguration(actions: [moreInfoAction, rateAction, smsAction, mapAction])
     swipeActionConfig.performsFirstActionWithFullSwipe = false
     return swipeActionConfig
     //-------------------------------------------------//
     
     }
     */

    
    // MARK: - TRAILING SWIPE Table view delegate
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            print ("REMOVE ROW")
            let tag = self.tagObjects[indexPath.row]
            self.deleteObjectId = tag.tagObjectId
            print("DELETE1 + \(self.deleteObjectId)")
//            Alertift.alert(title: "Remove Item",message: "Are you sure you wish to Remove this Item?")
//                .action(.default("Yes"), isPreferred: true) { (_, _, _) in
//                    print("YES!")
//                    self.removeItem()
//                    completionHandler(true)
//                }
//                .action(.cancel("No")) { (_, _, _) in
//                    print("No/Cancel Clicked")
//                    completionHandler(false)
//                }
//                .show()
            
            self.removeItem()
            completionHandler(true)
            
            
            // Call completion handler with true to indicate
            
        }
        
        let websiteAction = UIContextualAction(style: .normal, title: "Website") { (action, sourceView, completionHandler) in
            
            //SHOW WEBSITE
            let tag = self.tagObjects[indexPath.row]
            let link = tag.tagUrl
            if let url = URL(string: link ) {
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true, completion: nil)
            }
            completionHandler(true)
        }
        
        let mapAction = UIContextualAction(style: .normal, title: "Map") { (action, sourceView, completionHandler) in
            DispatchQueue.main.async {
                //SWIFTYMAP
                //print("SWIFTYMAP2")
                self.performSegue(withIdentifier: "SwiftyMap2", sender: self)
            }
            completionHandler(true)
        }
        
        // Set the icon and background color for the actions
        deleteAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        //TODO: PUT ALL GRAPHICS BACK  deleteAction.image = UIImage(named: "delete")
        
        mapAction.backgroundColor = skyBlueColor
        //TODO: ADD NICE IMAGE
        //mapAction.image = UIImage(named: "tick")
        
        //        shareAction.backgroundColor = cactusGreenColor
        //        shareAction.image = UIImage(named: "share")
        
        websiteAction.backgroundColor = steelBlueColor
        //TODO: ADD NICE IMAGE
        //websiteAction.image = UIImage(named: "tick")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, mapAction, websiteAction])
        
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
    

    func removeItem () {
        print("DELETE2 + \(self.deleteObjectId)")
        let query = PFQuery(className: "Tags")
        
        
        query.getObjectInBackground(withId: self.deleteObjectId) { (object: PFObject?, error: Error?) in
            if let error = error {
                // The query failed
                print(error.localizedDescription)
                //self.displayMessage(message: error.localizedDescription)
            } else if let object = object {
                // The query succeeded with a matching result
                print("SUCCESS")
                //object.deleteInBackground()
                
                object.deleteInBackground(block: { (deleteSuccessful, error) -> Void in
                    // User deleted
                    //self.tableView.reloadData()
                    self.loadTagTable() //DELETE
                })
                
                //self.tableView.deleteRows(at: [indexPath], with: .automatic)
                //self.dataParse.remove(indexPath.row)
                //completionHandler(true)
                //self.displayMessage(message: "Successfully Deleted")
                
                
            } else {
                // The query succeeded but no matching result was found
                //self.displayMessage(message: "No Record Found")
                print("NO MATCH FOUND")
            }
        }
    }
    
    // MARK: === SIGN IN ROUTINES ===========
    
    func actionLogout() {
        
        let currentUser = PFUser.current()
        
        if currentUser != nil {
            //TODO: FIX ALL PROGRESSHUD
            //ProgressHUD.show("Logging Out ...", interaction: false)
            PFUser.logOut()
            
            kAppDelegate.currentUserEmail = "anonymous@hillsoft.com"
            kAppDelegate.currentUserName = "anonymous"
            //kAppDelegate.loggedInFlag = false
            //kAppDelegate.currentUserFacebookId = ""
            kAppDelegate.currentUserRole = "User"
            //kAppDelegate.currentAgentObjectId = ""
            kAppDelegate.currentUserObjectId = ""
            kAppDelegate.currentUserIsAgent = false
            
            //[self showHideButtons];
            //ProgressHUD.dismiss()
            btnSignIn.title = "Sign In"
            
            //CRITICAL. SET NUMBER OF ROWS IN MENU !!
            let dict = [
                "ACTION": "LOGOUT"
            ]
            //TODO: WHAT EXACTLY IS THIS DOING?
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kREFRESHUSERTABLE), object: nil, userInfo: dict)
            
            showLoginScreen()
        }
    }
    
    func showLoginScreen(){
        kAppDelegate.isDatabaseDirty = true  //FORCE A DATABASE LOAD AFTER RETURNING FROM LOGIN
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewControllerIdentifier") as! LoginViewController
        self.present(loginViewController, animated: true, completion: nil)
        
        
        //        let loginViewController =  RegisterViewController()
        //        self.navigationController?.show(loginViewController, sender: self)
        
        //        let registerViewController = RegisterViewController()
        //        navigationController?.pushViewController(registerViewController, animated: true)
        //self.navigationController?.pushViewController(loginViewController, animated: true)
        //        self.present(loginViewController, animated: false, completion: nil)
    }
    
    
    func showCurrentUserInfo() {
        print("showCurrentUserInfo")
        
        let currentUser = PFUser.current()

        if currentUser != nil {
            //kAppDelegate.loggedInFlag = true;
            
            kAppDelegate.currentUserEmail = currentUser?.email
            if kAppDelegate.currentUserEmail == nil {
                kAppDelegate.currentUserEmail = "anonymos@hillsoft.com"
            }
            
            kAppDelegate.currentUserName = currentUser?.object(forKey: PF_USER_FULLNAME) as? String
            if kAppDelegate.currentUserName == nil {
                kAppDelegate.currentUserName = "anonymous"
            }
            //print (kAppDelegate.currentUserName)
            
//            kAppDelegate.currentUserFacebookId = currentUser?.object(forKey: PF_USER_FACEBOOKID) as? String
//            if kAppDelegate.currentUserFacebookId == nil {
//                kAppDelegate.currentUserFacebookId = ""
//            }
            
            kAppDelegate.currentUserRole = currentUser?.object(forKey: PF_USER_USERROLE) as? String  // Agent or Builder or User or Anything
            if kAppDelegate.currentUserRole == nil {
                kAppDelegate.currentUserRole = "User"
            }
            
            kAppDelegate.currentUserObjectId = currentUser?.object(forKey: PF_USER_AGENTOBJECTID) as? String
            if kAppDelegate.currentUserObjectId == nil {
                kAppDelegate.currentUserObjectId = ""
            }
            //TODO: PUT BACK? kAppDelegate.currentUserObjectId = currentUser?.objectId
            
            var isAgent = currentUser?.object(forKey: PF_ISAGENTYN) as? String
            if isAgent == nil {
                isAgent = "NO"
            }
            
            if (isAgent == "YES") {
                kAppDelegate.currentUserIsAgent = true
                btnMaintenance.title = "Manage"
                btnMaintenance.isEnabled = true
            } else {
                kAppDelegate.currentUserIsAgent = false
                btnMaintenance.title = ""
                btnMaintenance.isEnabled = false
            }
            
            btnSignIn.title = "Sign Out"
            //statusLabel.text = //HANDLED EARLIER
            
        } else {
            //kAppDelegate.loggedInFlag = false
            kAppDelegate.currentUserEmail = "anonymous@hillsoft.com"
            kAppDelegate.currentUserName = "anonymous"
            //kAppDelegate.currentUserFacebookId = ""
            kAppDelegate.currentUserRole = "User"
            kAppDelegate.currentUserObjectId = ""
            kAppDelegate.currentUserIsAgent = false
            
            btnSignIn.title = "Sign In"
            statusLabel.text = "Please Sign In"
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - MISC ROUTINES
    //    func createPhotoURL2(_ useAction: String?, withID useID: String?, withNumber useNumber: Int) -> String? {
    //        if useID == nil {
    //            return nil
    //        }
    //        var url = ""
    //        url = String(format: "%@%@-%@-%ld.jpg", SERVERFILENAME, useAction ?? "", useID ?? "", useNumber)
    //        //NSLog(@"URL: %@",url);
    //        return url
    //
    //    }
    

    
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
    
    
    func showSimpleAlert() {
        //    Alertift.alert(title: "Sample 1", message: "Simple alert!")
        //        .image: #imageLiteral(resourceName: <#T##String#>)
        //        .action(.default("OK"))
        //        .show()
        
        Alertift.alert(message: "Can use image in alert action")
            .action(.default("info"), image: UIImage(named: "confirm"))
            .show()
    }
    
    func showYesOrNoAlert() {
        Alertift.alert(title: "Sample 2",message: "Do you like 🍣?")
            .action(.default("Yes"), isPreferred: true) { (_, _, _) in
                Alertift.alert(message: "🍣🍣🍣")
                    .action(.default("Close"))
                    .show()
            }
            .action(.cancel("No")) { (_, _, _) in
                Alertift.alert(message: "😂😂😂")
                    .action(.destructive("Close"))
                    .show()
            }
            .show()
    }
    
    func bounce(_ button: UIButton?) {
        var theAnimation: CABasicAnimation?
        theAnimation = CABasicAnimation(keyPath: "transform.translation.y") ///use transform
        theAnimation?.duration = 0.4
        theAnimation?.repeatCount = 2
        theAnimation?.autoreverses = true
        theAnimation?.fromValue = NSNumber(value: 1.0)
        theAnimation?.toValue = NSNumber(value: -20)
        if let theAnimation = theAnimation {
            button?.layer.add(theAnimation, forKey: "animateTranslation")
        } //animationkey
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
    
    //    @IBAction func unwindToMainController(segue: UIStoryboardSegue) {
    //        print ("Return here after adding a new account")
    //    }
    
    //UNWIND TO HERE FROM LOGIN or SIGNUP
    @IBAction func unwindToTagListController(segue: UIStoryboardSegue) {
        // SEE IF YOU HAVE A USER ALREADY LOGGED IN
        let currentUser = PFUser.current()
        if currentUser == nil {
            showLoginScreen()
        } else {
            showCurrentUserInfo()   //UPDATE CURRENT USER INFO
        }
        
        if (kAppDelegate.isDatabaseDirty == true) {
            //GET INFO FOR NEW USER IF NEW LOGIN or DATA CHANGED!!
            //TODO: THIS STATEMENT IS CRITICAL. RELOAD THE PHOTO/DATA AFTER MAINT CHANGES.
            loadTagTable() //GET INFO FOR NEW USER
            kAppDelegate.isDatabaseDirty = false
        }
    }
    
    
}

/*
 let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
 let theVige = self.tagObjects[indexPath.row]
 let title = theVige.tagTitle
 let defaultText = "Just checking in at " + title
 
 let activityController: UIActivityViewController
 
 //            let imageNaME = theVige.tagUrl
 //            if let imageToShare = UIImage(named: self.restaurants[indexPath.row].image) {
 //                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
 //            } else  {
 //                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
 //            }
 //TODO: TAKE THIS OUT!
 activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
 
 if let popoverController = activityController.popoverPresentationController {
 if let cell = tableView.cellForRow(at: indexPath) {
 popoverController.sourceView = cell
 popoverController.sourceRect = cell.bounds
 }
 }
 
 self.present(activityController, animated: true, completion: nil)
 completionHandler(true)
 }
 */
