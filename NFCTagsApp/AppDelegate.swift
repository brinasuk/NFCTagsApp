
//
//  AppDelegate.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 5/2/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

import UIKit
import Parse
import UserNotifications

import SafariServices
import AVFoundation
import FBSDKCoreKit
import FBSDKLoginKit  // ADDED FOR FACEBOOK AUG2019

import CoreData  //TODO: ALEX TAKE OUT

//import UserNotifications
//fileprivate let pusherSecretKey = "paste you pisher key here"

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {

    var isDarkMode:Bool? = false //NOW SET IN isUsingDarkMode
    
    var hasShoppingCart:Bool? = true
    
    var window: UIWindow?
    
    var appCode:NSString? = "show"  //OR "art" OR "disp" or "re" or "show"

    // APPLICATION WIDE SETTINGS.
    var tagOrBeacon:Bool? = false  //NO = NFC TAG, YES = BEACON
    var sendEmailFlag:Bool? = false  // SEND OWNER LEAD EMAIL NOTIFICATIONS
    var isDatabaseDirty:Bool? = false
    
    // The following are used for SIGN-IN or SIGN_UP
    var currentUserName:String? = ""
    var currentUserEmail:String? = ""
    //var currentUserIsAgent:Bool? = false
    var currentUserRole:String? = ""
    
    //TODO: May have mixed up UserObjectId and AgentObjectId.
    // Replaced all currentAgentObjectId with currentUserObjectId
    //var currentAgentObjectId var :String? = ""
    var currentUserObjectId:String? = ""  // NOT currentAgentObjectId
    var currentDeeplink:String? = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        

        
        // SETTINGS FOR EACH APP. art/re/wine/disp ETC
        
        //NOTE (0) SEARCH FOR 'PRODUCT NAME' AND CHANGE THIS !!!
        //NOTE (1) MANUALY CHANGE BOTH DISPLAY NAME AND BUNDLE IDENTIFIER IN TARGET INFO.PLIST eg artworks4me or besthome4me
        //NOTE (2) MANUALLY CHANGE LAUNCH SCREEN
        //NOTE (3) MANUALLY CHANGE THE FOLLOWING _APPCODE
        /*
         * ART GUYS APP = art; com.hillsidesoftware.artworks4me
         * WINE
         * DISPENSARIES = disp
         * OPEN HOUSES = re; com.hillsidesoftware.besthome4me
         * SHOWROOM = show;
         */

        
        // YOU GET THE APPNAME LATER FROM THE INI BUNDLE
//        let applicationName:String = (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String)!
//        print("App Display Name - \(applicationName)")
        
        
        //        let center = UNUserNotificationCenter.current()
        //        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        //            if let error = error {
        //                print(error.localizedDescription)
        //            }
        //        }
        
        // THE FOLLOWING LINE GIVES: “aps-environment”no valid entitlement string found. REMOVE IT!!!
        //application.registerForRemoteNotifications()
        
        
        //============================================================//
        //NOTE: THIS DOES NOT RUN STAND ALONE ON YOUR iPHONE. DO NOT EVER USE IT!!
//        // HANDLE SENDMAIL KEY
//        guard let myApiKey = ProcessInfo.processInfo.environment["SG_API_KEY"] else {
//            print("ERROR: Unable to retrieve SENDGRID API key")
//            return false
//        }
//        Session.shared.authentication = Authentication.apiKey(myApiKey)
        //============================================================//

        /*
         // PROGRAMMING Settings.bundle
         However, it is important to understand that until the user actually changes the value of the setting nothing is actually set. If you check for the setting in your application it will actually return nil unless you set a default value. To do that add the following to the applicationDidFinishLaunching (or didFinishLaunchingWithOptions) method:
         */
        /*
         //====================================
         // Set the application defaults
         let defaults = UserDefaults.standard
         let appDefaults = ["location" : "YES"]
         if let appDefaults = appDefaults as? [String : Any] {
         defaults.register(defaults: appDefaults)
         }
         defaults.synchronize()
         
         let work: Bool = defaults.bool(forKey: "nfc")
         
         //================================
         let location = UserDefaults.standard.value(forKey: "location") as? [AnyHashable : Any]
         let value = location as? String
         print("Location: \(value ?? "")")
         //================================
         */
        
        
        // PARSE CONFIG
        let configuration = ParseClientConfiguration {
            $0.applicationId = "ibtGE3QDskKpCPPaQEngFdhn7balw7XKvSdH3p0L"
            $0.clientKey = "HX0CRrmHST7g8WzdmYOQhAskYeuKUGS3LmVmffJJ"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        let defaultACL = PFACL()
        // If you would like all objects to be private by default, remove this line.
        defaultACL.hasPublicWriteAccess = true
        defaultACL.hasPublicReadAccess = true
        PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)
        
        //PFAnalytics.trackAppOpened(withLaunchOptions: nil)
        
        
        //================================================//
        // ADDED FOR FACEBOOK
        // ADDED SEPT 2019
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
//        ApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
//        //Optionally add to ensure your credentials are valid:
//        LoginManager.renewSystemCredentials { (result:ACAccountCredentialRenewResult, error:NSError!) -> Void in
        //================================================//
        
        
        //    // CRITICAL: SETUP REALESTATEBEACONS
        //    [ESTConfig setupAppID:@"openhousebeacons" andAppToken:@"95febad595a25c04fd5a80b829b35361"];
        
        
        // SET THE TOOLBAR STYLE
//        let attrs = [
//            NSAttributedString.Key.foregroundColor: UIColor.red,
//            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!
//        ]
//
//        UINavigationBar.appearance().titleTextAttributes = attrs
        
        
        // SET THE TOOLBAR STYLE
        let tabTextColor:UIColor = textColor
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font :  UIFont.systemFont(ofSize: 14.0),
                NSAttributedString.Key.foregroundColor : tabTextColor,
            ], for: .normal)

        //UINAVIGATIONBAR
        //DO NOT PUT THE FOLLOWING CODE IN.
        //IT FORCES A NAV BAR IN EVERY VIEW. YOU DONT WANT THIS IN DETAIL VIEW !!
        
//        let coloredAppearance = UINavigationBarAppearance()
//        coloredAppearance.configureWithOpaqueBackground()
//        coloredAppearance.backgroundColor = .systemGreen
//        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//
//        UINavigationBar.appearance().standardAppearance = coloredAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        
        // SET THE BACK BUTTONS
        let backButtonImage = UIImage(named: "backButton_bold")
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        UINavigationBar.appearance().backgroundColor = .white
        
        
        //        // SET THE BACKBUTTON STYLE
        //        let backButtonImage = UIImage(named: "backButtonNew")
        //        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        //        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        //        UINavigationBar.appearance().backgroundColor = .white
        
        return true
    }
    
    // ADDED FOR FACEBOOK
    func applicationWillResignActive(_ application: UIApplication) {
        //FBSDKAppEvents.activateApp()
    }
    
    // ADDED FOR FACEBOOK (SEE MORE DETAILED BELOW)
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return
            ApplicationDelegate.shared.application(application, open: url as URL, sourceApplication: sourceApplication, annotation: annotation)
        //            ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // ADDED FOR FACEBOOK
    //    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    //        //Even though the Facebook SDK can make this determinitaion on its own,
    //        //let's make sure that the facebook SDK only sees urls intended for it,
    //        //facebook has enough info already!
    //        let isFacebookURL = url.scheme != nil && url.scheme!.hasPrefix("fb\(FBSDKSettings.appID())") && url.host == "authorize"
    //        if isFacebookURL {
    //            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL, sourceApplication: sourceApplication, annotation: annotation)
    //        }
    //        return false
    //    }
    
    
    /*
     func startPushNotifications(){
     UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .carPlay ]) {
     (granted, error) in
     print("Permission granted: \(granted)")
     guard granted else { return }
     self.getNotificationSettings()
     }
     }
     
     func getNotificationSettings() {
     UNUserNotificationCenter.current().getNotificationSettings { (settings) in
     print("Notification settings: \(settings)")
     guard settings.authorizationStatus == .authorized else { return }
     DispatchQueue.main.async {
     // THE FOLLOWING LINE GIVES: “aps-environment”no valid entitlement string found. REMOVE IT!!!
     //UIApplication.shared.registerForRemoteNotifications()
     }
     }
     }
     
     func application(_ application: UIApplication,
     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
     createInstallationOnParse(deviceTokenData: deviceToken)
     }
     
     func application(_ application: UIApplication,
     didFailToRegisterForRemoteNotificationsWithError error: Error) {
     print("Failed to register: \(error)")
     }
     */
    
    //    func createInstallationOnParse(deviceTokenData:Data){
    //        if let installation = PFInstallation.current(){
    //            installation.setDeviceTokenFrom(deviceTokenData)
    //            installation.setObject(["News"], forKey: "channels")
    //            if let userId = PFUser.current()?.objectId {
    //                installation.setObject(userId, forKey: "userId")
    //            }
    //            installation.saveInBackground {
    //                (success: Bool, error: Error?) in
    //                if (success) {
    //                    print("You have successfully saved your push installation to Back4App!")
    //                } else {
    //                    if let myError = error{
    //                        print("Error saving parse installation \(myError.localizedDescription)")
    //                    }else{
    //                        print("Uknown error")
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    // REMOVED FOR FACEBOOK
    //    func applicationWillResignActive(_ application: UIApplication) {
    //        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    //        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    //    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //App activation code
        
        //TODO: PUT BACK (MAYBE) Deeplinker.checkDeepLink()
  
        // MAY BE NEEDED FOR FACEBOOK. SEEMS TO WORK Ok WITHOUT IT
        //AppEvents.activateApp()
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /*
     // MARK: Notificatons
     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
     //        pusher.nativePusher.register(deviceToken: deviceToken)
     //        pusher.nativePusher.subscribe(interestName: "activity")
     }
     
     
     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
     print("failed registration for remote notifications \(error)")
     }
     */
    
    /*
     // RETURNS HERE IF THIS IS A REGISTERED UNIVERSAL LINK
     func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
     let sendingAppID = options[.sourceApplication]
     
     //TODO: THE FOLLOWING IS FOR TESTING ONLY. YOU NEED TO IMPLEMENT THIS
     AudioServicesPlayAlertSound(SystemSoundID(1325))   //FANFARE SOUND !!
     print("SENDINGAPPID: \(String(describing: sendingAppID))")
     //let options = [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : true]
     if URL(string: sendingAppID as! String ) != nil {
     open(scheme: sendingAppID as! String)
     }
     return true
     }
     */
    
    //    func open(scheme: String) {
    //        if let url = URL(string: scheme) {
    //            if #available(iOS 10, *) {
    //                UIApplication.shared.open(url, options: [:],
    //                                          completionHandler: {
    //                                            (success) in
    //                                            print("Open \(scheme): \(success)")
    //                })
    //            } else {
    //                let success = UIApplication.shared.openURL(url)
    //                print("Open \(scheme): \(success)")
    //            }
    //        }
    //    }
    
    
    
    //    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
    //        print("Continue User Activity called: ")
    //        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
    //            let url = userActivity.webpageURL!
    //            print(url.absoluteString)
    //            //handle url and open whatever page you want to open.
    //        }
    //        return true
    //    }
    
    /*
     
     func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
     
     guard userActivity.activityType == NSUserActivityTypeBrowsingWeb else {
     return false
     }
     
     // Confirm that the NSUserActivity object contains a valid NDEF message.
     let ndefMessage = userActivity.ndefMessagePayload //(1)
     
     guard
     let record = ndefMessage.records.first,
     record.typeNameFormat == .absoluteURI || record.typeNameFormat == .nfcWellKnown,
     let payloadText = String(data: record.payload, encoding: .utf8),
     let sku = payloadText.split(separator: "/").last else {
     return false
     }
     print("1SKU: \(sku)")
     

             guard let product = productStore.product(withID: String(sku)) else {
                 return false
             }
     
     guard let navigationController = window?.rootViewController as? UINavigationController else {
     return false
     }
     
     //        navigationController.dismiss(animated: true, completion: nil)
     //        let mainVC = navigationController.topViewController as? TagListViewController
     //mainVC?.presentProductViewController(product: product)
     return true
     }
     */
    
    // DEEPLINKS
    
    /*
     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
     print("failed registration for remote notifications \(error)")
     }
     */
    
    //    // MARK: Notifications
    //    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    //        Deeplinker.handleRemoteNotification(userInfo)
    //    }
    
    
    //    // MARK: Shortcuts
    //    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    //        completionHandler(Deeplinker.handleShortcut(item: shortcutItem))
    //    }
    
    
    //    - (BOOL)application:(UIApplication *)application
    //    openURL:(NSURL *)url
    //
    //    sourceApplication:(NSString *)sourceApplication
    //    annotation:(id)annotation {
    //
    //    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
    //    openURL:url
    //    sourceApplication:sourceApplication
    //    annotation:annotation
    //    ];
    //    // Add any custom logic here.
    //    return handled;
    //    }
    
    /////////////////////////////////////////////////
    // DEEPLINKS //
    /////////////////////////////////////////////////

    
    // MARK: Deeplinks
    //ONE
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        // ADDED FOR FACEBOOK! SEPT 2019. CRITICAL. DO NOT REMOVE!!
        let appId: String = Settings.appID ?? ""// default value
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            return ApplicationDelegate.shared.application(app, open: url, options: options)
        }
        
        //let payloadText = String(data: record.payload, encoding: .utf8),
        //let sku = url.path.split(separator: "/").last
        let urlString: String = url.absoluteString
        
        print("ONE")
        print("OPENURL: \(url.path)")
        print("URL: \(url)")
        print("2urlString: \(String(describing: urlString))")
        //sendEmail(title: "OPENURL", message: url.path)
        //currentDeeplink = String(sku ?? "")
        currentDeeplink = urlString
        //Posting a notification2
        NotificationCenter.default.post(name:  NSNotification.Name("DEEPLINKFOUND"), object: nil)
        //Deeplinker.handleDeeplink(url: url)
        
        
        //ADDED BY ALEX
        // Send the message to `MessagesTableViewController` for processing.
        guard let navigationController = window?.rootViewController as? UINavigationController else {
            return false
        }
        
        navigationController.popToRootViewController(animated: true)
        return true
        
    }
    
    //    //APPCODA TUTORIAL SECTION ON LINKS
    //    - (BOOL)application:(UIApplication *)application
    //    openURL:(NSURL *)url
    //    sourceApplication:(NSString *)sourceApplication
    //    annotation:(id)annotation {
    //    if ([[url path] isEqualToString:@"/reviews"]) {
    //    ReviewViewController *viewController = [[ReviewViewController alloc] init];
    //    viewController.reviewID = [url query];
    //    [self.navigationController pushViewController:viewController animated:NO];
    //    }
    //    return YES;
    //    }
    


    // MARK: Universal Links
    //TWO
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        //        //ADDED BY ALEX
        //        guard let navigationController = window?.rootViewController as? UINavigationController else {
        //            return false
        //        }
        
        // Send the message to `MessagesTableViewController` for processing.
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                // THIS WORKS ON JOSH iPHONE!
                print("CONTINUE ACTIVITY: \(url.path)")
                //let sku = url.path.split(separator: "?").last
                //print("SKU: \(sku.string)")
                let urlString: String = url.absoluteString
//                print("urlString: \(urlString)")
//                // OR
//                var urlString2: String = url.relativeString
//                print("SKU2: \(urlString2)")
//                // OR
//                var urlString3: String = url.relativePath
//                print("SKU3: \(urlString3)")
//                // OR
//                var urlString4: String = url.path
//                print("SKU4: \(urlString4)")
                
                print("TWO")
                print("URL: \(url)")
                print("3URLSTRING: \(String(describing: urlString))")
                //currentDeeplink = String(sku ?? "")
                currentDeeplink = urlString
                NotificationCenter.default.post(name:  NSNotification.Name("DEEPLINKFOUND"), object: nil)
                
                //sendEmail(title: "CONTINUE ACTIVITY", message: url.path)
                
                //Deeplinker.handleDeeplink(url: url)
                //navigationController.popToRootViewController(animated: true)
            }
        }
        return true
    }
    
    //THREE
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb else {
            return false
        }
        
        // Confirm that the NSUserActivity object contains a valid NDEF message.
        let ndefMessage = userActivity.ndefMessagePayload //(2)
        
        guard ndefMessage.records.count > 0,
            ndefMessage.records[0].typeNameFormat != .empty else {
                return false
        }
        
        guard
            let record = ndefMessage.records.first,
            record.typeNameFormat == .absoluteURI || record.typeNameFormat == .nfcWellKnown,
            let payloadText = String(data: record.payload, encoding: .utf8),
            let sku = payloadText.split(separator: "/").last else {
                return false
        }
        print("THREE")
        print("NDEFMESSAGE: \(ndefMessage)")
        print("4SKU: \(sku)")
        print("PAYLOADTEXT: \(payloadText)")
        //sendEmail(title: "PAYLOADTEXT", message: payloadText)
        currentDeeplink  = String(payloadText)
        NotificationCenter.default.post(name:  NSNotification.Name("DEEPLINKFOUND"), object: nil)
        
        //     // Send the message to `MessagesTableViewController` for processing.
        //     guard let navigationController = window?.rootViewController as? UINavigationController else {
        //     return false
        //     }
        
        //     navigationController.popToRootViewController(animated: true)
        //     let messageTableViewController = navigationController.topViewController as? MessagesTableViewController
        //     messageTableViewController?.addMessage(fromUserActivity: ndefMessage)
        
        return true
    }


    /*
     //NOTE: HUGE BUG. SENDGRID DOES NOT WORK WITH PARSE ON AN iPHONE
     //NOTE: THIS DOES NOT RUN STAND ALONE ON YOUR iPHONE. DO NOT EVER USE IT!!
     private func sendgridEmail(title: String, message:String) {
        let personalization = Personalization(recipients: "alex@hillsoft.com")
        //        let plainText = Content(contentType: ContentType.plainText, value: "Well Done, VIGE!")
        let htmlText = Content(contentType: ContentType.htmlText, value: message)
        let email = Email(
            personalizations: [personalization],
            from: "support@hillsoft.com",
            content: [htmlText],
            subject: title
        )
        do {
            try Session.shared.send(request: email)
            //print("Hopefully sent")
            AudioServicesPlayAlertSound(SystemSoundID(1303))   //1303 MAIL SENT  //VIBRATE 4095
        } catch {
            print(error)
        }
    }
 */
    
/*
    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?
        ) -> Void) -> Bool {
        
        // 1
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return false
        }
        
//        // 2
//        if let computer = ItemHandler.sharedInstance.items
//            .filter({ $0.path == components.path}).first {
//            presentDetailViewController(computer)
//            return true
//        }
        
        // 3
        if let webpageUrl = URL(string: "http://rw-universal-links-final.herokuapp.com") {
            application.open(webpageUrl)
            return false
        }
        
        return false
    }
  */
    
    // MARK: - Split view
/*
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? NoteDetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
 */

//    // MARK: - Core Data stack
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//         */
//        let container = NSPersistentContainer(name: "ReallySimpleNotesData")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }

}
