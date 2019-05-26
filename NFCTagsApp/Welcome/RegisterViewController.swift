//
//  RegisterViewController.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 5/19/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

//import Foundation
import Parse
//import QuartzCore
import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet private var textFieldName: UITextField!
    @IBOutlet private var textFieldEmail: UITextField!
    @IBOutlet private var textFieldPassword: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet private weak var headerLabel: UILabel!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Email SignUp"
        registerButton.layer.cornerRadius = 20
        registerButton.clipsToBounds = true
        
        //self.headerLabel.textColor = [UIColor cornflowerColor];
        //    NSString *displayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        let displayName = "Please Sign Up"
        headerLabel.text = displayName
        headerLabel.textColor = UIColor.white
        
        
        //TODO: BACKBUTTONS AND NAVIGATION AND BARBUTTONS SHOULD BE SET IN APPDELEGATE
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        //    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Terms of Use" style:UIBarButtonItemStylePlain target:self action:@selector(displayTermsAndConditions)];
        //    self.navigationItem.rightBarButtonItem = rightButton;
        

        navigationController?.isToolbarHidden = true
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        
        
        backgroundImage.image = UIImage(named: "art_launch_image") // nd-background
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard)))
        //gestureRecognizer.cancelsTouchesInView = NO;
        
        
        textFieldEmail.autocorrectionType = .no // NO SPELL CHECK
        textFieldName.autocorrectionType = .no
        textFieldPassword.autocorrectionType = .no
        
        textFieldEmail.autocapitalizationType = .none
        textFieldName.autocapitalizationType = .words
        textFieldPassword.autocapitalizationType = .none
        
        let myColor = royalBlue
        //let emailLoginButton = UIButton(type: .custom)
        // IN IB DEFINE BUTTON AS SYSTEM !!!!
        registerButton.backgroundColor = myColor
        registerButton.tintColor = .white
        registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        registerButton.layer.cornerRadius = registerButton.frame.height/2
        registerButton.layer.masksToBounds = true
        registerButton.clipsToBounds = true

        //let emailLoginButton = UIButton(type: .custom)
        // IN IB DEFINE BUTTON AS SYSTEM !!!!
        cancelButton.backgroundColor = myColor
        cancelButton.tintColor = .white
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.layer.masksToBounds = true
        cancelButton.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //[_textFieldName becomeFirstResponder];
    }
    
    @IBAction func hideKeyboard() {
        textFieldName.resignFirstResponder()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldName {
            textFieldEmail.becomeFirstResponder()
        }
        if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        }
        if textField == textFieldPassword {
            actionRegister()
        }
        return true
    }
    
    
    @IBAction func registerButtonPressed(_ sender: Any) {
                bounce(registerButton)
                actionRegister()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        goBackButtonPressed()
    }
    
    // MARK: - User actions
    func actionRegister() {
        var name = textFieldName.text
        let email = textFieldEmail.text?.lowercased()
        let password = textFieldPassword.text
        //---------------------------------------------------------------------------------------------------------------------------------------------
        if (name?.count ?? 0) == 0 {
            displayErrorMessage (message: "Please enter your Name.")
            return
        }
        if (email?.count ?? 0) == 0 {
            displayErrorMessage (message: "Please enter your Email.")
            return
        }
        if (password?.count ?? 0) == 0 {
            displayErrorMessage (message: "Please enter your Password.")
            return
        }
        
        let user = PFUser()
        user.email = email
        user.username = email
        user.password = password
        user[PF_AGENTID] = email ?? "" //MAY2017
        user[PF_USER_EMAIL] = email ?? ""
        user[PF_USER_EMAILCOPY] = email ?? ""
        user[PF_ACCOUNTEMAIL] = email ?? ""
        user[PF_USER_FULLNAME] = name ?? ""
        user[PF_USER_FULLNAME_LOWER] = name?.lowercased() ?? ""
        user[PF_ISAGENTYN] = "NO"

        
        
        // Remove Trailing Spaces
        name = name?.trimmingCharacters(in: CharacterSet.whitespaces)
        var firstName:String = ""
        var lastName:String = ""
        
        if (name?.count ?? 0) > 0 {
            
            //TODO: PUT BACK !!!
                        let fullNameArray = name?.components(separatedBy: " ")
                        firstName = fullNameArray?[0] ?? "First"
                        let lastPos: Int = (fullNameArray?.count ?? 0) - 1
                        if lastPos > 0 {
                            lastName = fullNameArray?[lastPos] ?? "Last"
                        } else {
                            lastName = ""
                        }
        }
        
        user[PF_USER_FIRSTNAME] = firstName
        user[PF_USER_LASTNAME] = lastName
        user[PF_ACCOUNTPASSWORD] = password ?? ""
        
        user[PF_USER_FACEBOOKID] = ""
        user[PF_USER_PICTURE] = ""
        user[PF_USER_THUMBNAIL] = ""

        //let sv = UIViewController.displaySpinner(onView: self.view)
        user.signUpInBackground { (success, error) in
            //UIViewController.removeSpinner(spinner: sv)
            if success{
                self.userLogged(in: user)
            }else{
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: descrip)
                }
            }
        }
        
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
    
    
    // MARK: - Helper methods
    func userLogged(in user: PFUser?) {
        if (user?[PF_USER_FULLNAME]) != nil {
            //TODO: SWIFTY ProgressHUD.showSuccess("Welcome \(fullname)!")
        }

         //TODO: SWIFTY PUT BACK
        kAppDelegate.loggedInFlag = true //TODO: FIX
        kAppDelegate.currentUserEmail = user?[PF_USER_EMAIL] as? String
        kAppDelegate.currentUserName = user?[PF_USER_FULLNAME] as? String
        kAppDelegate.currentUserFacebookId = user?[PF_USER_FACEBOOKID] as? String
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
        
        //goBackButtonPressed()

        
        navigationController?.popToRootViewController(animated: true)
        
        //    [self dismissViewControllerAnimated:YES completion:^{
        //        PostNotification(NOTIFICATION_USER_LOGGED_IN);
        //    }];
    }
    
    func goBackButtonPressed() {
        //navigationController?.popViewController(animated: true)
        //navigationController?.popToRootViewController(animated: true)
        //[self dismissViewControllerAnimated:YES completion:nil];
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

}
