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
    var ownerObjectId: String
    
    var ownerAppCode: String
    var ownerName: String
    var ownerEmail: String
    var ownerPhone: String
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
    var ownerSubTitle: String
    var ownerCompany: String
    var ownerUrl: String
    var ownerInfo: String

    var ownerAddress: String
    var ownerAddress2: String
    var ownerCity: String
    var ownerState: String
    var ownerZip: String
    var ownerCountry: String
    
    var ownerAddrFull: String
    var ownerPrice: String
    var ownerBeds: String
    var ownerBaths: String
    var ownerSqFt: String
    
    ///var ownerPhotoRef: String  REMOVED JULY 2019
    
    init (createdAt:Date,
          ownerObjectId: String,
          ownerAppCode:String,
          ownerName:String,
          ownerEmail:String,
          ownerPhone:String,

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
          
    ownerAddrFull: String,
    ownerPrice: String,
    ownerBeds: String,
    ownerBaths: String,
    ownerSqFt: String
          
        ///ownerPhotoRef:String  REMOVED JULY 2019
        )
        
    {
        self.createdAt = createdAt;
        self.ownerObjectId = ownerObjectId;
        self.ownerAppCode = ownerAppCode;
        self.ownerName = ownerName;
        self.ownerEmail = ownerEmail;
        self.ownerPhone = ownerPhone;
        
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
        
        self.ownerAddrFull=ownerAddrFull
        self.ownerPrice=ownerPrice
        self.ownerBeds=ownerBeds
        self.ownerBaths=ownerBaths
        self.ownerSqFt=ownerSqFt
        
        ///self.ownerPhotoRef = ownerPhotoRef; REMOVED JULY 2019
    }
    
    convenience init() {
        self.init (createdAt: Date(),
                   ownerObjectId: "",
                   ownerAppCode: "",
                   ownerName: "",
                   ownerEmail: "",
                   ownerPhone: "",
                   
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
                   
                   ownerAddrFull: "",
                   ownerPrice: "",
                   ownerBeds: "",
                   ownerBaths: "",
                   ownerSqFt: ""
                   
                   ///ownerPhotoRef: ""  REMOVED JULY 2019
        )
    }
}
