//
//  NoteModel.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 12/12/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//


import UIKit
import Foundation
import Parse

//noteOwner
//noteTagTitle

class NoteModel {
    var createdAt: Date
    var noteObjectId: String
    var noteTitle: String
    var noteText: String
    var noteTagId: String
    var notePhotoRef: String
    var noteOwner: String
    var noteTagTitle: String
    
    init (createdAt:Date,
          noteObjectId:String,
          noteTitle:String,
          noteText:String,
          noteTagId:String,
          notePhotoRef:String,
          noteOwner:String,
          noteTagTitle:String
        )
    {
        self.createdAt = createdAt;
        self.noteObjectId = noteObjectId;
        self.noteTitle = noteTitle;
        self.noteText = noteText;
        self.noteTagId = noteTagId;
        self.notePhotoRef = notePhotoRef;
        self.noteOwner = noteOwner;
        self.noteTagTitle = noteTagTitle
    }

    convenience init() {
        self.init (createdAt: Date(),
                   noteObjectId: "",
                   noteTitle: "",
                   noteText: "",
                   noteTagId: "",
                   notePhotoRef: "",
                   noteOwner: "",
                   noteTagTitle: ""
        )
    }
}
