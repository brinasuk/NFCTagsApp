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
        
        setupDarkMode()
        //navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = mainColor
        //SET BACKGROUND COLOR BEHIND TABLE
        self.view.backgroundColor = backgroundColor
        
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
        
                     func setupNavigationBar() {
//                          navigationController?.navigationBar.prefersLargeTitles = Never

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

                  //            navigationController?.navigationBar.barTintColor = navbarBackColor
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
                  
           func  setupDarkMode() {
           //TODO: TAKE THIS OUT OF FINAL VERSION !!!
           if (kAppDelegate.isDarkMode == true) {
               overrideUserInterfaceStyle = .dark} else {overrideUserInterfaceStyle = .light}
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
                textView.textColor = mainColor
                textView.text = detail.noteText
                
                //ReallySimpleNoteDateHelper.convertDate(date: Date.init(seconds: object.noteTimeStamp))
                 //TODO: Implement currentLocale = NSLocale.current as NSLocale
                 //let date = cellDataParse.object(forKey: "createdAt") as? Date ?? NSDate() as Date
                 //let date = noteDate
                let date = detail.createdAt
                 let format = DateFormatter()
                 format.dateFormat = "EEE, MMM d, h:mm a"
                 //@"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
                 let formattedDate = format.string(from: date)

                dateLabel.text = "Date: " + formattedDate
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

