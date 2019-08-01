//  Converted to Swift 5 by Swiftify v5.0.39155 - https://objectivec2swift.com/
//
//  ViewController.swift
//  Tap2View
//
//  Created by Alex Levy on 11/12/17.
//  Copyright © 2017 Hillside Software. All rights reserved.
//

import UIKit
import Parse
//import AXWireButton
import CoreNFC
//import EstimoteProximitySDK
import SafariServices
//import SDWebImage

//KEEP




//private var CellIdentifier = "TagTableViewCell"

class ViewController: UIViewController {
    //class ViewController: NFCNDEFReaderSessionDelegate, SFSafariViewControllerDelegate {
    
    let auteurs = Auteur.auteursFromBundle()
    
    private var listingsArray: [AnyHashable] = []
    private var dataParse:NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var statusView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet private weak var toolBar: UIToolbar!
    
    @IBOutlet weak var btnMaintenance: UIBarButtonItem!
    @IBOutlet weak var btnSignIn: UIBarButtonItem!
    
    @IBAction private func btnMaintenancePressed(_ sender: Any) {
        performSegue(withIdentifier: "MaintTableView", sender: self)
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
        
        /*
         let navigationController = storyboard.instantiateViewController(withIdentifier: "AugView") as? UINavigationController
         
         if let navigationController = navigationController {
         present(navigationController, animated: true)
         }
         */
        
        
    }
    
    
    
    @IBAction func btnSigninPressed(_ sender: Any) {
        //TODO: PUT BACK
//        let currentUser = PFUser.current()
//        let email = currentUser?.email
//        print (email)
//        //let currentUser = PFUser.isCurrentUser as? PFUser
//        if currentUser != nil {
//            //            let alertView = DQAlertView(title: kAppDelegate.currentUserName, message: "Are you sure you wish to Sign Out?", cancelButtonTitle: "Not now", otherButtonTitle: "Yes")
//            //            alertView.show()
//            //            alertView.cancelButtonAction = {
//            //                //NSLog(@"Cancel Clicked");
//            //            }
//            //            alertView.otherButtonAction = {
//            //                //NSLog(@"YES Clicked");
//            //                self.actionLogout()
//            //            }
//            
//            
//            //let welcomeView = TryThis(nibName: "TryThis", bundle: nil)
//            let welcomeView = WelcomeView(nibName: "WelcomeView", bundle: nil)
//            self.navigationController?.pushViewController(welcomeView, animated: true)
//            
//        } else {
//            // LOADING A VIEW FROM A NIB
//            
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: .bold) ]
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? DetailViewController,
//            let indexPath = tableView.indexPathForSelectedRow {
//            destination.selectedAuteur = auteurs[indexPath.row]
//        }
//    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                print (auteurs.count)
        return auteurs.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AuteurTableViewCell
        //let auteur = auteurs[indexPath.row]
        
        //cell.tagSubtitle.text = auteur.bio
//        cell.auteurImageView.image = UIImage(named: auteur.image)
//        cell.nameLabel.text = "ALEX" //auteur.name
//        cell.nameLabel.text = "HELLO WORLD"
//        cell.nameLabel.textColor = .blue
        
        //print(auteur.name)
//        cell.source.text = auteur.source
//        cell.auteurImageView.layer.cornerRadius = cell.auteurImageView.frame.size.width / 2
//        cell.nameLabel.textColor = .white
//        cell.bioLabel.textColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
//        cell.source.textColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
//        cell.source.font = UIFont.italicSystemFont(ofSize: cell.source.font.pointSize)
//        cell.nameLabel.textAlignment = .center
//        cell.selectionStyle = .none
        
        return cell
    }
    
    


}
