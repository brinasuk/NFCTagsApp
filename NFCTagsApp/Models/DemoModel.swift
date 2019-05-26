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

/*
 //
 //  TagModel.h
 //  Tap2View
 //
 //  Created by Alex Levy on 11/15/17.
 //  Copyright © 2017 Hillside Software. All rights reserved.
 //
 
 #import <Parse/Parse.h>
 
 #import <UIKit/UIKit.h>
 #import <Foundation/Foundation.h>
 
 
 @interface TagModel : PFObject<PFSubclassing>
 +(NSString *) parseClassName;
 @property (nonatomic, copy) NSDate *createdAt;
 @property (nonatomic, copy) NSString *appName;
 @property (nonatomic, copy) NSString *beaconDymo; // Dymo Label. Used to manually ID the Beacon only
 @property (nonatomic, copy) NSString *beaconColor;
 
 @property (nonatomic, copy) NSString *userName;
 @property (nonatomic, copy) NSString *userEmail;
 @property (nonatomic, copy) NSString *ownerName;
 @property (nonatomic, copy) NSString *ownerEmail;
 
 @property (nonatomic, copy) NSString *tagObjectId; //DO NOT REMOVE. USED FOR SWIPE DELETES
 @property (nonatomic, copy) NSString *tagPhotoRef;  //ID FROM OWNER TBLE
 @property (nonatomic, copy) NSNumber *sequence;
 
 @property (nonatomic, copy) NSString *tagId;
 @property (nonatomic, copy) NSString *tagTitle;
 @property (nonatomic, copy) NSString *tagUrl;
 @property (nonatomic, copy) NSString *tagInfo;
 @property (nonatomic, copy) NSString *tagAddress;
 @property (nonatomic, copy) NSString *latitude;
 @property (nonatomic, copy) NSString *longitude;
 @property (nonatomic, copy) NSNumber *triggerDistance;
 
 @property (nonatomic, copy) NSString *tagSubTitle;
 @property (nonatomic, copy) NSString *tagCompany;
 
 @property (nonatomic, copy) NSString *tagAddress2;
 @property (nonatomic, copy) NSString *tagCity;
 @property (nonatomic, copy) NSString *tagState;  //Provence, County
 @property (nonatomic, copy) NSString *tagZip;
 @property (nonatomic, copy) NSString *tagCountry;
 
 
 
 @end

 */
