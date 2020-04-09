//
//  PropertyModel.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 4/3/20.
//  Copyright © 2020 Hillside Software. All rights reserved.
//

import Foundation
import CoreLocation
import Parse

//  Converted to Swift 5.2 by Swiftify v5.2.18840 - https://objectivec2swift.com/
//
//  PropertyItem.h
//
//  Created by Alex Levy on 1/2/15.
//  Copyright (c) 2015 Hillside Software. All rights reserved.
//

class PropertyModel {
var createdAt: Date
var propertyObjectId: String    //NOT USED

    var objectID: String?
    var agentID: String?
    var ownerID: String?
 /* Not sure if we need this?? */    var propertyID: String?
 /*MLSNumber added July2106 */    var pricenum: NSNumber?
    var bedsnum: NSNumber?
    var bathsnum: NSNumber?
    var sqftnum: NSNumber?
    var community: String?
    var status: String?
    var seq: String?
    var photocount: String?
    var mainPhoto: String?
    var dom: String?
    var priceraw: String?
    var listDate: String?
    var latitude: String?
 /*VALx */    var longitude: String?
 /*VALx */    var location: CLLocation?
    var price: String?
    //@property(nonatomic, copy) NSString *address1;
    //@property(nonatomic, copy) NSString *address2;
    var city: String?
    var state: String?
    var zip: String?
    var neighborhood: String?
    var remarks: String?
    var propertyStyle: String?
    var propertyType: String?
    var beds: String?
    var baths: String?
    var sqft: String?
    var lotSize: String?
    var yearBuilt: String?
    var hoaFee: String?
    var schoolDistrict: String?
    var elem: String?
    var jrhi: String?
    var srhi: String?
    var taxes: String?
    var builderModel: String?
    var builderName: String?
    var parking: String?
    var basement: String?
    var address: String?
    var virtualTour: String?
    var floorPlans: String?
    var appName: String?
    
    init (createdAt:Date,
    propertyObjectId: String,   //NOT USED
    objectID: String,
    agentID: String,
    ownerID: String
    )
        
    {
        self.createdAt = createdAt;
        self.propertyObjectId = propertyObjectId;
        self.objectID = objectID;
        self.agentID = agentID;
        self.ownerID = ownerID;
    }
    
    convenience init() {
        self.init (createdAt: Date(),
                   propertyObjectId: "",
                   objectID: "",
                   agentID: "",
                   ownerID: ""
         )
    }
}
