//
//  CartModel.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 4/17/20.
//  Copyright © 2020 Hillside Software. All rights reserved.
//

import UIKit
import Foundation
import Parse

/*
 cart["tagTitle"] = tagTitle
 cart["tagObjectId"] = tag.tagObjectId
 
 cart["userName"] = self.kAppDelegate.currentUserName
 cart["userEmail"] = self.kAppDelegate.currentUserEmail
 cart["quantity"] = 1
 */


//noteOwner
//noteTagTitle

class CartModel {
    var createdAt: Date
    var tagObjectId: String
    var tagTitle: String
    var userName: String
    var userEmail: String
    var rating: String
    var tagPrice: String
    var price: Float
    var quantity: Int
    
    init (createdAt:Date,
          tagObjectId:String,
          tagTitle:String,
          userName:String,
          userEmail:String,
          rating:String,
          tagPrice:String,
          price:Float,
          quantity:Int
        )
    {
        self.createdAt = createdAt
        self.tagObjectId = tagObjectId
        self.tagTitle = tagTitle
        self.userName = userName
        self.userEmail = userEmail
        self.userEmail = userEmail
        self.rating = rating
        self.tagPrice = tagPrice
        self.price = price
        self.quantity = quantity
    }

    convenience init() {
        self.init (createdAt: Date(),
                   tagObjectId: "",
                   tagTitle: "",
                   userName: "",
                   userEmail: "",
                   rating: "",
                   tagPrice: "",
                   price: 0.0,
                   quantity: 1
        )
    }
}


