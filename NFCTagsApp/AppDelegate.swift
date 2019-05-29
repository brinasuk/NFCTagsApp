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
//import FBSDKLoginKit  // ADDED FOR FACEBOOK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //NOTE (0) SEARCH FOR 'PRODUCT NAME' AND CHANGE THIS !!!
    //NOTE (1) MANUALY CHANGE BOTH DISPLAY NAME AND BUNDLE IDENTIFIER IN TARGET eg artworks4me or besthome4me
    //NOTE (2) MANUALLY CHANGE LAUNCH SCREEN
    //NOTE (3) MANUALLY CHANGE THE FOLLOWING _APPCODE
    /*
     * ART GUYS APP = art; com.hillsidesoftware.artworks4me
     * DISPENSARIES = disp
     * OPEN HOUSES = re; com.hillsidesoftware.besthome4me
     * SHOWROOM = show;
     */
    
    var window: UIWindow?
    
    var theVige:NSString? = "ALEX"
    var appCode:NSString? = "art"  //OR "art" OR "disp" or "re" or "show"
    var appName:NSString? = ""
    var tagOrBeacon:Bool? = false  //NO = NFC TAG, YES = BEACON
    var sendEmailFlag:Bool? = false  // SEND OWNER LEAD EMAIL NOTIFICATIONS
    
    
    // NEED THE FOLLOWING WHEN YOU SIGN-IN or SIGN_UP /////////////////
    var currentUserName:String? = ""
    var currentUserEmail:String? = ""
    
    var loggedInFlag:Bool? = false
    var currentUserIsAgent:Bool? = false
    
    var currentUserFacebookId:String? = ""
    var currentUserRole:String? = ""
    //TODO: May have mixed up UserObjectId and AgentObjectId. Changed all to User
    //var currentAgentObjectIdvar :String? = ""
    var currentUserObjectId:String? = ""
    ///////////////////////////////////////////////////////////////////
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        
        if (appCode == "art") {
            appName = "ArtWorks4Me";
        }
        if (appCode == "re") {
            appName = "BestHome4Me";
        }
        if (appCode == "disp") {
            appName = "Dispensaries";
        }
        if (appCode == "show") {
            appName = "Showrooms";
        }
        
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
        
        if (appCode == "art") {
            appName = "ArtWorks4Me"
        }
        if (appCode == "re") {
            appName = "BestHome4Me"
        }
        if (appCode == "disp") {
            appName = "Dispensaries"
        }
        if (appCode == "show") {
            appName = "Showrooms"
        }
        
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
//     FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        //Optionally add to ensure your credentials are valid:
//        FBSDKLoginManager.renewSystemCredentials { (result:ACAccountCredentialRenewResult, error:NSError!) -> Void in
        //================================================//

        
        //    // CRITICAL: SETUP REALESTATEBEACONS
        //    [ESTConfig setupAppID:@"openhousebeacons" andAppToken:@"95febad595a25c04fd5a80b829b35361"];
        
        /*
        UIToolbar.appearance().setShadowImage(UIImage(named: "ShadowUp"), forToolbarPosition: UIToolbarPositionBottom)
        
        
        //=============================
        //     For those interested in using UIAppearance to style their UIBarButtonItem's fonts throughout the app, it can be accomplished using this line of code:
        let buttonTintColor: UIColor? = MegaTheme.newToolbarTextColor()
        //UIColor *buttonTintColor = [UIColor paleRoseColor];
        
        var barButtonAppearanceDict: [NSAttributedString.Key : UIFont]? = nil
        if let buttonTintColor = buttonTintColor {
            barButtonAppearanceDict = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0),
                NSAttributedString.Key.foregroundColor: buttonTintColor
            ]
        }
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAppearanceDict, for: .normal)
        
        
        var useTintColor = UIColor(red: 140 / 255.0, green: 70 / 255.0, blue: 35 / 255.0, alpha: 1.0)
        useTintColor = UIColor.green
        
        //TODO: NOT WORKING. TAKE OUT?
        UINavigationBar.appearance().tintColor = useTintColor
        UITabBar.appearance().barTintColor = useTintColor
        
        
        //    var navigationBarAppearace = UINavigationBar.appearance()
        //    navigationBarAppearace.tintColor = uicolorFromHex(0xffffff)
        //    navigationBarAppearace.barTintColor = uicolorFromHex(0x034517)
 */
        
        let backButtonImage = UIImage(named: "back")
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        
        return true
    }
    // ADDED FOR FACEBOOK
    func applicationWillResignActive(_ application: UIApplication) {
        //FBSDKAppEvents.activateApp()
    }
    
//    // ADDED FOR FACEBOOK (SEE MORE DETAILED BELOW)
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//    }
    
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
                UIApplication.shared.registerForRemoteNotifications()
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
    
    func createInstallationOnParse(deviceTokenData:Data){
        if let installation = PFInstallation.current(){
            installation.setDeviceTokenFrom(deviceTokenData)
            installation.setObject(["News"], forKey: "channels")
            if let userId = PFUser.current()?.objectId {
                installation.setObject(userId, forKey: "userId")
            }
            installation.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    print("You have successfully saved your push installation to Back4App!")
                } else {
                    if let myError = error{
                        print("Error saving parse installation \(myError.localizedDescription)")
                    }else{
                        print("Uknown error")
                    }
                }
            }
        }
    }
    
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
        
        // ADDED FOR FACEBOOK
        //FBSDKAppEvents.activateApp()
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
