//
//  Extensions.swift
//  AddingParseSDK
//
//  Created by Joren Winge on 4/12/18.
//  Copyright © 2018 Back4App. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }

        return spinnerView
    }

    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
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
    
}
