//
//  DeepLinkManager.swift
//  Deeplinks
//
//  Created by Stanislav Ostrovskiy on 5/25/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import Foundation
import UIKit

enum DeeplinkType {
    enum Messages {
        case root
        case details(id: String)
    }
    case messages(Messages)
    case activity
    case newListing
    case request(id: String)
}

let Deeplinker = DeepLinkManager()
class DeepLinkManager {
    fileprivate init() {}
    
    //Based on this deeplinkType the app will decide, what page it has to open
    private var deeplinkType: DeeplinkType?


//    func handleRemoteNotification(_ notification: [AnyHashable: Any]) {
//        deeplinkType = NotificationParser.shared.handleNotification(notification)
//    }
 
    
//    @discardableResult
//    func handleShortcut(item: UIApplicationShortcutItem) -> Bool {
//        deeplinkType = ShortcutParser.shared.handleShortcut(item)
//        return deeplinkType != nil
//    }
    
    @discardableResult
    func handleDeeplink(url: URL) -> Bool {
        deeplinkType = DeeplinkParser.shared.parseDeepLink(url)
        print("DeeplinkType1: \(String(describing: deeplinkType))")
        return deeplinkType != nil
    }
    
    //Based on this deeplinkType the app will decide, what page it has to open:
    // check existing deeplink and perform action
    func checkDeepLink() {
        guard let deeplinkType = deeplinkType else {
            return
        }
        print("DeeplinkType2: \(String(describing: deeplinkType))")
        DeeplinkNavigator.shared.proceedToDeeplink(deeplinkType)
        
        // reset deeplink after handling
        self.deeplinkType = nil
    }
}
