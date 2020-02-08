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
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteTextTextView: UITextView!
    @IBOutlet weak var noteDoneButton: UIButton!
    @IBOutlet weak var noteDateLabel: UILabel!
    
    var passTagId:String = ""
    var passPhotoRef:String = ""
    var passNoteObjectId:String = ""
    
    private let noteCreationTimeStamp : Int64 = Date().toSeconds()
    private(set) var changingReallySimpleNote : NoteModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set text view delegate so that we can react on text change
        noteTextTextView.delegate = self
        
        // check if we are in create mode or in change mode
        if let changingReallySimpleNote = self.changingReallySimpleNote {
            // CHANGE MODE
            // in change mode: initialize for fields with data coming from note to be changed
            noteDateLabel.text = "ALEX FIX"//ReallySimpleNoteDateHelper.convertDate(date: Date.init(seconds: noteCreationTimeStamp))
            noteTextTextView.text = changingReallySimpleNote.noteText
            noteTitleTextField.text = changingReallySimpleNote.noteTitle
            // enable done button by default
            noteDoneButton.isEnabled = true
        } else {
            // INSERT MODE
            // in create mode: set initial time stamp label
            
            noteTextTextView.text = ""
            noteTitleTextField.text = ""
            
            noteDateLabel.text = "ALEX FIX"//ReallySimpleNoteDateHelper.convertDate(date: Date.init(seconds: noteCreationTimeStamp))
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
