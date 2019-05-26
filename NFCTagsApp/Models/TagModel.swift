//
//  TagModel.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 5/20/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

import UIKit
import Foundation
import Parse

class TagModel {
    var createdAt: Date
    var userName: String
    var userEmail: String
    var ownerName: String
    var ownerEmail: String
    
    var appName: String
    var beaconDymo: String
    var beaconColor: String
    
    var tagObjectId: String
    var tagPhotoRef: String
  
    var tagId: String
    var tagTitle: String
    var tagUrl: String
    var tagInfo: String
    var tagAddress: String
    
    var latitude: String
    var longitude: String
    
    var tagSubTitle: String
    var tagCompany: String
    var tagAddress2: String
    var tagCity: String
    var tagState: String
    var tagZip: String
    var tagCountry: String
    
    var triggerDistance: String
     var sequence: String
    

    init (createdAt:Date,
          userName:String,
          userEmail:String,
          ownerName:String,
          ownerEmail:String,
          
          appName:String,
          beaconDymo:String,
          beaconColor:String,
          
        tagObjectId:String,
        tagPhotoRef:String,
        
        tagId:String,
        tagTitle:String,
        tagUrl:String,
        tagInfo:String,
        tagAddress:String,
        
        latitude:String,
        longitude:String,
        
        tagSubTitle:String,
        tagCompany:String,
        tagAddress2:String,
        tagCity:String,
        tagState:String,   //Provence, County
        tagZip:String,
        tagCountry:String,
        
        triggerDistance:String,
        sequence:String
        
        )
    {
        self.createdAt = createdAt;
        self.userName = userName;
        self.userEmail = userEmail;
        self.ownerName = ownerName;
        self.ownerEmail = ownerEmail;
        
        self.appName = appName;
        self.beaconDymo = beaconDymo;
        self.beaconColor = beaconColor;
        
        self.tagObjectId = tagObjectId;
        self.tagPhotoRef = tagPhotoRef;
        
        self.tagId = tagId;
        self.tagTitle = tagTitle;
        self.tagUrl = tagUrl;
        self.tagInfo = tagInfo;
        self.tagAddress = tagAddress;
        
        self.latitude = latitude;
        self.longitude = longitude;
        
        self.tagSubTitle = tagSubTitle;
        self.tagCompany = tagCompany;
        self.tagAddress2 = tagAddress2;
        self.tagCity = tagCity;
        self.tagState = tagState
        self.tagZip = tagZip;
        self.tagCountry = tagCountry

        self.triggerDistance = triggerDistance;
        self.sequence = sequence;
    }

    convenience init() {
        self.init (createdAt: Date(),
                   userName: "",
                   userEmail: "",
                   ownerName: "",
                   ownerEmail: "",
                   
                   appName: "",
                   beaconDymo: "",  // Dymo Label.
                   beaconColor: "",
                   
            tagObjectId: "",
            tagPhotoRef: "",
            
            tagId: "",
            tagTitle: "",
            tagUrl: "",
            tagInfo: "",
            tagAddress: "",
            
            latitude: "",
            longitude: "",
            
            tagSubTitle: "",
            tagCompany: "",
            tagAddress2: "",
            tagCity: "",
            tagState: "",
            tagZip: "",
            tagCountry: "",
            
            triggerDistance: "",
            sequence: ""
        )
    }
}

/*
 
 
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
 @property (nonatomic, copy) NSNumber *triggerDistance;
 
 @property (nonatomic, copy) NSString *tagId;
 @property (nonatomic, copy) NSString *tagTitle;
 @property (nonatomic, copy) NSString *tagUrl;
 @property (nonatomic, copy) NSString *tagInfo;
 @property (nonatomic, copy) NSString *tagAddress;
 @property (nonatomic, copy) NSString *latitude;
 @property (nonatomic, copy) NSString *longitude;
 
 @property (nonatomic, copy) NSString *tagSubTitle;
 @property (nonatomic, copy) NSString *tagCompany;
 
 @property (nonatomic, copy) NSString *tagAddress2;
 @property (nonatomic, copy) NSString *tagCity;
 @property (nonatomic, copy) NSString *tagState;  //Provence, County
 @property (nonatomic, copy) NSString *tagZip;
 @property (nonatomic, copy) NSString *tagCountry;
 
 
 
 @end
 
 */

