import UIKit
import CoreNFC
import VYNFCKit
import Parse
import Alamofire
import AlamofireImage
import SafariServices
import Alertift
//import DTGradientButton
//WELL DONE ALEX

class AuteurListViewController:UIViewController,SFSafariViewControllerDelegate, NFCNDEFReaderSessionDelegate, UITableViewDelegate {
    
     let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
    private var tagObjects:[TagModel] = []
    private var dataParse:NSMutableArray = NSMutableArray()
    
    //TODO: ALEX REMOVE THE FOLLOWING 2 LINES. DEBUGGING ONLY
    
    var userName:String? = "alex@hillsoft.com"
    var password:String? = "alex"


    
//    let PF_USER_FIRSTNAME = "firstName"
//    let PF_USER_LASTNAME = "lastName"
//    let PF_USER_FULLNAME = "fullname"
//    let PF_WWAGENTYN = "workingwithagentyn"
//    let PF_ISAGENTYN = "isagentyn"
//    let PF_USER_EMAIL = "email"
//    let PF_AGENTID = "agentID"
//    let PF_PASSWORD = "password"
//    let PF_USER_FULLNAMELOWER = "fullnameLower"
    

    private var theVige:String? = ""
    private var appName:String? = ""
    
    private var scanResults: String? = ""

    private var objectId:String = ""    //USED BY DELETE

    //private let apiFetcher = APIRequestFetcher()
    private var propertyPhotoFileName:String? = ""
    private var propertyPhotoFileUrl:String? = ""
    private var propertyPhotoFilePath:String? = ""
    private var propertyPlaceholderImage: UIImage?
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var btnMaintenance: UIBarButtonItem!
    @IBOutlet weak var btnSignIn: UIBarButtonItem!
    //@IBOutlet weak var scanButton: AXWireButton!
    //@IBOutlet weak var btnMaintenance: UIBarButtonItem!
    //@IBOutlet weak var btnSignIn: UIBarButtonItem!
    
    @IBOutlet weak var statusView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = kAppDelegate.appName as String?
        
        //TODO: REPLACE WITH PROPER LOGIN
        kAppDelegate.currentUserName = "Test"
        kAppDelegate.currentUserEmail = "info@kcontemporaryart.com"

        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 92.0 // Use 90
        tableView.backgroundColor = coralColor
        
        statusView.backgroundColor = paleRoseColor
//        statusLabel.backgroundColor = [UIColor coralColor];
        statusLabel.backgroundColor = .white
        statusLabel.textColor = royalBlue
        //statusLabel.font.withSize(16.0)

        
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: .bold) ]
        navigationItem.largeTitleDisplayMode = .always
        

        
        //        moveDirtyFlag = false
        //        buttonLabel = "Edit"
        //        editing = false
        //        showNavigationButtons()
        //
        //        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didChangePreferredContentSize(_:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
        

        
        let myColor = royalBlue
        scanButton.backgroundColor = myColor
        scanButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        scanButton.layer.cornerRadius = scanButton.frame.height/2
        scanButton.layer.masksToBounds = true
        scanButton.tintColor = .white

        

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //FORCE LOGIN IF NOT ALREADY LOGGED IN
        let currentUser = PFUser.current()
        if currentUser == nil {
//            let welcomeViewController = WelcomeView(nibName: "WelcomeView", bundle: nil)
//            navigationController?.pushViewController(welcomeViewController, animated: true)
            loadLoginScreen()
            
        } else {
            signInorOut()
            showTagTable() //VALENTINA1
            //TODO: kAppDelegate.loginChanged = false
        }
        
        //    if (kAppDelegate.loginChanged == YES) {
        //        [self logInorOut];
        //        [self listTags]; //VALENTINA2
        //    }
        
        //NSLog(@"CURRENTUSEREMAIL: %@",kAppDelegate.currentUserEmail);
        
        // THIS STATEMENT IS CRITICAL. THIS WILL RELOAD THE PHOTO/DATA AFTER MAINT CHANGES. FEB2018
        tableView.reloadData()
        // EACH TIME YOU RETURN HERE (SAY FROM DETAIL VIEW) REFRESH THE TABLE
        self.tableView.reloadData()
        
    }
    

    
    @IBAction func tryButtonPressed(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewControllerIdentifier") as! LoginViewController
        self.present(loginViewController, animated: true, completion: nil)
        
        
        
        
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
    
    @IBAction func scanButtonPressed(_ sender: Any) {
        scanResults = ""
        let session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
        session.begin()
        bounce(scanButton)
    }
    

    
    // MARK: - MISC ROUTINES
//    func createFileName(withAction useAction: String?, withID useID: String?, withNumber useNumber: Int) -> String? {
//        if useID == nil {
//            return nil
//        }
//        let url = String(format: "%@-%@-%ld.jpg", useAction ?? "", useID ?? "", useNumber)
//        return url
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
    
    // MARK: - NFC READER DELEGATES
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        NSLog("%@", error.localizedDescription)
        let message = String(format: "%@%@\n", scanResults!, error.localizedDescription)
        DispatchQueue.main.async {
            //TODO: THIS ERROR ALWAYS COMES UP, EVEN ON A SUCCESSFUL SCAN. ????
            //YOU CAN COMMENT IT OUT FOR NOW~!
            print(message)

        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            
            // THE FOLLOWING 3 LINES ADDED BY ALEX
            var response:String = ""  //MESSAGE WITH RETURNED PAYLOAD
            var textPayload:String = ""  //THIS IS THE TEXT WE ARE LOOKING FOR!! BINGO!!
            var urlString:String = "" //EXTRACT A URL IF POSSIBLE
            
            
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
                    
                    // IF THERE IS A VALID URL HERE THEN SHOW IT!
                    
                    if let checkedUrl = NSURL(string: urlString) {
                        // you can use checkedUrl here
                    }
                    
                    
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
    
func showWebPage(_ urlString: String?) {
    // Close NFC reader session and open URI after delay. Not all can be opened on iOS.
    //session.invalidate()
    if let url = URL(string: urlString ?? "") {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }

}
    
    // MARK: - PARSE QUERIES
    // AFTER SUCCESSFULLY SCANNING A TAG, LOOKUP THE MATCHING OWNER INFO
    func lookupTagIfo(_ useTagId: String?) {
        //tagId = "info@kcontemporaryart.com:102" //TODO: REMOVE
        print("USETAGID: \(useTagId ?? "")")
        
        //AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        //or: AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        //AudioServicesPlaySystemSound(1103) // SMSReceived (see SystemSoundID below)
        
        //beaconAlert?.dismiss()
        
        let query = PFQuery(className: "TagOwnerInfo")
        query.whereKey("ownerId", equalTo: useTagId!)
        query.getFirstObjectInBackground {(object: PFObject?, error: Error?) in
                if let error = error {
                    // The query failed
                    print(error.localizedDescription)
                    self.displayErrorMessage(message: error.localizedDescription)
                } else if let object = object {
                    // The query succeeded with a matching result
                    print("HERE WE ARE!!")
                    print(object)
                    

                    
                    let ownerEmail = object["ownerEmail"] as? String ?? ""
                    let ownerName = object["ownerName"] as? String ?? ""
                    let ownerPhotoRef = object["ownerPhotoRef"] as? String ?? ""
                    // object.objectId;
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

                    tag["userName"] = self.kAppDelegate.currentUserName
                    tag["userEmail"] = self.kAppDelegate.currentUserEmail //info@kcontemporaryart.com
                    tag["appName"] = self.kAppDelegate.appCode
                    tag["sequence"] = NSNumber(value: 1000) //TODO: ALEX STILL NEED TO FIX THIS
                    
                    tag["tagPhotoRef"] = ownerPhotoRef
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
                            print ("SAVED IN BACKGROUND:  + \(ownerUrl)")
                            self.showTagTable()
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
                            self.displayMessage(message: "FAILED!")
                        }
                    }
                    print("Successfully added to TAGS table")
                } else {
                    // The query succeeded but no matching result was found
                    self.displayErrorMessage(message: "Record Not Found")
                }
            
        }

    }

    func showTagTable()
    {
        let query = PFQuery(className:"Tags")
        let appCode = kAppDelegate.appCode as String?
        var userEmail = kAppDelegate.currentUserEmail as String?
        ////userEmail = "romee@hillsoft.com"
        print (appCode as Any)
        print ("UserEmail: \(userEmail as Any)")
        query.whereKey("appName", equalTo: appCode!)
        query.whereKey("userEmail", equalTo: userEmail!)
        query.order(byDescending: "createdAt")
        
        //query.whereKey("tagTitle", equalTo: "Vige")
        query.limit = 500
        dataParse = []
        tagObjects = []
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                // The find succeeded.
                print("Successfully retrieved \(objects.count) objects.")
                // Do something with the found objects
                var rowCount = 0
                for object in objects {
                    
                    self.dataParse.add(object)
                    
//                    let createdAt: Date? = object.createdAt()
//
//                    //Romee
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
                    
                    let cellDataParse:PFObject = self.dataParse.object(at: rowCount) as! PFObject
                    
                    //var createdAt:Date? = (cellDataParse["createdAt"].cre
                    //if createdAt == nil {createdAt = ""}
                    let createdAt:Date = object.createdAt!
                    

                    var userName:String? = cellDataParse["userName"] as? String
                    if (userName == nil) {userName = ""}
                    var userEmail:String? = cellDataParse["userEmail"] as? String
                    if (userEmail == nil) {userEmail = ""}
                    var ownerName:String? = cellDataParse["ownerName"] as? String
                    if (ownerName == nil) {ownerName = ""}
                    var ownerEmail:String? = cellDataParse["ownerEmail"] as? String
                    if (ownerEmail == nil) {ownerEmail = ""}
                    
                    var appName:String? = cellDataParse["appName"] as? String
                    if (appName == nil) {appName = ""}
                    var beaconDymo:String? = cellDataParse["beaconDymo"] as? String
                    if (beaconDymo == nil) {beaconDymo = ""}
                    var beaconColor:String? = cellDataParse["beaconColor"] as? String
                    if (beaconColor == nil) {beaconColor = ""}
                    
                    var tagObjectId:String? = cellDataParse["tagObjectId"] as? String
                    if (tagObjectId == nil) {tagObjectId = ""}
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
                    
                    var triggerDistance:String? = cellDataParse["triggerDistance"] as? String
                    if (triggerDistance == nil) {triggerDistance = ""}
                    var sequence:String? = cellDataParse["sequence"] as? String
                    if (sequence == nil) {sequence = ""}
                    
                    let newObject = TagModel(createdAt: createdAt, userName: userName!, userEmail: userEmail!, ownerName: ownerName!, ownerEmail:ownerEmail!, appName: appName!, beaconDymo: beaconDymo!, beaconColor: beaconColor!, tagObjectId: tagObjectId!, tagPhotoRef: tagPhotoRef!, tagId: tagId!, tagTitle: tagTitle!, tagUrl: tagUrl!, tagInfo: tagInfo!, tagAddress: tagAddress!, latitude: latitude!, longitude: longitude!, tagSubTitle: tagSubTitle!, tagCompany: tagCompany!, tagAddress2: tagAddress2!, tagCity: tagCity!, tagState: tagState!, tagZip: tagZip!, tagCountry: tagCountry!, triggerDistance: triggerDistance!, sequence: sequence!)

                    self.tagObjects.append(newObject)
                    self.dataParse.add(object)
                    rowCount = rowCount + 1
                    
                    
                    // ============================================================
                    // TODO: THE FOLLOWING ARE ALL OPTIONAL AND CAN ALL BE NIL !!
                    // ============================================================
                    
                    // NB: Sequence is Numeric!!
                    //var sequence = cellDataParse.object(forKey: "sequence") as? Double
                    //print (sequence as Any)
                    
                }
            }
            self.tableView.reloadData()
        }
    }
}

    // MARK: - Table view
// TODO: CODE TO REMOVE A ROW

extension AuteurListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let count = self.dataParse.count
        let count = self.tagObjects.count
        
        if (count > 0) {
            //TODO: PUT BACK
            //statusLabel.text = "Swipe row left to delete, right for more options";
        }
        return count;
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // if editingStyle == .delete {
        // CODE MOVED TO: trailingSwipeActionsConfigurationForRowAt
        // }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AuteurTableViewCell
        //let auteur = auteurs[indexPath.row]
        let tag = self.tagObjects[indexPath.row] //The Vige
        
        let cellDataParse:PFObject = self.dataParse.object(at: indexPath.row) as! PFObject
        //self.objectId = cellDataParse.objectId ?? ""
        //print(self.objectId)
        
        // ============================================================
        // TODO: THE FOLLOWING ARE ALL OPTIONAL AND CAN ALL BE NIL !!
        // ============================================================
        
        // NB: Sequence is Numeric!!
        //var sequence = cellDataParse.object(forKey: "sequence") as? Double
        //print (sequence as Any)
        
//        let vige = tag.tagTitle
//        print("VIGE: \(vige)")
//        //Well done Vige!
//
//
//        var tagTitle:String? = cellDataParse.object(forKey: "tagTitle") as? String
//        var tagSubTitle = cellDataParse.object(forKey: "tagSubTitle") as? String
//        var tagCompany = cellDataParse.object(forKey: "tagCompany") as? String
//
//
//        if tagTitle == nil {tagTitle = ""}
//        if tagSubTitle == nil {tagSubTitle = ""}
//        if tagCompany == nil {tagCompany = ""}
        
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
        //var alex:String? = "property_placeholder"
        //alex = "The Vige"
        //propertyPlaceholderImage = UIImage(named: alex ?? "")
        //propertyPlaceholderImage = UIImage(named: "property_placeholder")
        
        //var tagPhotoRef = cellDataParse.object(forKey: "tagPhotoRef") as? String
        let tagPhotoRef = tag.tagPhotoRef

        let cloudinaryAction = "Tag"
        let usePhotoRef:String? = tagPhotoRef
        let photoNumber = 1
        let propertyPhotoFileUrl:String? = createPhotoURL(cloudinaryAction, withID: usePhotoRef, withNumber: photoNumber) ?? ""
        
        cell.tagImageView.layer.cornerRadius = cell.tagImageView.frame.size.width / 4
        cell.tagImageView.layer.masksToBounds = true
        cell.tagImageView.clipsToBounds = true
        
        // METHOD 1: ======================================
//        let url = URL(string: propertyPhotoFileUrl!)!
//        cell.tagImageView.image = resizedImage(at: url, for: CGSize(width: 88,height: 88))
        //=================================================
        
        // METHOD 2: ======================================
        let url = URL(string: propertyPhotoFileUrl!)!
        let placeholderImage = UIImage(named: "Photo-Unavailbale-300-Square")!
        cell.tagImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        //=================================================

        cell.tagTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        cell.tagSubTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        cell.tagCompany.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        cell.dateAdded.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.accessoryView = UIImageView(image: UIImage(named: "DisclosureIndicator"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let theVige = self.tagObjects[indexPath.row]
        let vige = theVige.tagTitle
        print("VIGE: \(vige)")
        
        //romee

        


//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
//
//            let detailViewController = MyDetailViewController()
//            self.navigationController?.pushViewController(detailViewController, animated: true)
//            
//        })


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
        if segue.identifier == "TagDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! MyDetailViewController
                destinationController.myNameLabel = "ALEX"
                destinationController.tag = self.tagObjects[indexPath.row]
            
                
                //destinationController.tags = self.tagObjects[indexPath.row]
            }
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
    
    // MARK: - Table view delegate 2
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
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
            // Call completion handler with true to indicate
            completionHandler(true)
        }
        
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
        
        // Set the icon and background color for the actions
        deleteAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        deleteAction.image = UIImage(named: "delete")
        
        shareAction.backgroundColor = UIColor(red: 254.0/255.0, green: 149.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        shareAction.image = UIImage(named: "share")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let checkInAction = UIContextualAction(style: .normal, title: "Check-in") { (action, sourceView, completionHandler) in
            
//            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
//            self.restaurants[indexPath.row].isVisited = (self.restaurants[indexPath.row].isVisited) ? false : true
//            cell.heartImageView.isHidden = self.restaurants[indexPath.row].isVisited ? false : true
            
            completionHandler(true)
        }
        
        let checkInIcon = "tick" //restaurants[indexPath.row].isVisited ? "undo" : "tick"
        checkInAction.backgroundColor = UIColor(red: 38.0/255.0, green: 162.0/255.0, blue: 78.0/255.0, alpha: 1.0)
        checkInAction.image = UIImage(named: checkInIcon)
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [checkInAction])
        
        
        return swipeConfiguration
    }
    

    
/*
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let checkInAction = UIContextualAction(style: .normal, title: "Check-in") { (action, sourceView, completionHandler) in
            
//            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
//            self.restaurants[indexPath.row].isVisited = (self.restaurants[indexPath.row].isVisited) ? false : true
//            cell.heartImageView.isHidden = self.restaurants[indexPath.row].isVisited ? false : true
//
            completionHandler(true)
        }
        
//        let checkInIcon = restaurants[indexPath.row].isVisited ? "undo" : "tick"
        checkInAction.backgroundColor = UIColor(red: 38.0/255.0, green: 162.0/255.0, blue: 78.0/255.0, alpha: 1.0)
        checkInAction.image = UIImage(named: checkInIcon)
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [checkInAction])
     
        return swipeConfiguration
    }
  */
    

//    func signIn() {
//        let sv = UIViewController.displaySpinner(onView: self.view)
//        PFUser.logInWithUsername(inBackground: userName!, password: password!) { (user, error) in
//            UIViewController.removeSpinner(spinner: sv)
//            if user != nil {
//                print("Successfully Logged In")
//                let userName:String? = user?.username
//                self.displayMessage(message: "Successfully Logged In \(userName ?? "No Name")")
//                //self.loadHomeScreen()
//            }else{
//                if let descrip = error?.localizedDescription{
//                    self.displayErrorMessage(message: (descrip))
//                }
//            }
//        }
//    }
    

    
//    func signUp() {
//        let user = PFUser()
//
//        user.username = userName
//        user.password = password
//        let sv = UIViewController.displaySpinner(onView: self.view)
//        user.signUpInBackground { (success, error) in
//            UIViewController.removeSpinner(spinner: sv)
//            if success{
//                //self.loadHomeScreen()
//                print("Successfully Signed Up")
//                self.displayMessage(message: "Successfully Signed Up")
//
//
//            }else{
//                if let descrip = error?.localizedDescription{
//                    self.displayErrorMessage(message: descrip)
//                }
//            }
//        }
//    }
 
//    func logoutOfApp() {
//        let sv = UIViewController.displaySpinner(onView: self.view)
//        PFUser.logOutInBackground { (error: Error?) in
//            UIViewController.removeSpinner(spinner: sv)
//            if (error == nil){
//                //self.loadLoginScreen()
//                print ("Successfully Logged Out")
//                self.displayMessage(message: "Successfully Logged Out")
//            }else{
//                if let descrip = error?.localizedDescription{
//                    self.displayMessage(message: descrip)
//                }else{
//                    self.displayMessage(message: "error logging out")
//                }
//
//            }
//        }
//    }

// MARK: === SignINorOUT ===
    
@IBAction func signinButtonPressed(_ sender: Any) {

        let currentUser = PFUser.current()
        if currentUser != nil {
     Alertift.alert(title: "Sign in or out",message: "Are you sure you wish to Sign Out?")
     .action(.default("Yes"), isPreferred: true) { (_, _, _) in
        print("YES!")
        //self.actionLogout()
        self.actionLogout()
     }
     .action(.cancel("No")) { (_, _, _) in
        print("No/Cancel Clicked");
     }
     .show()

        } else {
            loadLoginScreen()
            //let welcomeViewController = WelcomeView(nibName: "WelcomeView", bundle: nil)
            //navigationController?.pushViewController(welcomeViewController, animated: true)
        }

    }
    
    func actionLogout() {
        
        let currentUser = PFUser.current()

        if currentUser != nil {
            //TODO: FIX ALL PROGRESSHUD
            //ProgressHUD.show("Logging Out ...", interaction: false)
            PFUser.logOut()
            
            
            kAppDelegate.currentUserEmail = "anonymous@hillsoft.com"
            kAppDelegate.currentUserName = "anonymous"
            kAppDelegate.loggedInFlag = false
            kAppDelegate.currentUserFacebookId = ""
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
            
            loadLoginScreen()
            
            //let welcomeViewController = WelcomeView(nibName: "WelcomeView", bundle: nil)
            //navigationController?.pushViewController(welcomeViewController, animated: true)
        }
    }
    
    func loadLoginScreen(){
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


    func signInorOut() {
        //var isAgent = "NO"
        let currentUser = PFUser.current()
        //let currentUser = PFUser.isCurrentUser as? PFUser
        if currentUser != nil {
            
//            statusLabel.text = [NSString stringWithFormat:@"%@ %@",@"Welcome ",currentUser[PF_USER_FULLNAME]];
            var loginName:String? = kAppDelegate.currentUserName
            if loginName == nil {loginName = "Name"}
            loginName = "Welcome " + loginName!
            statusLabel.text = loginName
            
            btnSignIn.title = "Sign Out"
            kAppDelegate.loggedInFlag = true;
            
            kAppDelegate.currentUserEmail = currentUser?.email
            if kAppDelegate.currentUserEmail == nil {
                kAppDelegate.currentUserEmail = "anonymos@hillsoft.com"
            }
            
            kAppDelegate.currentUserName = currentUser?.object(forKey: PF_USER_FULLNAME) as? String
            if kAppDelegate.currentUserName == nil {
                kAppDelegate.currentUserName = "anonymous"
            }
            
            kAppDelegate.currentUserFacebookId = currentUser?.object(forKey: PF_USER_FACEBOOKID) as? String
            if kAppDelegate.currentUserFacebookId == nil {
                kAppDelegate.currentUserFacebookId = ""
            }
            
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
                btnMaintenance.title = "Maintenance"
                btnMaintenance.isEnabled = true
            } else {
                kAppDelegate.currentUserIsAgent = false
                btnMaintenance.title = ""
                btnMaintenance.isEnabled = false
            }
        } else {
            statusLabel.text = "Please Sign In"
            btnSignIn.title = "Sign In"
            kAppDelegate.loggedInFlag = false
            kAppDelegate.currentUserEmail = "anonymous@hillsoft.com"
            kAppDelegate.currentUserName = "anonymous"
            kAppDelegate.currentUserFacebookId = ""
            kAppDelegate.currentUserRole = "User"
            kAppDelegate.currentUserObjectId = ""
            
            kAppDelegate.currentUserIsAgent = false
        }
    }
    

}
