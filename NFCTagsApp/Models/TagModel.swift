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
    
    var tagAddrFull: String
    var tagPrice: String
    var tagBeds: String
    var tagBaths: String
    var tagSqFt: String
    
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
        
        tagAddrFull: String,
        tagPrice: String,
        tagBeds: String,
        tagBaths: String,
        tagSqFt: String,
        
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
        
        self.tagAddrFull=tagAddrFull
        self.tagPrice=tagPrice
        self.tagBeds=tagBeds
        self.tagBaths=tagBaths
        self.tagSqFt=tagSqFt
        
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
            
            tagAddrFull: "",
            tagPrice: "",
            tagBeds: "",
            tagBaths: "",
            tagSqFt: "",
            
            triggerDistance: "",
            sequence: ""
        )
    }
}
