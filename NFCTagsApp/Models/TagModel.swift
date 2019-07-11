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
    var tagObjectId: String
    
    var userName: String
    var userEmail: String
    var ownerName: String
    var ownerEmail: String
    var ownerPhone: String
    
    var appCode: String  //WAS APPNAME
    var beaconDymo: String
    var beaconColor: String
    
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
    var rating: String
    

    init (createdAt:Date,
          tagObjectId:String,
          userName:String,
          userEmail:String,
          ownerName:String,
          ownerEmail:String,
          ownerPhone:String,
          
          appCode:String,
          beaconDymo:String,
          beaconColor:String,
          
        
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
        sequence:String,
        rating:String
        
        )
    {
        self.createdAt = createdAt;
        self.tagObjectId = tagObjectId;
        self.userName = userName;
        self.userEmail = userEmail;
        self.ownerName = ownerName;
        self.ownerEmail = ownerEmail;
        self.ownerPhone = ownerPhone;
        
        self.appCode = appCode;
        self.beaconDymo = beaconDymo;
        self.beaconColor = beaconColor;
        
        
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
        self.rating = rating
    }

    convenience init() {
        self.init (createdAt: Date(),
                   tagObjectId: "",
                   userName: "",
                   userEmail: "",
                   ownerName: "",
                   ownerEmail: "",
                   ownerPhone: "",
                   
                   appCode: "",
                   beaconDymo: "",  // Dymo Label.
                   beaconColor: "",
                   
            
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
            sequence: "",
            rating: ""
        )
    }
}
