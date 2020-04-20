//
//  CheckoutViewController.swift
//  Universal
//
//  Created by Mark on 24/03/2018.
//  Copyright © 2018 Sherdle. All rights reserved.
//

import Foundation
import WebKit

final class CheckoutViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var completedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDarkMode()
        setupNavigationBar()
        
        //navigationItem.largeTitleDisplayMode = .never
        
        //webView.uiDelegate = self
        //webView.navigationDelegate = self
        //disableScroll()
        
//        let callback = {(result: Bool) -> Void in
//            if (result) {
//                print("Cookies: ", CookieCart.cartCookies.cookies!)
            
                //Ensures that WebView has no existing products/session
//                self.webView.configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
 
                //TODO: ALEX
//                let myURL = URL(string: AppDelegate.WOOCOMMERCE_HOST + checkout_url)
                //var request = URLRequest(url: myURL!)
//                request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: CookieCart.cartCookies.cookies ?? [])
//
//                self.webView.load(request)
//            } else {
//                //TODO Error message
//            }
        }
    
//        CookieCart.init(completion: callback).getCookiesForCart();
//    }
    
//    func disableScroll(){
//        let source: String = "var meta = document.createElement('meta');" +
//            "meta.name = 'viewport';" +
//            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
//            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";
//        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//        webView.configuration.userContentController.addUserScript(script)
//    }
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        loadingView.isHidden = true
//    }
    
//    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        if (webView.url?.absoluteString.contains(checkout_order_received))! {
//            completedView.isHidden = false
//
//            //TODO: ALEX
//            //Cart.sharedInstance.reset()
//        }
//    }
    
    func  setupDarkMode() {
        if  (kAppDelegate.isDarkMode == true)
            {if #available(iOS 13.0, *) {overrideUserInterfaceStyle = .dark}
        } else
            {if #available(iOS 13.0, *) {overrideUserInterfaceStyle = .light}
        }
    }

        func setupNavigationBar() {
            navigationController?.navigationBar.prefersLargeTitles = false

            if #available(iOS 13.0, *) {
                let navBarAppearance = UINavigationBarAppearance()
                //navBarAppearance.configureWithDefaultBackground()
                navBarAppearance.configureWithOpaqueBackground()

                navBarAppearance.titleTextAttributes = [.foregroundColor: titleTextColor]
                navBarAppearance.largeTitleTextAttributes = [.foregroundColor: titleLargeTextColor]
                navBarAppearance.backgroundColor = navbarBackColor //<insert your color here>

                //navBarAppearance.backgroundColor = navbarBackColor
                navBarAppearance.shadowColor = nil
                navigationController?.navigationBar.isTranslucent = false
                navigationController?.navigationBar.standardAppearance = navBarAppearance
                navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

    //            navigationController?.navigationBar.barTintColor = navbarBackColor
    //            navigationController?.navigationBar.tintColor =  navbarBackColor
    //            self.navigationController!.navigationBar.titleTextAttributes =
    //            [NSAttributedString.Key.backgroundColor: navbarBackColor]

                } else {

                //METHOD2. NOT iOS13
                if let customFont = UIFont(name: "Rubik-Medium", size: 34.0) {
                    navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor .darkText, NSAttributedString.Key.font: customFont ]
                    }
                }
        }
    
    @IBAction func completedButtonClick(_ sender: Any) {
        //self.navigationController?.popToRootViewController(animated: false)
//        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        dismissPopAllViewViewControllers()
        
    }
    
    // MARK:- Dismiss and Pop ViewControllers
    func dismissPopAllViewViewControllers() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
            (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
        }
    }
    
}
