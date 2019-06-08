//
//  OwnerModel.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 6/7/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

import UIKit
import Foundation
import Parse

class OwnerModel {
    var createdAt: Date
    var appName: String
    var ownerName: String
    var ownerEmail: String
    
    var ownerNumber: String
    var ownerId: String
    var latitude: String
    var longitude: String
    var triggerDistance: String
    
    var identifier: String
    var beaconName: String
    var beaconColor: String
    var beaconDymo: String
    
    var ownerTitle: String
    var ownerUrl: String
    var ownerInfo: String
    var ownerAddress: String
    var ownerSubTitle: String
    
    var ownerCompany: String
    var ownerAddress2: String
    var ownerCity: String
    var ownerState: String
    var ownerZip: String
    var ownerCountry: String
    
    var ownerPhotoRef: String
    
    init (createdAt:Date,
          appName:String,
          ownerName:String,
          ownerEmail:String,

          ownerNumber:String,
          ownerId:String,
          latitude:String,
          longitude:String,
          triggerDistance:String,
          
          identifier:String,
          beaconName:String,
          beaconColor:String,
          beaconDymo:String,
          
          ownerTitle:String,
          ownerUrl:String,
          ownerInfo:String,
          ownerAddress:String,
          ownerSubTitle:String,
          
          ownerCompany:String,
          ownerAddress2:String,
          ownerCity:String,
          ownerState:String,
          ownerZip:String,
          ownerCountry:String,
          
        ownerPhotoRef:String
        )
        
    {
        self.createdAt = createdAt;
        self.appName = appName;
        self.ownerName = ownerName;
        self.ownerEmail = ownerEmail;
        
        self.ownerNumber = ownerNumber;
        self.ownerId = ownerId;
        self.latitude = latitude;
        self.longitude = longitude;
        self.triggerDistance = triggerDistance;
        
        self.identifier = identifier;
        self.beaconName = beaconName;
        self.beaconColor = beaconColor;
        self.beaconDymo = beaconDymo;
        
        self.ownerTitle = ownerTitle;
        self.ownerUrl = ownerUrl;
        self.ownerInfo = ownerInfo;
        self.ownerAddress = ownerAddress;
        self.ownerSubTitle = ownerSubTitle;
        
        self.ownerCompany = ownerCompany;
        self.ownerAddress2 = ownerAddress2;
        self.ownerCity = ownerCity;
        self.ownerState = ownerState;
        self.ownerZip = ownerZip;
        self.ownerCountry = ownerCountry;
        
        self.ownerPhotoRef = ownerPhotoRef;
    }
    
    convenience init() {
        self.init (createdAt: Date(),
                   appName: "",
                   ownerName: "",
                   ownerEmail: "",
                   
                   ownerNumber: "",
                   ownerId: "",
                   latitude: "",
                   longitude: "",
                   triggerDistance: "",
                   
                   identifier: "",
                   beaconName: "",
                   beaconColor: "",
                   beaconDymo: "",
                   
                   ownerTitle: "",
                   ownerUrl: "",
                   ownerInfo: "",
                   ownerAddress: "",
                   ownerSubTitle: "",
                   
                   ownerCompany: "",
                   ownerAddress2: "",
                   ownerCity: "",
                   ownerState: "",
                   ownerZip: "",
                   ownerCountry: "",
                   
                   ownerPhotoRef: ""
        )
    }
}
