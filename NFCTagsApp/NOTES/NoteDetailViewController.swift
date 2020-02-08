//
//  DetailViewController.swift
//  rsnt-really-simple-note-taking-ios
//
//  Created by Németh László Harri on 2019. 01. 21..
//  Copyright © 2019. Németh László Harri. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {

    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteTextTextView: UITextView!
    @IBOutlet weak var noteDate: UILabel!
    
    var currentNoteObjectId: String = ""
    var noteObject:NoteModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        print (currentNoteObjectId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
        navigationController?.hidesBarsOnSwipe = false
        //NB: THIS LINE UNHIDES THE NAVIGATION BAR
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
        
                  func  setupDarkMode() {
                      //TODO: TAKE THIS OUT OF FINAL VERSION !!!
                      if (kAppDelegate.isDarkMode == true) {
                          overrideUserInterfaceStyle = .dark} else {overrideUserInterfaceStyle = .light}
                    
                    
                    self.view.backgroundColor = .secondarySystemBackground
                      
               
                      //SET UI CONFIG COLORS
           //           cellBackGroundImageName = "list-item-background"
           //
           //           let backgroundImageName = "art_launch_image"
           //           let backgroundImage = UIImage(named: backgroundImageName)
           //           let imageView = UIImageView(image: backgroundImage)
           //           imageView.contentMode = .scaleAspectFill
           //           imageView.alpha = 0.8
           //           self.tableView.backgroundView = imageView
                      
                      
                      //tabTextColor = .label
                      //tabTextColor = .systemRed
                      //tabTextColor = .systemFill

           //           navbarTextColor = .label
           //           textColor = .label
           //
           //           navbarBackColor = .secondarySystemBackground // paleRoseColor
           //           //navbarBackColor = .systemGroupedBackground//alex
           //           //navbarBackColor = .systemBlue
           //
           //
           //           //toolBar.barTintColor = navbarBackColor
           //           //view.backgroundColor = navbarBackColor
           //
           //           statusView.backgroundColor = .systemGray4
           //
           //           let labelColor1:UIColor = .systemGray6
           //           let labelColor2:UIColor = textColor!
           //           let labelBorder:UIColor = .systemTeal
           //           //tryThisColor = .systemRed
           //           statusLabel.backgroundColor = labelColor1
           //           statusLabel.textColor = labelColor2
           //           statusView.backgroundColor = labelBorder
           //
           //           statusLabel.layer.cornerRadius = 5.0
           //           statusLabel.layer.masksToBounds = true
           //           //statusLabel.backgroundColor = .white
           //           //statusLabel.textColor = royalBlue
           //           statusLabel.font.withSize(16.0)
           //
           //           //SET THE SCANBUTTON DEFAULTS
           //           scanButton.backgroundColor = .systemBlue
           //           scanButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
           //           scanButton.layer.cornerRadius = scanButton.frame.height/2
           //           scanButton.layer.masksToBounds = true
           //           scanButton.tintColor = textColor
           //
           //           switch overrideUserInterfaceStyle {
           //            case .dark:
           //                // User Interface is Dark
           //                cellBackGroundImageName = "list-item-background-dark"
           //                ()
           //            case .light:
           //                // User Interface is Light
           //                cellBackGroundImageName = "list-item-background"
           //                ()
           //            case .unspecified:
           //                //your choice
           //                cellBackGroundImageName = "list-item-background"
           //                ()
           //            @unknown default:
           //                cellBackGroundImageName = "list-item-background"
           //                ()
           //                //Switch covers known cases, but 'UIUserInterfaceStyle' may have additional unknown values, possibly added in future versions
           //            }
               
                    }
           
        
        func setupNavigationBar() {
            //Customize the navigation bar
            //The following 2 lines make the Navigation Bar transparant
            //METHOD 0
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.tintColor = .label
            navigationController?.hidesBarsOnSwipe = false
            
            //METHOD 1
            //                navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: .bold) ]
            //                navigationItem.largeTitleDisplayMode = .always
            
            //METHOD2
            //        if let customFont = UIFont(name: "Rubik-Medium", size: 34.0) {
            //            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor .darkText, NSAttributedString.Key.font: customFont ]
            //        }
        }
    
    var detailItem: NoteModel? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let topicLabel = noteTitleLabel,
               let dateLabel = noteDate,
               let textView = noteTextTextView {
                topicLabel.text = detail.noteTitle
                dateLabel.text = "ALEX FIX"//ReallySimpleNoteDateHelper.convertDate(date: Date.init(seconds: detail.noteTimeStamp))
                textView.text = detail.noteText
            }
        }
    }

    // EDIT BUTTON TAPPED
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChangeNoteSegue" {
            let changeNoteViewController = segue.destination as! NoteCreateChangeViewController
            
            //ADDED BY ALEX
            changeNoteViewController.passNoteObjectId = currentNoteObjectId
            
            if let detail = detailItem {
                changeNoteViewController.setChangingReallySimpleNote(
                    changingReallySimpleNote: detail)
            }
        }
    }
}

