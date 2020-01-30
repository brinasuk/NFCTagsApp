//
//  WriteTagViewController.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 1/28/20.
//  Copyright © 2020 Hillside Software. All rights reserved.
//

import UIKit
import CoreNFC
import os

//class WriteTagViewController: UIViewController {
class WriteTagViewController: UIViewController, UINavigationControllerDelegate, NFCNDEFReaderSessionDelegate {
    
    var readerSession: NFCNDEFReaderSession?
    var ndefMessage: NFCNDEFMessage?

    @IBOutlet weak var tagResult: UILabel!
    @IBOutlet weak var tagNumber: UITextField!
    @IBOutlet weak var tagEmail: UITextField!
    
    var tagInfo:String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func writeButtonPressed(_ sender: Any) {

        //FORMAT: https://artworks4me.com/?tag=wine101 where wine101=ownerId in PARSE DATABASE
        //let tagInfo = "info@kcontemporaryart.com:103"
        
        print("TAG BUTTON PRESSED")

        let useTagEmail:String? = self.tagEmail.text
        let useTagNumber:String? = self.tagNumber.text

        // TODO: NEED TO CONVERT wine@hillsoft.com -> 1001. Each customer needs a unique integer ID
        let hashids = Hashids(salt:"bluegrotto", minHashLength:8, alphabet:"abcdefghij1234567890")
        let hash:String = hashids.encode(1001, Int(useTagNumber!)!)! // hash:"249jgi6j"
        //print(hash as Any)
        //let values = hashids.decode(hash); // values:[1,2,3]
        //print (values)
        
        tagInfo = hash
                               
        //let tagInfo = "info@kcontemporaryart.com:103"
        //tagInfo = useTagEmail! + ":" + useTagNumber
        
        self.tagResult.text! = tagInfo


        print("TAGINFO: \(tagInfo)")
        //os_log("url: %@", (urlComponent?.string)!)


        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        readerSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        readerSession?.alertMessage = "Hold your iPhone near a writable NFC tag to update."
        readerSession?.begin()
        
    }

     // MARK: - Private functions
        func createURLPayload() -> NFCNDEFPayload? {
            
    //NEW FORMAT: https://artworks4me.com/?tag=wine101 where wine101=ownerId in PARSE DATABASE
     
    //        var urlComponent = URLComponents(string: "https://fishtagcreator.example.com/")
            
            var urlComponent = URLComponents(string: "https://artworks4me.com/")

            urlComponent?.queryItems = [URLQueryItem(name: "tag", value: tagInfo)]
            
            os_log("url: %@", (urlComponent?.string)!)

            return NFCNDEFPayload.wellKnownTypeURIPayload(url: (urlComponent?.url)!)
        }
        
            // MARK: - Private functions
            func createAARPayload() -> NFCNDEFPayload? {
                
                let aarPayload = NFCNDEFPayload.init(
                    format: .nfcExternal,
                    type: "android.com:pkg".data(using: .utf8)!,
                    identifier: Data(),
                    payload: "com.hillsidesoftware.artworks4me".data(using: .utf8)!
                )

                
    //            let urlComponent = URLComponents(string: "vnd.android.nfc://ext/android.com:pkg")

                
                //urlComponent?.queryItems = [URLQueryItem(name: "", value: "")]
                
                //let aarRecord = "vnd.android.nfc://ext/android.com:pkg"
                
                //os_log("url: %@", (urlComponent?.string)!)
                
    //            return NFCNDEFPayload.wellKnownTypeURIPayload(url: (urlComponent?.url)!)
                
                return aarPayload
            }
        
        func tagRemovalDetect(_ tag: NFCNDEFTag) {
            // In the tag removal procedure, you connect to the tag and query for
            // its availability. You restart RF polling when the tag becomes
            // unavailable; otherwise, wait for certain period of time and repeat
            // availability checking.
            self.readerSession?.connect(to: tag) { (error: Error?) in
                if error != nil || !tag.isAvailable {
                    
                    os_log("Restart polling")
                    
                    self.readerSession?.restartPolling()
                    return
                }
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .milliseconds(500), execute: {
                    self.tagRemovalDetect(tag)
                })
            }
        }
        
        // MARK: - NFCNDEFReaderSessionDelegate
        func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
            
            // TODO ALEX FIX
    //        let textPayload = NFCNDEFPayload.wellKnownTypeURIPayload(<#T##self: NFCNDEFPayload##NFCNDEFPayload#>)
    //        let textPayload = NFCNDEFPayload.wellKnownTypeTextPayload(
    //            string: "Brought to you by the Great Fish Company",
    //            locale: Locale(identifier: "En")
    //        )
    //        let urlPayload = self.createURLPayload()
    //        ndefMessage = NFCNDEFMessage(records: [urlPayload!, textPayload!])
            
            let urlPayload = self.createURLPayload()
            let aarPayload = self.createAARPayload()
            ndefMessage = NFCNDEFMessage(records: [urlPayload!, aarPayload!])
            
            os_log("MessageSize=%d", ndefMessage!.length)
        }

        func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
            // If necessary, you may handle the error. Note session is no longer valid.
            // You must create a new session to restart RF polling.
        }
        
        func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
            // Do not add code in this function. This method isn't called
            // when you provide `reader(_:didDetect:)`.
        }
        
        func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
            if tags.count > 1 {
                session.alertMessage = "More than 1 tags found. Please present only 1 tag."
                self.tagRemovalDetect(tags.first!)
                return
            }
            
            // You connect to the desired tag.
            let tag = tags.first!
            session.connect(to: tag) { (error: Error?) in
                if error != nil {
                    session.restartPolling()
                    return
                }
                
                // You then query the NDEF status of tag.
                tag.queryNDEFStatus() { (status: NFCNDEFStatus, capacity: Int, error: Error?) in
                    if error != nil {
                        session.invalidate(errorMessage: "Fail to determine NDEF status.  Please try again.")
                        return
                    }
                    
                    if status == .readOnly {
                        session.invalidate(errorMessage: "Tag is not writable.")
                    } else if status == .readWrite {
                        if self.ndefMessage!.length > capacity {
                            session.invalidate(errorMessage: "Tag capacity is too small.  Minimum size requirement is \(self.ndefMessage!.length) bytes.")
                            return
                        }
                        
                        // When a tag is read-writable and has sufficient capacity,
                        // write an NDEF message to it.
                        tag.writeNDEF(self.ndefMessage!) { (error: Error?) in
                            if error != nil {
                                session.invalidate(errorMessage: "Update tag failed. Please try again.")
                            } else {
                                session.alertMessage = "Update success!"
                                session.invalidate()
                            }
                        }
                    } else {
                        session.invalidate(errorMessage: "Tag is not NDEF formatted.")
                    }
                }
            }
        }
    }

