//  Converted to Swift 5.1 by Swiftify v5.1.33867 - https://objectivec2swift.com/
//
//  ViewController.swift
//  CollectViewTest
//
//  Created by Michael Henry Pantaleon on 2/08/2014.
//  Copyright (c) 2014 Michael Henry Pantaleon. All rights reserved.
//

import UIKit
import Parse

class NewBeaconViewController: UIViewController, MHYahooParallaxViewDatasource, MHYahooParallaxViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    var imageHeaderHeight: CGFloat = 0.0
    var imageHeaderWidth: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ToDo"

        setupDarkMode()
        setupNavigationBar()
        //loadDanielObjects()
        danielParseQuery()
        
        

        imageHeaderHeight = view.frame.size.height * 0.70
        imageHeaderWidth = view.frame.size.width

        let parallaxView = MHYahooParallaxView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height))
        
//TODO        parallaxView.register(MHTsekotCell.self, forCellWithReuseIdentifier: MHTsekotCell.reuseIdentifier ?? "")
        parallaxView.register(MHTsekotCell.self, forCellWithReuseIdentifier: "ALEX")
        
        parallaxView.delegate = self
        parallaxView.datasource = self
        view.addSubview(parallaxView)

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func  setupDarkMode() {
        if  (kAppDelegate.isDarkMode == true)
            {if #available(iOS 13.0, *) {overrideUserInterfaceStyle = .dark}
        } else
            {if #available(iOS 13.0, *) {overrideUserInterfaceStyle = .light}
        }
    }

        func setupNavigationBar() {
            navigationController?.navigationBar.prefersLargeTitles = false

            if #available(iOS 13.0, *) {
                let navBarAppearance = UINavigationBarAppearance()
                //navBarAppearance.configureWithDefaultBackground()
                navBarAppearance.configureWithOpaqueBackground()

                navBarAppearance.titleTextAttributes = [.foregroundColor: titleTextColor]
                navBarAppearance.largeTitleTextAttributes = [.foregroundColor: titleLargeTextColor]
                navBarAppearance.backgroundColor = navbarBackColor //<insert your color here>

                //navBarAppearance.backgroundColor = navbarBackColor
                navBarAppearance.shadowColor = nil
                navigationController?.navigationBar.isTranslucent = false
                navigationController?.navigationBar.standardAppearance = navBarAppearance
                navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

                navigationController?.navigationBar.barTintColor = navbarBackColor
    //            navigationController?.navigationBar.tintColor =  navbarBackColor
    //            self.navigationController!.navigationBar.titleTextAttributes =
    //            [NSAttributedString.Key.backgroundColor: navbarBackColor]

                } else {

                //METHOD2. NOT iOS13
                if let customFont = UIFont(name: "Rubik-Medium", size: 34.0) {
                    navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor .darkText, NSAttributedString.Key.font: customFont ]
                    }
                }
        }

// MARK: - ParallaxView Datasource and Delegate
    @objc func parallaxView(_ parallaxView: MHYahooParallaxView?, cellForRowAt indexPath: IndexPath?) -> UICollectionViewCell? {
        
//TODO        let tsekotCell = parallaxView?.dequeueReusableCell(withReuseIdentifier: MHTsekotCell.reuseIdentifier, for: indexPath) as? MHTsekotCell
        
        let tsekotCell = (parallaxView?.dequeueReusableCell(withReuseIdentifier: "ALEX", for: indexPath!)) as? MHTsekotCell
        
        tsekotCell?.delegate = self
        tsekotCell?.datasource = self
        tsekotCell?.tsekotTableView?.tag = indexPath?.row ?? 0
        tsekotCell?.tsekotTableView?.contentOffset = CGPoint(x: 0.0, y: 0.0)
        tsekotCell?.tsekotTableView?.reloadData()

        return tsekotCell
    }

    @objc func numberOfRows(in parallaxView: MHYahooParallaxView?) -> Int {
        return 10
    }

    @objc func parallaxViewDidScrollHorizontally(_ parallaxView: MHYahooParallaxView?, leftIndex: Int, leftImageLeftMargin: CGFloat, leftImageWidth: CGFloat, rightIndex: Int, rightImageLeftMargin: CGFloat, rightImageWidth: CGFloat) {

        // leftIndex and Right Index should must be greater than or equal to zero

        if leftIndex >= 0 {
            let leftCell = parallaxView?.cellForItem(at: IndexPath(item: leftIndex, section: 0)) as? MHTsekotCell
            let tvCell = leftCell?.tsekotTableView?.cellForRow(at: IndexPath(item: 0, section: 0))

            let iv = tvCell?.viewWithTag(100) as? UIImageView
            var frame = iv?.frame
            frame?.origin.x = leftImageLeftMargin
            frame?.size.width = leftImageWidth
            iv?.frame = frame ?? CGRect.zero
        }
        if rightIndex >= 0 {
            let rigthCell = parallaxView?.cellForItem(at: IndexPath(item: rightIndex, section: 0)) as? MHTsekotCell
            let tvCell = rigthCell?.tsekotTableView?.cellForRow(at: IndexPath(item: 0, section: 0))

            let iv = tvCell?.viewWithTag(100) as? UIImageView
            var frame = iv?.frame
            frame?.origin.x = rightImageLeftMargin
            frame?.size.width = rightImageWidth
            iv?.frame = frame ?? CGRect.zero
        }
    }
    
//    func loadInfo () {
//         // ALEX PARSE QUERY TEST
//         // USED TO DEBUG ANDROID !!
//
//         //  Converted to Swift 5.2 by Swiftify v5.2.18840 - https://objectivec2swift.com/
//         let usePropertyObjectID = "2GGAZHLU7a"
//
//         //PFQuery *myQuery = [BeaconItem query];
//
//        //let query = PFQuery(className: "TagOwnerInfo")
//        //query.whereKey("ownerId", equalTo: tag )
//
//         let myQuery = PFQuery(className: "Beacons")
//         myQuery.includeKey("propertyPointer")
//         myQuery.whereKey("propertyPointer", equalTo: PFObject(withoutDataWithClassName: "Properties", objectId: usePropertyObjectID))
//        myQuery.findObjectsInBackground(block: {objects, error in
//
//         //myQuery.findObjectsInBackground(withBlock: { objects, error in
//             if error == nil {
//                 var beaconObjectId: String?
//                 var beaconId: String?
//                 var beaconTitle: String?
//                 let propertyAddress: String? = nil
//                 let i = 0
//
//                 //for (BeaconItem *beaconObject  in objects) {
//                 for myObject in objects ?? [] {
//                     guard let myObject = myObject as? PFObject else {
//                         continue
//                     }
//                     beaconObjectId = objects?[i] as? String
//                     beaconTitle = (objects?[i] as? [AnyHashable : Any])?["beaconTitle"] as? String
//                     beaconId = myObject["beaconID"] as? String
//                     //NSLog(@"Beacon Title: %@",beaconTitle);
//                     print("Beacon ID: \(beaconId ?? "")")
//                     i += 1
//                     //BeaconListItem *item;
//                     //item = [[BeaconListItem alloc] init];
//                     //item.beaconTitle = beaconObject.beaconTitle;
//                     //item.beaconObjectID = beaconObject.objectId; //Sept DO NOT TAKE OUT !!
//                 }
//             }
//         })
//    }


// MARK: - TableView Datasource and Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return imageHeaderHeight
        }
        return 568.0
    }

    static let tableViewHeaderId = "headerCell"
    static let tableViewDetailId = "detailCell"

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: NewBeaconViewController.tableViewHeaderId)
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: NewBeaconViewController.tableViewHeaderId)
                cell?.backgroundColor = UIColor.clear
                
                //TODO: REMOVED cell?.contentView.frame.size.width ?? 0.0
                let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: imageHeaderWidth, height: imageHeaderHeight))
                //TODO Removed ?
                imageView.contentMode = .center
                imageView.tag = IMAGE_VIEW_TAG
                imageView.clipsToBounds = true
                imageView.autoresizingMask = .flexibleHeight
                let svImage = UIScrollView(frame: imageView.frame)
                svImage.delegate = self
                svImage.isUserInteractionEnabled = false

                svImage.addSubview(imageView)

                svImage.tag = IMAGE_SCROLL_VIEW_TAG
                svImage.backgroundColor = UIColor.red
                svImage.zoomScale = 1.0
                svImage.minimumZoomScale = 1.0
                svImage.maximumZoomScale = 2.0
                cell?.contentView.addSubview(svImage)
                
                let headerInfo = UIImageView(image: UIImage(named: "header_bg"))
                cell?.contentView.addSubview(headerInfo)

                var headerFrame = headerInfo.frame
                headerFrame.size.width = imageHeaderWidth
                headerFrame.size.height = 149.0
                headerFrame.origin.y = imageHeaderHeight - 149.0
                headerInfo.frame = headerFrame
            }

            let imageView = cell?.viewWithTag(IMAGE_VIEW_TAG) as? UIImageView
            imageView?.image = UIImage(named: String(format: "subaru-%i.jpg", tableView.tag))
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: NewBeaconViewController.tableViewDetailId)
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: NewBeaconViewController.tableViewDetailId)
                let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: 568.0))
                //TODO: REMOVED ?
                imageView.tag = CONTENT_IMAGE_VIEW_TAG
                cell?.contentView.addSubview(imageView)
            }
            let imageView = cell?.viewWithTag(CONTENT_IMAGE_VIEW_TAG) as? UIImageView
            imageView?.image = UIImage(named: String(format: "content-%i", (tableView.tag % 3) + 1))
        }

        return cell!
    }

// MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == IMAGE_SCROLL_VIEW_TAG {
            return
        }
        let tv = scrollView as? UITableView
        let cell = tv?.cellForRow(at: IndexPath(item: 0, section: 0))
        let svImage = cell?.viewWithTag(IMAGE_SCROLL_VIEW_TAG) as? UIScrollView
        var frame = svImage?.frame
        frame?.size.height = max((imageHeaderHeight - (tv?.contentOffset.y ?? 0.0)), 0)
        //frame?.size.width = imageHeaderWidth //TODO: Added by Alex
        frame?.origin.y = tv?.contentOffset.y ?? 0.0
        svImage?.frame = frame ?? CGRect.zero
        //TODO: FORCED !
        NSLog("%@","SCROLL")
        
        svImage?.zoomScale = 1 + (abs(min((tv?.contentOffset.y)!, 0)) / imageHeaderWidth)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.viewWithTag(IMAGE_VIEW_TAG)
    }
}
    
              func loadDanielObjects()
                {
                   //var beaconObjectId: String?
                   var beaconId: String?
                   //var beaconTitle: String?
                   var i = 0
                   var propertyAddress: String? = nil
                   
                   var propertyObjectId: String?
                   var objectID: String?
                   var agentID: String?
                   var ownerID: String?

                   let usePropertyObjectID = "2GGAZHLU7a"
                   let myQuery = PFQuery(className: "Beacons")
                   myQuery.includeKey("propertyPointer")
   //                 myQuery.whereKey("propertyPointer", equalTo: PFObject(withoutDataWithClassName: "Properties", objectId: usePropertyObjectID))

//                    let sv = UIViewController.displaySpinner(onView: self.view)
                    
                    myQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                        
                        if let error = error {
                            //UIViewController.removeSpinner(spinner: sv)
                            // Log details of the failure
                            print(error.localizedDescription)
                        } else if let objects = objects {
                            // The find succeeded.
                           print("Successfully retrieved \(objects.count) OWNER objects.")
                            // Do something with the found objects
                            
                           //for (BeaconItem *beaconObject  in objects) {
                           
   //                        //  Converted to Swift 5.2 by Swiftify v5.2.18840 - https://objectivec2swift.com/
   //                        for beaconObject in objects {
   //                            var item: BeaconListItem?
   //                            item = BeaconListItem()
   //                            item?.beaconTitle = beaconObject.beaconTitle
   //                            item?.beaconObjectID = beaconObject.objectId //Sept DO NOT TAKE OUT !!
   //                            //NSLog(@"TITLE==>>: %@",item.beaconTitle);
   //                            //NSLog(@"BEACONOBJECTID==>>: %@",item.beaconObjectID);
   //                            if let beaconTitle = item?.beaconTitle {
   //                                beaconTitles.append(beaconTitle)
   //                            } // Was beaconName
   //                            if let beaconObjectID = item?.beaconObjectID {
   //                                beaconObjectIds.append(beaconObjectID)
   //                            } // DO NOT TAKE OUT!
   //                        }

                           
                           for myObject in objects {
                               
                               print (myObject)
                               


                               
                               //  Converted to Swift 5.2 by Swiftify v5.2.18840 - https://objectivec2swift.com/
                               //                propertyObjectId: "",
                               //                objectID: "",
                               //                agentID: "",
                               //                ownerID: ""
   //                            let useProperty = myObject[i] as? PropertyModel
   //                            objectID = useProperty?.objectId
   //                            let propertyAddress = useProperty?.address
   //                            let propertyID = useProperty?.propertyID
                               
   //                            let createdAt:Date = myObject.createdAt!
   //                            let ownerObjectId:String = myObject.objectId! //Used for Photo Name

   //                            beaconObjectId = objects[i] as? String
   //                            beaconTitle = (objects[i] as? [AnyHashable : Any])?["beaconTitle"] as? String
                               beaconId = myObject["beaconID"] as? String
                               propertyAddress = myObject["propertyAddress"] as? String
                               //TODO: SEE HERE HOW IT IS DONE
                               let alex = myObject["priceraw"] as? String ?? ""
                               //NSLog(@"Beacon Title: %@",beaconTitle);
                               print("Beacon ID: \(beaconId ?? "")")
                               print("Address: \(propertyAddress ?? "")")
                               print("ALEX: \(alex)")
                               i += 1
                               
                               //BeaconListItem *item;
                               //item = [[BeaconListItem alloc] init];
                               //item.beaconTitle = beaconObject.beaconTitle;
                               //item.beaconObjectID = beaconObject.objectId; //Sept DO NOT TAKE OUT !!
                           }
                           
                        }
                        
                        //RUN ON MAIN THREAD
                        DispatchQueue.main.async {
                            //self.tableView.reloadData()
                            //UIViewController.removeSpinner(spinner: sv)
                        }
                    }
                }



    func danielParseQuery() {
         let beaconObjectID = "GGWMPvkE58" //sUyZkK3vVg"
         //NSLog(@"BeaconObjectID: %@",beaconObjectID);
        let query = PFQuery(className: "Beacons")
         //PFQuery query = [PFQuery queryWithClassName:@"Beacons"];
         //let query = BeaconItem.query()
         query.includeKey("ownerPointer")
         query.includeKey("agentPointer")
         query.includeKey("propertyPointer")
        
        
        query.getObjectInBackground(withId: beaconObjectID) { (object: PFObject?, error: Error?) in
            if let error = error {
                

            } else {
                
                //USE  let alex = object["ownerPhone"] as? String ?? “” and avoid NIL testing !!!!!
                
                var sponsorName = object?.value(forKeyPath: "ownerPointer.sponsorName") as? String
                var useBeaconName = object?.value(forKey: "beaconName") as? String
                var address = object?.value(forKeyPath: "propertyPointer.address")
                print("SponsorName: \(sponsorName)")
                print("useBeaconName: \(useBeaconName)")
                print("address: \(address)")
            
                
                
                               /*
                                 agent = AgentItem()
                                 property = PropertyItem()
                                 owner = OwnerItem()

                                 owner?.ownerObjectID = object?.value(forKeyPath: "ownerPointer.objectId")
                                 agent?.agentObjectID = object?.value(forKeyPath: "agentPointer.objectId")
                                 //TODO: ALEX THIS IS A BUG!! _property.objectID = [object valueForKeyPath:@"agentPointer.objectId"];
                                 property?.objectID = object?.value(forKeyPath: "propertyPointer.objectId")


                                 self.usePropertyObjectID = object?.value(forKeyPath: "propertyPointer.objectId") as? String
                                
                                 //NSLog(@"usePropertyObjectID-1: %@",_usePropertyObjectID); //PROPERTY OBJECTID !!

                                 //            NSLog(@"Beacon PRIMARY KEY: %@", [object valueForKey:@"objectId"]);
                                 //            NSLog(@"Owner PRIMARY KEY: %@", _owner.ownerObjectID);
                                 //            NSLog(@"Agent PRIMARY KEY: %@", _agent.agentObjectID);
                                 //            NSLog(@"Property PRIMARY KEY: %@", _property.objectID);

                                 // PULL THE FOLLOWING FROM THE OWNER INFO TABLE
                                 sponsorName = object?.value(forKeyPath: "ownerPointer.sponsorName") as? String
                                 sponsorLink = object?.value(forKeyPath: "ownerPointer.sponsorLink") as? String
                                 sponsorEmail = object?.value(forKeyPath: "ownerPointer.sponsorEmail") as? String



                                 // AGENT INFO
                                 agent?.objectId = object?.value(forKeyPath: "agentPointer.objectId")
                                 agent?.agentID = object?.value(forKeyPath: "agentPointer.agentID") //ADDED JUNE2016 MORTGAGE CALCULATOR
                                 agent?.agentNumericID = object?.value(forKeyPath: "agentPointer.agentNumericID")
                                 agent?.ownerID = object?.value(forKeyPath: "agentPointer.ownerID")
                                 agent?.agentEmail = object?.value(forKeyPath: "agentPointer.agentEmail")
                   
                                 //BE CAREFUL - PHOTOCOUNT is now NUMERIC
                                 let myNumber = object?.value(forKeyPath: "propertyPointer.photoCount") as? NSNumber
                                 if let myNumber = myNumber {
                                     property?.photocount = "\(myNumber)"
                                 }

                                 property?.agentID = object?.value(forKeyPath: "propertyPointer.agentID")
                                 property?.ownerID = object?.value(forKeyPath: "propertyPointer.ownerID")
                                 property?.status = object?.value(forKeyPath: "propertyPointer.status")
                                 property?.seq = object?.value(forKeyPath: "propertyPointer.seq")

                                 property?.mainPhoto = object?.value(forKeyPath: "propertyPointer.mainPhoto")
                                 property?.dom = object?.value(forKeyPath: "propertyPointer.dom")
                                 property?.priceraw = object?.value(forKeyPath: "propertyPointer.priceraw")
                                 property?.listDate = object?.value(forKeyPath: "propertyPointer.listDate")

                                 property?.pricenum = object?.value(forKeyPath: "propertyPointer.pricenum")
                                 property?.bedsnum = object?.value(forKeyPath: "propertyPointer.bedsnum")
                                 property?.bathsnum = object?.value(forKeyPath: "propertyPointer.bathsnum")
                                 property?.sqftnum = object?.value(forKeyPath: "propertyPointer.sqftnum")
                                 property?.community = object?.value(forKeyPath: "propertyPointer.community")

                                 property?.address = object?.value(forKeyPath: "propertyPointer.address")

                                   // APRIL 2017. NO LONGER PASS THIS INFO INTO THIS CONTROLLER. GET IT HERE
                                 self.useBeaconMajorMinorID = object?.value(forKey: "majorMinorID") as? String
                                 self.useBeaconTitle = object?.value(forKey: "beaconTitle") as? String
                                 self.useBeaconName = object?.value(forKey: "beaconName") as? String
                                 self.useBeaconStatus = object?.value(forKey: "status") as? String
                */
            }
        }
        
}




