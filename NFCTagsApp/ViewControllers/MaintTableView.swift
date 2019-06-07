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

let kAppDelegate = UIApplication.shared.delegate as! AppDelegate

private var ownerObjects:[OwnerModel] = []
private var CellIdentifier = "MaintTableViewCell"

class MaintTableView: UITableViewController {
    private var statsArray: [AnyHashable] = []
    private var visits: [AnyHashable] = []
    private var row: Int = 0
    private var useObjectId = ""
    private var usePhotoRef = ""
    private var useUrl = ""
    private var useTitle = ""
    private var useSubTitle = ""
    private var useCompany = ""
    private var useAddress = ""
    private var useInfo = ""
    private var useLatitude = ""
    private var useLongitude = ""
    private var useAddress2 = ""
    private var useCity = ""
    private var useState = ""
    private var useZip = ""
    private var useCountry = ""
    private var propertyPhotoFileName = ""
    private var propertyPhotoFileUrl = ""
    private var propertyPhotoFilePath = ""
    private var propertyPlaceholderImage: UIImage?
    
//    private var ownerModel: OwnerModel?
//    private var statsModel: StatsModel?

    @IBOutlet private var _tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Info"

        let backButton = UIBarButtonItem(image: UIImage(named: "backButt"), style: .plain, target: self, action: #selector(MaintTableView.goBackButtonPressed))
        navigationItem.leftBarButtonItem = backButton

        //    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backButton"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackButtonPressed)];
        //    self.navigationItem.leftBarButtonItem = menuButton;

        //    NSString *useBgColor = [[NSUserDefaults standardUserDefaults] objectForKey:kBACKGROUND];
        //    UIColor *backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:useBgColor]];
        //    self.view.backgroundColor = backgroundColor;
        //    self.navigationController.navigationBar.tintColor = kAppDelegate.fontColor;


        //    [[NSNotificationCenter defaultCenter] addObserver:self
        //                                             selector:@selector(refreshTable:)
        //                                                 name:@"refreshTable"
        //                                               object:nil];

        //TODO: FIX ROWHEIGHT
        //tableView.estimatedRowHeight = 100.0;
        //self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        //self.tableView.rowHeight = 64.0; //UITableViewAutomaticDimension;
        //self.tableView.rowHeight = 54.0; //UITableViewAutomaticDimension;
        
        
//        tableView.backgroundColor = UIColor.clear
//        //UIImage *image = [UIImage imageNamed:@"01_background"];
//        let image = UIImage(named: "background") //art_launch_image
//        let userInfo: UserInfoClass = UserInfoClass
//        let backImage: UIImage? = userInfo.image(with: image, scaledToSize: CGSize(width: view.frame.size.width, height: view.frame.size.height))
//        if let backImage = backImage {
//            view.backgroundColor = UIColor(patternImage: backImage)
//        }
        
        loadObjects()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    @objc func goBackButtonPressed() {
        navigationController?.popViewController(animated: true)
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
    
    func loadObjects()
    {
                let query = PFQuery(className: "TagOwnerInfo")
                query.whereKey("ownerEmail", equalTo: kAppDelegate.currentUserEmail)
                query.whereKey("appName", equalTo: kAppDelegate.appCode)
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
                print("Successfully retrieved \(objects.count) objects.")
                // Do something with the found objects
                
                for object in objects {
                    
                    let cellDataParse:PFObject = object //self.dataParse.object(at: rowCount) as! PFObject

                    let createdAt:Date = object.createdAt!
                    
                    var photoRef:String? = object["ownerPhotoRef"] as? String
                    var ownerNumber:String? = object["ownerNumber"] as? String
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
                    
                    if photoRef == nil {
                        photoRef = ""
                    }
                    if ownerNumber == nil {
                        ownerNumber = ""
                    }
                    if ownerTitle == nil {
                        ownerTitle = ""
                    }
                    if ownerSubTitle == nil {
                        ownerSubTitle = ""
                    }
                    if ownerCompany == nil {
                        ownerCompany = ""
                    }
                    if ownerUrl == nil {
                        ownerUrl = ""
                    }
                    if ownerAddress == nil {
                        ownerAddress = ""
                    }
                    if ownerAddress2 == nil {
                        ownerAddress2 = ""
                    }
                    if ownerCity == nil {
                        ownerCity = ""
                    }
                    if ownerState == nil {
                        ownerState = ""
                    }
                    if ownerZip == nil {
                        ownerZip = ""
                    }
                    if ownerCountry == nil {
                        ownerCountry = ""
                    }
                    
                    /*
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
                    */
                    
//                    let newObject = OwnerModel(createdAt: createdAt, userName: userName!, userEmail: userEmail!, ownerName: ownerName!, ownerEmail:ownerEmail!, appName: appName!, beaconDymo: beaconDymo!, beaconColor: beaconColor!, tagObjectId: tagObjectId!, tagPhotoRef: tagPhotoRef!, tagId: tagId!, tagTitle: tagTitle!, tagUrl: tagUrl!, tagInfo: tagInfo!, tagAddress: tagAddress!, latitude: latitude!, longitude: longitude!, tagSubTitle: tagSubTitle!, tagCompany: tagCompany!, tagAddress2: tagAddress2!, tagCity: tagCity!, tagState: tagState!, tagZip: tagZip!, tagCountry: tagCountry!, triggerDistance: triggerDistance!, sequence: sequence!)
                    
                    //ownerObjects.append(newObject)
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

            
            //let sv = UIViewController.displaySpinner(onView: self.view)
            UIViewController.removeSpinner(spinner: sv)
            
        }
    }
}


//    func queryForTable() -> PFQuery? {
//
//        let query = PFQuery(className: "TagOwnerInfo")
//        query.whereKey("ownerEmail", equalTo: kAppDelegate.currentUserEmail)
//        query.whereKey("appName", equalTo: kAppDelegate.appCode)
//        query.order(byDescending: "ownerNumber")
//
//        // CANNOT DO THE FOLLOWING. NEED TO ENTIRE RECORD. SEE didSelectRowAtIndexPath
//        //[query selectKeys:@[@"agentID",@"agentDisplayName",@"agentOfficeName",@"agentTitle",@"agentSlogan"]];
//
//
//        // If no objects are loaded in memory, we look to the cache first to fill the table
//        // and then subsequently do a query against the network.
//        if objects.count() == 0 {
//            query.cachePolicy = kPFCachePolicyCacheThenNetwork
//        }
//
//        return query
//    }

//    func refreshTable(_ notification: Notification?) {
//        // Reload the recipes
//        //loadObjects()
//    }

// MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return false
    }

    // Override to customize the look of a cell representing an object. The default is to display
    // a UITableViewCellStyleDefault style cell with the label being the first key in the object.
    func tableView(_ tableView: UITableView?, cellForRowAt indexPath: IndexPath?, object: PFObject?) -> UITableViewCell? {

        var cell: MaintTableViewCell? = nil
        if let indexPath = indexPath {
            cell = tableView?.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as? MaintTableViewCell
        }

        //OwnerModel *ownerObject = [self.objects objectAtIndex:indexPath.row];

        var photoRef = object?["ownerPhotoRef"] as? String
        var ownerNumber = object?["ownerNumber"] as? String
        var ownerTitle = object?["ownerTitle"] as? String
        var ownerSubTitle = object?["ownerSubTitle"] as? String
        var ownerCompany = object?["ownerCompany"] as? String
        var ownerUrl = object?["ownerUrl"] as? String
        var ownerAddress = object?["ownerAddress"] as? String
        var ownerAddress2 = object?["ownerAddress2"] as? String
        var ownerCity = object?["ownerCity"] as? String
        var ownerState = object?["ownerState"] as? String
        var ownerZip = object?["ownerZip"] as? String
        var ownerCountry = object?["ownerCountry"] as? String

        //    NSString *tagNumber = ownerObject.tagNumber;
        //    NSString *tagTitle = ownerObject.tagTitle;
        //    NSString *tagUrl = ownerObject.tagUrl;
        //    NSString *tagAddress = ownerObject.tagAddress;

        if photoRef == nil {
            photoRef = ""
        }
        if ownerNumber == nil {
            ownerNumber = ""
        }
        if ownerTitle == nil {
            ownerTitle = ""
        }
        if ownerSubTitle == nil {
            ownerSubTitle = ""
        }
        if ownerCompany == nil {
            ownerCompany = ""
        }
        if ownerUrl == nil {
            ownerUrl = ""
        }
        if ownerAddress == nil {
            ownerAddress = ""
        }
        if ownerAddress2 == nil {
            ownerAddress2 = ""
        }
        if ownerCity == nil {
            ownerCity = ""
        }
        if ownerState == nil {
            ownerState = ""
        }
        if ownerZip == nil {
            ownerZip = ""
        }
        if ownerCountry == nil {
            ownerCountry = ""
        }

        let shortAddress = "\(ownerAddress ?? "") \(ownerAddress2 ?? "") \(ownerCity ?? "")"

        cell?.tagNumber.text = ownerNumber
        cell?.tagTitle.text = ownerTitle
        cell?.tagUrl.text = ownerSubTitle
        cell?.tagAddress.text = shortAddress

        //==== IMAGE CODE ============================================================
//        let cloudinaryAction = "Tag"
//        let usePhotoRef = photoRef
//        let userInfo: UserInfoClass = UserInfoClass
//        propertyPhotoFileName = userInfo.createFileName(withAction: cloudinaryAction, withID: usePhotoRef, withNumber: 1)
//        propertyPhotoFileUrl = userInfo.createPhotoURL(cloudinaryAction, withID: usePhotoRef, withNumber: 1)
//        propertyPhotoFilePath = userInfo.documentsFilePath(propertyPhotoFileName)
//        propertyPlaceholderImage = UIImage(named: "property_placeholder")


        cell?.tagImageView.contentMode = .scaleAspectFit //APRIL 2018 WAS FILL
        cell?.tagImageView.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin]
        let l: CALayer? = cell?.tagImageView.layer
        l?.masksToBounds = true
        l?.cornerRadius = 6.0

        // This will show a translucnt background with a highlighted border.
        //    cell.tagImageView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        l?.borderColor = UIColor.lightText.cgColor
        l?.borderWidth = 2

        //=======================================================================

        // CRITICAL. MUST USE SDWEBIMAGE WITH THIS OPTION: SDWebImageRefreshCached
        // #import <SDWebImage/UIImageView+WebCache.h>

//        cell?.tagImageView.sd_setImage(with: URL(string: propertyPhotoFileUrl), placeholderImage: UIImage(named: "property_placeholder"), options: SDWebImageRefreshCached)

        //=======================================================================

        cell?.backgroundColor = UIColor.clear

        cell?.accessoryType = .detailDisclosureButton
        //    cell.accessoryView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DisclosureIndicator"]];

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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

    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MaintDetailView") {
            let nextViewController = segue.destination as? FullViewController

            nextViewController?.passObjectId = useObjectId
            nextViewController?.passPhotoRef = usePhotoRef
            nextViewController?.passTitle = useTitle
            nextViewController?.passUrl = useUrl
            nextViewController?.passAddress = useAddress
            nextViewController?.passInfo = useInfo
            nextViewController?.passLatitude = useLatitude
            nextViewController?.passLongitude = useLongitude

            nextViewController?.passSubTitle = useSubTitle
            nextViewController?.passCompany = useCompany

            nextViewController?.passAddress2 = useAddress2
            nextViewController?.passCity = useCity
            nextViewController?.passState = useState
            nextViewController?.passZip = useZip
            nextViewController?.passCountry = useCountry

            nextViewController?.passEditMode = "YES"
        }
//        if (segue.identifier == "StatsView") {
//            let nextViewController = segue.destination as? LMViewController
//            nextViewController?.passVisits = visits
//            nextViewController?.passStatsModel = statsArray
//            nextViewController?.passTagTitle = useTitle
//        }
    }
 */

    
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
    
}
