//
//  NoteCreateChangeViewController.swift
//  rsnt-really-simple-note-taking-ios
//
//  Created by Németh László Harri on 2019. 01. 22..
//  Copyright © 2019. Németh László Harri. All rights reserved.
//

import UIKit
import Parse

class NoteCreateChangeViewController : UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteTextTextView: UITextView!
    @IBOutlet weak var noteDoneButton: UIButton!
    @IBOutlet weak var noteDateLabel: UILabel!
    
    var passTagId:String = ""
    var passPhotoRef:String = ""
    var passNoteObjectId:String = ""
    
    //currentNoteObjectIdX
    var passNoteOwner:String = ""
    var passNoteTagTitle:String = ""
    
    private let noteCreationTimeStamp : Int64 = Date().toSeconds()
    private(set) var changingReallySimpleNote : NoteModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("PASSNOTETAGTITLE: \(passNoteTagTitle)")
        
        setupDarkMode()
        setupNavigationBar()
        
        //SET THE SAVEBUTTON
        saveButton.backgroundColor = mainColor
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        saveButton.layer.cornerRadius = saveButton.frame.height/2
        saveButton.layer.masksToBounds = true
        if (kAppDelegate.isDarkMode == true)  {
            //editButton.tintColor = textColor
            saveButton.setTitleColor(textColor, for: .normal)
        } else {
            //editButton.tintColor = .systemYellow
            saveButton.setTitleColor(.white, for: .normal)
        }
        

        //navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = mainColor
        //SET BACKGROUND COLOR BEHIND TABLE
        self.view.backgroundColor = backgroundColor
        
        // set text view delegate so that we can react on text change
        noteTextTextView.delegate = self
        
        // check if we are in create mode or in change mode
        if let changingReallySimpleNote = self.changingReallySimpleNote {
            // CHANGE MODE
            self.title = "Edit Note"
            
            // in change mode: initialize for fields with data coming from note to be changed
//            noteDateLabel.text = "ALEX FIX22"//ReallySimpleNoteDateHelper.convertDate(date: Date.init(seconds: noteCreationTimeStamp))
            
            //ReallySimpleNoteDateHelper.convertDate(date: Date.init(seconds: object.noteTimeStamp))
            //TODO: Implement currentLocale = NSLocale.current as NSLocale
            //let date = cellDataParse.object(forKey: "createdAt") as? Date ?? NSDate() as Date
            let date = changingReallySimpleNote.createdAt
            let format = DateFormatter()
            format.dateFormat = "EEE, MMM d, h:mm a"
            //@"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
            let formattedDate = format.string(from: date)
            noteDateLabel.text = formattedDate
            
            noteTextTextView.text = changingReallySimpleNote.noteText
            noteTitleTextField.text = changingReallySimpleNote.noteTitle
            // enable done button by default
            noteDoneButton.isEnabled = true
        } else {
            // INSERT MODE
            // in create mode: set initial time stamp label
            self.title = "New Note"
            
            noteTextTextView.text = ""
            noteTitleTextField.text = ""
            
            
            
//            noteDateLabel.text = "ALEX FIX"//ReallySimpleNoteDateHelper.convertDate(date: Date.init(seconds: noteCreationTimeStamp))
//            let date = changingReallySimpleNote.createdAt
            
            
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "EEE, MMM d, h:mm a"
            //@"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
            let formattedDate = format.string(from: date)
            noteDateLabel.text = formattedDate
        }
        

        
        // initialize text view UI - border width, radius and color
        noteTextTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        noteTextTextView.layer.borderWidth = 1.0
        noteTextTextView.layer.cornerRadius = 5

        // For back button in navigation bar, change text
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
           func  setupDarkMode() {
           //TODO: TAKE THIS OUT OF FINAL VERSION !!!
           if (kAppDelegate.isDarkMode == true) {
               overrideUserInterfaceStyle = .dark} else {overrideUserInterfaceStyle = .light}
           }


        func setupNavigationBar() {
            //navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.largeTitleDisplayMode = .never

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

    func setChangingReallySimpleNote(changingReallySimpleNote : NoteModel) {
        self.changingReallySimpleNote = changingReallySimpleNote
    }

    @IBAction func noteTitleChanged(_ sender: UITextField, forEvent event: UIEvent) {
        if self.changingReallySimpleNote != nil {
            // change mode
            noteDoneButton.isEnabled = true
        } else {
            // create mode
            if ( sender.text?.isEmpty ?? true ) || ( noteTextTextView.text?.isEmpty ?? true ) {
                noteDoneButton.isEnabled = false
            } else {
                noteDoneButton.isEnabled = true
            }
        }
    }
    
    //Handle the text changes here
    func textViewDidChange(_ textView: UITextView) {
        if self.changingReallySimpleNote != nil {
            // change mode
            noteDoneButton.isEnabled = true
        } else {
            // create mode
            if ( noteTitleTextField.text?.isEmpty ?? true ) || ( textView.text?.isEmpty ?? true ) {
                noteDoneButton.isEnabled = false
            } else {
                noteDoneButton.isEnabled = true
            }
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton, forEvent event: UIEvent) {
        // distinguish change mode and create mode
        if self.changingReallySimpleNote != nil {
            // change mode - change the item
            changeItem()
        } else {
            // create mode - create the item
            addItem()
        }
    }
    
    private func addItem() -> Void {
        let noteTitle:String = noteTitleTextField.text ?? ""
        let noteText:String = noteTextTextView.text ?? ""
        
        let note = PFObject(className:"Notes")

        note["noteTitle"] = noteTitle
        note["noteText"] = noteText
        note["noteTagId"] = passTagId
        note["notePhotoRef"] = passPhotoRef
        note["noteOwner"] = passNoteOwner
        note["noteTagTitle"] = passNoteTagTitle
           
        note.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
                print("SUCCESS")

//                self.dismiss(animated: true, completion: nil)
//                self.popViewController(animated: true)
                self.performSegue(withIdentifier: "unwindtoMaster", sender: self)

            } else {
                // There was a problem, check error.description
                print ("ERROR")
                self.performSegue(withIdentifier: "unwindtoMaster", sender: self)
            }
        }
        
//        ReallySimpleNoteStorage.storage.addNote(passTagId: passTagId,passPhotoRef:passPhotoRef,noteTitle: noteTitle,noteText: noteText)
        
//        performSegue(
//            withIdentifier: "backToMasterView",
//            sender: self)
        //dismiss(animated: true, completion: nil)
//        navigationController!.popViewController(animated: true)
    
        
    }

    private func changeItem() -> Void {
        // get changed note instance
        if self.changingReallySimpleNote != nil {
            // change the note through note storage
            let noteTitle:String = noteTitleTextField.text ?? ""
            let noteText:String = noteTextTextView.text ?? ""
            
            let query = PFQuery(className:"Notes")
            query.getObjectInBackground(withId: passNoteObjectId) { (note: PFObject?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                    self.performSegue(withIdentifier: "unwindtoMaster", sender: self)
                } else if let note = note {
                    note["noteTitle"] = noteTitle
                    note["noteText"] = noteText
                    //note.saveInBackground()
                    note.saveInBackground {
                        (success: Bool, error: Error?) in
                        if (success) {
                            print("The object has been UPDATED.")
                            self.performSegue(withIdentifier: "unwindtoMaster", sender: self)
                        } else {
                            print ("There was a problem UPDATING, check error.description")
                            self.performSegue(withIdentifier: "unwindtoMaster", sender: self)
                        }
                    }
                }
            }
            
//            ReallySimpleNoteStorage.storage.changeNote(noteTitle: noteTitle, noteText: noteText)
            
            // navigate back to list of notes
//            performSegue(
//                withIdentifier: "backToMasterView",
//                sender: self)
            //dismiss(animated: true, completion: nil)
        }
    }

}
