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
            let changeNoteViewController = segue.destination as! ReallySimpleNoteCreateChangeViewController
            
            //ADDED BY ALEX
            changeNoteViewController.passNoteObjectId = currentNoteObjectId
            
            if let detail = detailItem {
                changeNoteViewController.setChangingReallySimpleNote(
                    changingReallySimpleNote: detail)
            }
        }
    }
}

