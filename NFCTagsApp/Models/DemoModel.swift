//
//  TagModel.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 5/11/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

import UIKit
import Foundation
import Parse

class DemoModel
{
    var userName: String
    var userEmail: String
    var ownerName: String
    var ownerEmail: String

    init (userName: String,userEmail: String,ownerName: String,ownerEmail: String) {
        self.userName = userName;
        self.userEmail = userEmail;
        self.ownerName = ownerName;
        self.ownerEmail = ownerEmail;
    }
    
    convenience init() {
        self.init (userName: "", userEmail: "", ownerName: "", ownerEmail: "")
    }
}

