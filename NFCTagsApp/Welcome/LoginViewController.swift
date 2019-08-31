//
//  LoginViewController.swift
//
//  Created by Alex Levy on 5/19/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//


import UIKit
import Parse
//import FacebookLogin
//import FacebookCore
import FBSDKLoginKit  // ADDED FOR FACEBOOK AUG2019


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
    //private let readPermissions: [permissions] = [ .publicProfile, .email ]
    //permissions: ["email", "public_profile", "user_photos"]
    private var fbResultsDict: [AnyHashable : Any] = [:] //STORE USER INFO RETURNED BY FB HERE
    /*
 id
 first_name
 last_name
 middle_name
 name
 name_format
 picture
 short_name
 */
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var emailRegisterButton: UIButton!
    @IBOutlet private weak var userWelcomeLabel: UILabel!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private var textFieldEmail: UITextField!
    @IBOutlet private var textFieldPassword: UITextField!
    @IBOutlet private weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome"
        //kAppDelegate.loggedInFlag = false
        
        //GET THE VERSION INFO FROM THE BUNDLE
        var applicationVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        if (applicationVersion?.count ?? 0) == 0 {
            applicationVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
        }
        
        //    NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        //    NSString *moreDeviceInfo = [NSString stringWithFormat:@"Version:%@ Build:%@",
        //                                applicationVersion, build];
        
        let moreDeviceInfo = "Version:\(applicationVersion ?? "")"
        userWelcomeLabel.text = moreDeviceInfo
        
        //TODO: FIX HeaderLabel
        //    self.userWelcomeLabel.textColor = [UIColor cornflowerColor];
        //    self.headerLabel.textColor = [UIColor cornflowerColor];
        
        //self.headerLabel.textColor = [UIColor cornflowerColor];
        //    NSString *displayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        
        let displayName = "Please Sign In"
        headerLabel.text = displayName

        
        //emailLoginButton.layer.cornerRadius = 20 // this value vary as per your desire
        
//        If you want to use the TintColor as the title Color, the type should be System instead of Custom
        
        let myColor = royalBlue
        //let emailLoginButton = UIButton(type: .custom)
        // IN IB DEFINE BUTTON AS SYSTEM !!!!
        emailLoginButton.backgroundColor = myColor
        emailLoginButton.tintColor = .white
        emailLoginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        emailLoginButton.layer.cornerRadius = emailLoginButton.frame.height/2
        emailLoginButton.layer.masksToBounds = true
        emailLoginButton.clipsToBounds = true
        
        //let facebookLoginButton = UIButton(type: .custom)
        // IN IB DEFINE BUTTON AS SYSTEM !!!!
        facebookLoginButton.backgroundColor = myColor
        facebookLoginButton.tintColor = .white
        facebookLoginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        facebookLoginButton.layer.cornerRadius = facebookLoginButton.frame.height/2
        facebookLoginButton.layer.masksToBounds = true
        facebookLoginButton.clipsToBounds = true
        
        //let emailRegisterButton = UIButton(type: .system)
        // IN IB DEFINE BUTTON AS SYSTEM !!!!
        emailRegisterButton.backgroundColor = .clear
        //Wont Work emailRegisterButton.tintColor = .white
        //Wont Work emailRegisterButton.titleLabel?.textColor = .blue
        //Does Work emailRegisterButton.setTitleColor(UIColor.red, for: .normal)
        emailRegisterButton.setTitleColor(royalBlue, for: .normal)
        emailRegisterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
//        emailLoginButton.layer.cornerRadius = emailLoginButton.frame.height/2
//        emailLoginButton.layer.masksToBounds = true
//        emailLoginButton.clipsToBounds = true
        
        headerLabel.textColor = myColor
        userWelcomeLabel.textColor = myColor
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.isToolbarHidden = true
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        
        
        let backgroundImageName = "art_launch_image"
        backgroundImage.image = UIImage(named: backgroundImageName) // nd-background
        backgroundImage.alpha = 0.4
        backgroundImage.contentMode = .scaleAspectFill
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard)))

        
        
        textFieldEmail.autocorrectionType = .no // NO SPELL CHECK
        textFieldPassword.autocorrectionType = .no
        //textFieldPassword.secure(true)
        
        textFieldEmail.autocapitalizationType = .none
        textFieldPassword.autocapitalizationType = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    
    @IBAction func hideKeyboard() {
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
    }
    
    //EASY TRICK TO DISMISS KEYBOARD
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITextField delegate
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //-------------------------------------------------------------------------------------------------------------------------------------------------
        if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        }
        if textField == textFieldPassword {
            actionLogin()
        }
        return true
    }
    
    // MARK: - User actions
    func actionLogin() {
        var email = textFieldEmail.text?.lowercased()
        var password = textFieldPassword.text
        
        //NSLog(@"EMAIL: %@",email);
        //NSLog(@"PASSWOR: %@",password);
        
        if email == nil {email = ""}
        if password == nil {password = ""}
        
        if (email?.count ?? 0) == 0 {
            displayErrorMessage (message: "Please enter your email.")
            return
        }
        if (password?.count ?? 0) == 0 {
            displayErrorMessage (message: "Please enter your password.")
            return
        }

        //TODO: Swifty ProgressHUD.show("Signing in...", interaction: false)
        let sv = UIViewController.displaySpinner(onView: self.view)
        PFUser.logInWithUsername(inBackground: email ?? "", password: password ?? "") { (user, error) in
            UIViewController.removeSpinner(spinner: sv)
            if user != nil {
                //_useObjectId = user.objectId;
                //NSLog(@"USEROBJECTID: %@",_useObjectId);
                self.userLogged(in: user)
                self.displayErrorMessage (message: "LOGIN SUCCESS")
            } else {
//                ProgressHUD.showError((error as NSError?)?.userInfo["error"])
                self.displayErrorMessage (message: "INVALID EMAIL OR PASSWORD")
            }
        };
    }
    
    // MARK: - User actions
    @IBAction func actionLoginTwitter(_ sender: Any) {
        //    LoginTwitterView *loginTwitterView = [[LoginTwitterView alloc] init];
        //    [self.navigationController pushViewController:loginTwitterView animated:YES];
    }
    
    
    @IBAction func actionLoginEmail(_ sender: Any) {
                bounce(emailLoginButton)
                actionLogin()
    }

    @IBAction func actionRegisterEmail(_ sender: Any) {
                bounce(emailRegisterButton)
                
                let registerViewController = RegisterViewController()
                navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    func goBackButtonPressed() {
        dismiss(animated: true, completion: nil)
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
    //@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
    
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
    
    
//========================================
// MARK: - FACEBOOK LOGIN
//========================================
    //   private let readPermissions: [ReadPermission] = [ .publicProfile, .email, .userFriends, .custom("user_posts") ]
    //Here's the facebook login code, have your login procedure call this:
    //    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    //Some other options: "user_about_me", "user_birthday", "user_hometown", "user_likes", "user_interests", "user_photos", "friends_photos", "friends_hometown", "friends_location", "friends_education_history"


    @IBAction func actionLoginFacebook(_ sender: Any) {
        bounce(facebookLoginButton)
        
        //AccessToken.current = nil //Logout
        logoutFacebook() //If you are logged in, logout
        
        //do login with permissions for email and public profile
        LoginManager().logIn(permissions: ["email","public_profile"], from: nil) {
            (result, error) -> Void in
            //if we have an error display it and abort
            if let error = error {
                print(error.localizedDescription)
                return
            }
            //make sure we have a result, otherwise abort
            guard let result = result else { return }
            //if cancelled nothing todo
            if result.isCancelled { return }
            else {
                //login successfull, now request the fields we like to have in this case first name and last name
                GraphRequest(graphPath: "me", parameters: ["fields" : "first_name, last_name, name, email"]).start() {
                    (connection, result, error) in
                    //if we have an error display it and abort
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    //parse the fields out of the result
                    //self.didLoginWithFacebook()
                    
                    if
                        let fields = result as? [String:Any],
                        let fb_firstName = fields["first_name"] as? String,
                        let fb_lastName = fields["last_name"] as? String,
                        let fb_id = fields["id"] as? String,
                        let fb_name = fields["name"] as? String,
                        let fb_email = fields["email"] as? String
                        //                    id
                        //                    first_name
                        //                    last_name
                        //                    name
                    {
                        print("ID -> \(fb_id)")
                        print("LastName -> \(fb_lastName)")
                        print("FirstName -> \(fb_firstName)")
                        print("Name -> \(fb_name)")
                        
                        // Create a dictionary with the user's Facebook data
                        var facebookId = fb_id
                        facebookId = fb_id.trimmingCharacters(in: CharacterSet.whitespaces)
//                        let name = fb_lastName
//                        let email = fb_email
//                        let firstName = fb_firstName
//                        let lastName = fb_lastName
                        
                        //IMPORTANT TO SAVE THESE VALUES FROM FB FOR USE LATER
                        self.fbResultsDict = [AnyHashable : Any]()
                        self.fbResultsDict["id"] = facebookId
                        self.fbResultsDict["name"] = fb_name
                        self.fbResultsDict["email"] = fb_email
                        self.fbResultsDict["first_name"] = fb_firstName
                        self.fbResultsDict["last_name"] = fb_lastName
                        
                        //LOGOUT. ONLY ONE USER CAN BE LOGGED IN TO FACEBOOK
                        self.logoutFacebook()
                        
                        // LOOK FOR THE facebookId in the PFUser TABLE
                        self.lookupUser(facebookId)
                    }

                }
            }
        }
        
    }
    
//    private func didReceiveFacebookLoginResult(log: L)

//    //STEP1: TRY TO LOGIN TO FACEBOOK. NEED THE UNIQUE FACEBOOKID
//    private func didReceiveFacebookLoginResult(loginResult: Log) {
//        switch loginResult {
//        case .success:
//            didLoginWithFacebook()
//        case .failed(_):
//            displayErrorMessage(message: "FAILED TO LOG IN WITH FACEBOOK")
//                goBackButtonPressed()
//        default:
//            displayErrorMessage(message: "UNABLE TO LOG IN WITH FACEBOOK")
//            goBackButtonPressed()
//        }
//    }

    
    /*
    //STEP2: SUCCESSFULLY LOGGED ITO FACEBOOK
    // GET THE INFORMATION FOR USE LATER IF NECESSAY, SAVE IN fbResultsDict
    // LOOK FOR THE facebookId in the PFUser TABLE
    private func didLoginWithFacebook() {
        // Successful log in with Facebook
        if let accessToken = AccessToken.current {
            let facebookAPIManager = FacebookAPIManager(accessToken: accessToken)
            facebookAPIManager.requestFacebookUser(completion: { (facebookUser) in
                
                if let _ = facebookUser.email {
                    let info = "First nameZ: \(facebookUser.firstName!) \n Last name: \(facebookUser.lastName!) \n Email: \(facebookUser.email!)  \n ID: \(facebookUser.id!)"
                    print(info)
                    //self.displayMessage(message: info)
                    
                    // Create a dictionary with the user's Facebook data
                    var facebookId = facebookUser.id
                    facebookId = facebookId?.trimmingCharacters(in: CharacterSet.whitespaces)
                    let name = facebookUser.lastName
                    let email = facebookUser.email
                    let firstName = facebookUser.firstName
                    let lastName = facebookUser.lastName
                    
                    //IMPORTANT TO SAVE THESE VALUES FROM FB FOR USE LATER
                    self.fbResultsDict = [AnyHashable : Any]()
                    self.fbResultsDict["id"] = facebookId
                    self.fbResultsDict["name"] = name
                    self.fbResultsDict["email"] = email
                    self.fbResultsDict["first_name"] = firstName
                    self.fbResultsDict["last_name"] = lastName

                    // LOOK FOR THE facebookId in the PFUser TABLE
                    self.lookupUser(facebookId)
                    
                }
            })
        }
        AccessToken.current = nil //Logout
    }
    */
    
    //STEP3: FIND AN ENTRY IN PFUser TABLE WITH THIS FACE BOOK ID
    // ONE OF TWO THINGS WILL HAPPEN:
    // (1) YOU FIND IT
    //      USE existingFacebookUserLogin99 TO LOGIN
    // (2) IT DOES NOT EXIST
    //      USE addNewUser88 TO CREATE A NEW ENTRY AND THEN SIGN IN
    // EITHER WAY EXIT OUT OF HERE WHEN YOU ARE DONE
    
    func lookupUser(_ usingFacebookId: String?) {
        let facebookId = usingFacebookId
        //print(facebookId as Any)
        // IF YOU DON'T HAVE A FACEBOOK ID THEN BAIL OUT. THIS SHOULD BE UNLIKELY
        if (facebookId?.count ?? 0) == 0 {
            displayErrorMessage(message: "Cannot find Facebook ID")
            navigationController?.popViewController(animated: true)
            return
        }
        
        //SEE IF A FACEBOOK ENTRY ALREADY EXISTS IN THR USER TABLE !!
        let query = PFQuery(className: "_User")
        query.whereKey("facebookId", equalTo: facebookId!)
        //ProgressHUD.show("", interaction: false)
    
        query.getFirstObjectInBackground {(object: PFObject?, error: Error?) in
            if let object = object {
                // The query succeeded with a matching result
                print("FOUND - USER CURRENTLY EXISTS")
                let email = object["email"] as? String
                let password = object["accountpassword"] as? String
                self.existingFacebookUserLogin99(email, withPassword: password)
            } else {
                print("New Facebook User")
                self.addNewUser88()
            }
        }
    }
    
    func logoutFacebook() {
        if (AccessToken.current != nil) {
            // User is logged in, do work such as go to next view controller.
            print("LOGGING OUT!")
            AccessToken.current = nil
        }
    }
    
    func existingFacebookUserLogin99(_ useLogin: String?, withPassword usePassword: String?) {

        let email = useLogin
        let password = usePassword
        //TODO: HUD PUT BACK  ProgressHUD.show("Signing in...", interaction: false)
        PFUser.logInWithUsername(inBackground: email ?? "", password: password ?? "") { (user, error) in
            if user != nil {
                self.userLogged(in: user)
            } else {
                self.displayErrorMessage(message: "Login Failed")
                //self.goBackButtonPressed()
            }
        };
        
    }

    
    func addNewUser88() {
        let facebookId = fbResultsDict["id"] as? String
        //print (facebookId)
        let name = fbResultsDict["name"] as? String
        let firstName = fbResultsDict["first_name"] as? String
        let lastName = fbResultsDict["last_name"] as? String
        let email =  fbResultsDict["email"] as? String
        
        let password = "facebook" //ALWAYS USE THE WORD facebook for FB Sign-Ups
        
        let user = PFUser()
        user.email = email?.lowercased()
        
        user.username = email
        
        user.password = password
        user[PF_AGENTID] = email ?? "" //MAY2017
        user[PF_USER_EMAIL] = email ?? ""
        user[PF_USER_EMAILCOPY] = email ?? ""
        user[PF_ACCOUNTEMAIL] = email ?? ""
        user[PF_USER_FULLNAME] = name ?? ""
        user[PF_USER_FULLNAME_LOWER] = name?.lowercased() ?? ""
        user[PF_ISAGENTYN] = "NO"
        user[PF_USER_FIRSTNAME] = firstName ?? ""
        user[PF_USER_LASTNAME] = lastName ?? ""
        user[PF_PASSWORD] = password
        user[PF_ACCOUNTPASSWORD] = password
        user[PF_USER_FACEBOOKID] = facebookId ?? ""

        user[PF_USER_PICTURE] = "" //TODO: NEED PICTURE
        user[PF_USER_THUMBNAIL] = "" //TODO: NEED PICTURE

        let sv = UIViewController.displaySpinner(onView: self.view)
        user.signUpInBackground { (success: Bool, error: Error?) in
            UIViewController.removeSpinner(spinner: sv)
            if let error = error {
                print(error.localizedDescription)
                self.displayErrorMessage(message: error.localizedDescription)
                //self.goBackButtonPressed()
            } else {
                print("User Registered successfully")
                self.userLogged(in: user)
            }
        }
    }
    
    // MARK: - Helper methods
    //TODO: FIX THIS
    func userLogged(in user: PFUser?) {
        if (user?[PF_USER_FULLNAME]) != nil {
            //TODO: SWIFTY ProgressHUD.showSuccess("Welcome \(fullname)!")
        }
        
        //kAppDelegate.loggedInFlag = true //CRITICAL!!
        kAppDelegate.isDatabaseDirty = true //FORCE RELOAD WITH NEW USER
        
        kAppDelegate.currentUserEmail = user?[PF_USER_EMAIL] as? String
        kAppDelegate.currentUserName = user?[PF_USER_FULLNAME] as? String
//        kAppDelegate.currentUserFacebookId = user?[PF_USER_FACEBOOKID] as? String
        kAppDelegate.currentUserRole = user?[PF_USER_USERROLE] as? String
        kAppDelegate.currentUserObjectId = user?[PF_USER_AGENTOBJECTID] as? String
        kAppDelegate.currentUserObjectId = user?.objectId
        //TODO: THESE IS AN AGENTOBJECTID IN THE PARSE TABLE BUT IT IS UNUSED
        
        //NOTE: WHEN AN AGENT FIRST CREATES AN ACCOUNT SET THIS TO NO. ONLY WHEN THEY BUT BEACONS ONLINE CAN HILLSIDE STAFF SET THIS MANUALLY IN THE AGENTS TABLE TO 'YES' !!
        kAppDelegate.currentUserIsAgent = false
        
        /*
         //TODO: NOT SURE WHAT THIS IS. TRY TO FIX!
         //CRITICAL. SET NUMBER OF ROWS IN MENU whenever you change kAppDelegate.currentUserIsAgent
         let dict = [
         "ACTION": "EMAILREGISTER"
         ] //CONSTANCE4
         //TODO: SWIFTY PUT BACK !!   NotificationCenter.default.post(name: kREFRESHUSERTABLE, object: nil, userInfo: dict)
         */
        
        //UnwinfToTagListController
        //goBackButtonPressed()
        self.performSegue(withIdentifier: "UnwinfToTagListController", sender: self)

    }
}
    

