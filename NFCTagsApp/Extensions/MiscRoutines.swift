//
//  MiscRoutines.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 7/5/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {

    
    //TODO: SEE IF YOU CAN MAKE THIS WORK
    //    class func displayMessageX(message:String) {
    //        let alertView = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
    //        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
    //        }
    //        alertView.addAction(OKAction)
    //        if let presenter = alertView.popoverPresentationController {
    //            presenter.sourceView = self.view
    //            presenter.sourceRect = self.view.bounds
    //        }
    //        self.present(alertView, animated: true, completion:nil)
    //    }
    
    class func createNewPhotoURL(_ useAction: String?, withID useID: String?, withNumber useNumber: Int) -> String? {
        if useID == nil {
            return nil
        }
        var url = ""
        url = String(format: "%@%@-%@-%ld.jpg", SERVERFILENAME, useAction ?? "", useID ?? "", useNumber)
        //NSLog(@"URL: %@",url);
        return url
        
    }
}
