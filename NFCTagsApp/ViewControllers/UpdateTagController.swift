//
//  UpdateTagController.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 6/6/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import Kingfisher
import Alertift
import CropViewController
import MapKit


class UpdateTagController: UITableViewController, UITextFieldDelegate, CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let SERVERNAME = "https://photos.homecards.com/admin/uploads/rebeacons/"
    var owner = OwnerModel()
    
    private let imageView = UIImageView()
    
    private var image: UIImage?
    private var imageToUpload:UIImage? = UIImage()
    private var croppingStyle = CropViewCroppingStyle.default
    
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    private var latitude:Double? = 0.0
    private var longitude:Double? = 0.0
    
    var isDirtyPhoto:Bool? = false
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet weak var progressBar: CircularProgressBar!
    
    /*
     TITLE
     SUBTITLE
     PRICE
     
     COMPANY  //CANNOT CHANGE
     CONTACT
     PHONE
     EMAIL  //CANNOT CHANGE
     
     ADDRFULL
     URL
     
     INFO
     */
    
    var ownerTitleKeep:String? = ""
    var ownersubTitleKeep:String? = ""
    var ownerPriceKeep:String? = ""
    
    var ownerNameKeep:String? = ""
    var ownerPhoneKeep:String? = ""
    
    var ownerAddrFullKeep:String? = ""
    var ownerUrlKeep:String? = ""
    var ownerInfoKeep:String? = ""
    
    @IBOutlet var titleTextField: RoundedTextField! {
        didSet {
            titleTextField.tag = 1
            titleTextField.becomeFirstResponder()
            titleTextField.delegate = self
            
        }
    }
    
    @IBOutlet var subTitleTextField: RoundedTextField! {
        didSet {
            subTitleTextField.tag = 2
            subTitleTextField.delegate = self
        }
    }
    
    @IBOutlet var priceTextField: RoundedTextField! {
        didSet {
            priceTextField.tag = 3
            priceTextField.delegate = self
        }
    }
    
//    @IBOutlet var companyTextField: RoundedTextField! {
//        didSet {
//            companyTextField.tag = 4
//            companyTextField.delegate = self
//        }
//    }
    
    @IBOutlet var contactTextField: RoundedTextField! {
        didSet {
            contactTextField.tag = 4
            contactTextField.delegate = self
        }
    }
    
    @IBOutlet var addressTextField: RoundedTextField! {
        didSet {
            addressTextField.tag = 5
            addressTextField.delegate = self
            
        }
    }

//    @IBOutlet var emailTextField: RoundedTextField! {
//        didSet {
//            emailTextField.tag = 7
//            emailTextField.delegate = self
//        }
//    }
    
    @IBOutlet var phoneTextField: RoundedTextField! {
        didSet {
            phoneTextField.tag = 6
            phoneTextField.delegate = self
        }
    }
    
    @IBOutlet var websiteTextField: RoundedTextField! {
        didSet {
            websiteTextField.tag = 7
            websiteTextField.delegate = self
        }
    }
    
    @IBOutlet var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.tag = 8
            descriptionTextView.layer.cornerRadius = 5.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    
    // MARK: - View controller life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let progress : Double = 0
        progressBar.isHidden = true
        progressBar.labelSize = 30
        progressBar.safePercent = 100
        progressBar.setProgress(to: progress, withAnimation: true)
        
        // Configure navigation bar appearance
        navigationController?.navigationBar.tintColor = .green
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if let customFont = UIFont(name: "Rubik-Medium", size: 35.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont ]
        }
        
        // Configure table view
        tableView.separatorStyle = .none
        showInfo()
        titleTextField.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //HIDE THE KEYBOARD WHEN VIEW FIRST APPEARS and WHEN USER TAPS ON TABLE
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        handleTap()
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        titleTextField.resignFirstResponder()
    }
    
    func showInfo() {
        
        /*
         TITLE
         SUBTITLE
         PRICE
         
         COMPANY  //CANNOT CHANGE
         CONTACT
         PHONE
         EMAIL  //CANNOT CHANGE
         
         ADDRFULL
         URL
         
         INFO
         */
        
        titleTextField.text = owner.ownerTitle
        subTitleTextField.text = owner.ownerSubTitle
        priceTextField.text = owner.ownerPrice
        
        // DO NOT SHOW companyTextField.text = owner.ownerCompany
        contactTextField.text = owner.ownerName
        phoneTextField.text = owner.ownerPhone
        // DO NOT SHOW emailTextField.text = owner.ownerEmail
        
        addressTextField.text = owner.ownerAddrFull
        websiteTextField.text = owner.ownerUrl
        descriptionTextView.text = owner.ownerInfo
        
        //KEEP THE ORIGINAL VALUES SO YOU CAN SEE LATER IF ANYTHING CHANGED
        ownerTitleKeep = owner.ownerTitle
        ownersubTitleKeep = owner.ownerSubTitle
        ownerPriceKeep = owner.ownerPrice
        
        ownerNameKeep = owner.ownerName
        ownerPhoneKeep = owner.ownerPhone
        
        ownerAddrFullKeep = owner.ownerAddrFull
        ownerUrlKeep = owner.ownerUrl
        ownerInfoKeep = owner.ownerInfo
        
        self.latitude = Double(owner.latitude)
        self.longitude = Double(owner.longitude)
        
        
        // SHOW PHOTO
        //photoImageView.contentMode = .scaleAspectFit
        //photoImageView.clipsToBounds = true
        

        let cloudinaryAction = "Tag"
        let usePhotoRef:String? = owner.ownerObjectId  //This is the Owner Photo Name
        let photoNumber = 1
        let propertyPhotoFileUrl:String? = createPhotoURL(cloudinaryAction, withID: usePhotoRef, withNumber: photoNumber) ?? ""
        
        print(propertyPhotoFileUrl ?? "")
        
        //        cell.tagImageView.layer.cornerRadius ="" cell.tagImageView.frame.size.width / 4
        //        cell.tagImageView.layer.masksToBounds = true
        //        cell.tagImageView.clipsToBounds = true
        
        // METHOD 1: ======================================
        //=================================================
        //=================================================
        
        // METHOD 2: ======================================
        //                let url = URL(string: propertyPhotoFileUrl!)!
        //                let placeholderImageName = kAppDelegate.placeholderName
        //                let placeholderImage = UIImage(named: placeholderImageName! as String)!
        //                photoImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        
        //=================================================
        
        // METHOD 3: KINGFISHER ============================
        //                let propertyPhotoFileUrl = "https://photos.homecards.com/rebeacons/Tag-bEGrwzfWdV-1.jpg"
        
        //print(propertyPhotoFileUrl)
        //        let url = URL(string: propertyPhotoFileUrl!)!
        //        photoImageView.kf.setImage(with: url)
        //                photoImageView.kf.setImage(with: url, options: [.transition(.fade(2.0))])
        
        let url = URL(string: propertyPhotoFileUrl!)
        //Size refer to the size which you want to resize your original image
        
        let placeholderImageName = kAppDelegate.placeholderName
        //TODO: Fix Width and Height. Plug in correct values
        let processor = ResizingImageProcessor.init(referenceSize: CGSize(width: 375, height: 200), mode: .aspectFit)
        
        photoImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: placeholderImageName! as String)!,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1.0)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                self.imageToUpload = (self.photoImageView.image ?? UIImage())! //or UIImage(
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                self.imageToUpload = nil
                print("Job failed: \(error.localizedDescription)")
            }
        }
        //=================================================
        
        
    }
    
    // MARK: - Crop Controller Delegate Methods
    
    //SHOW CROPVIEWCONTROLLER
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        
        // Uncomment this if you wish to provide extra instructions via a title label
        cropController.title = "Crop Image"
        
        // -- Uncomment these if you want to test out restoring to a previous crop setting --
        //cropController.angle = 90 // The initial angle in which the image will be rotated
        //cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 4288) //The initial frame that the crop controller will have visible.
        
        // -- Uncomment the following lines of code to test out the aspect ratio features --
        //cropController.aspectRatioPreset = .presetSquare; //Set the initial aspect ratio as a square
        //cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
        //cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        cropController.aspectRatioPickerButtonHidden = true
        
        // -- Uncomment this line of code to place the toolbar at the top of the view controller --
        //cropController.toolbarPosition = .top
        
        //cropController.rotateButtonsHidden = true
        //cropController.rotateClockwiseButtonHidden = true
        
        //cropController.doneButtonTitle = "Title"
        //cropController.cancelButtonTitle = "Title"
        
        
        //setPhotoConstraints()
        
        
        
        //DISMISS THE PHOTO PICKER AND PRESENT THE CROPVIEW
        self.image = image
        picker.dismiss(animated: true, completion: {
            self.present(cropController, animated: true, completion: nil)
            //self.navigationController!.pushViewController(cropController, animated: true)
        })
    }
    
    //RETURN FROM CROPVIEWCONTROLLER
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        isDirtyPhoto = true
        
        self.croppedRect = cropRect
        self.croppedAngle = angle
        imageView.image = image
        imageToUpload = image
        photoImageView.image = image
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    
    
    // MARK: - UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    //self.croppingStyle = .default
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = false
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                } else {
                    self.displayMessage(message: "Camera Unavailable")
                }
            })
            
            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    //self.croppingStyle = .default
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.allowsEditing = false
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                } else {
                    self.displayMessage(message: "Photo Library Unavailable")
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style:.cancel, handler: { (action) in
            })
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            photoSourceRequestController.addAction(cancelAction)
            
            // For iPad
            if let popoverController = photoSourceRequestController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            present(photoSourceRequestController, animated: true, completion: nil)
        }
    }
    
    // MARK: - ACTION BUTTONS
    @IBAction func gobackButtonPressed(_ sender: Any) {
        // IF THERE ARE NO CHANGES TO BOTH THE TEXT & PHOTO THEN YOU CAN BAIL OUT
        if (isDirtyPhoto == false && isDirtyText() == false) {
            //BAIL OUT 1
            //navigationController?.popViewController(animated: true)
            performSegue(withIdentifier: "closeWithSegue", sender: self)
        }
        
        //ONE (OR BOTH) FLAGS ARE DIRTY
        let photoSourceRequestController = UIAlertController(title: "Unsaved Changes", message: "Save your work", preferredStyle: .actionSheet)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            print ("YES PRESSED")
            self.saveChanges()
        })
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
            print ("NO PRESSED")
            //BAIL OUT 2
            //self.navigationController?.popViewController(animated: true)
            self.performSegue(withIdentifier: "closeWithSegue", sender: self)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style:.cancel, handler: { (action) in
            print ("CANCEL PRESSED")
        })
        
        photoSourceRequestController.addAction(yesAction)
        photoSourceRequestController.addAction(noAction)
        photoSourceRequestController.addAction(cancelAction)
        
        //        // For iPad
        //        if let popoverController = photoSourceRequestController.popoverPresentationController {
        //            if let cell = tableView.cellForRow(at: indexPath) {
        //                popoverController.sourceView = cell
        //                popoverController.sourceRect = cell.bounds
        //            }
        //        }
        
        present(photoSourceRequestController, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        // IF THERE ARE NO CHANGES TO BOTH THE TEXT & PHOTO THEN YOU CAN BAIL OUT
        if (isDirtyPhoto == false && isDirtyText() == false) {
            //Bail Out 3
            //navigationController?.popViewController(animated: true)
            performSegue(withIdentifier: "closeWithSegue", sender: self)
        } else {
            self.saveChanges()
        }
        
    }
    
    func saveChanges () {
        print ("SAVE CHANGES")
        if isDirtyText() == true {
            print("YES - TEXT IS DIRTY")
            saveText()
        }
        else {
            print("NO - TEXT NOT DIRTY")
        }
        
        if isDirtyPhoto == true {
            print("YES - PHOTO IS DIRTY")
            uploadImage()
        }
        else {
            print("NO - PHOTO NOT DIRTY")
        }
        
        //dismiss(animated: true, completion: nil)
    }
    
    func saveText () {
        //Special Code when Address has changed. Need to GEOCODE Lat/Lon
//        print(ownerAddrFullKeep)
//        print(addressTextField.text)
        
        if ownerAddrFullKeep != addressTextField.text  {
            geocodeRecord()  //GECOGE AND SAVE RECORD
        } else {
        //SOMETHING OTHER THAN THE ADDRESS CHANGED.
            saveRecord()  //JUST SAVE THE RECORD
        }
    }
        
    func geocodeRecord(){
        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        let address:String? = addressTextField.text
        //let address = "S Arm Road, V & A Waterfront, Cape Town Western Cape 8002 South Africa"
        //let address = "1 Aldwych, Westminster Borough, London, WC2B 4BZ, United Kingdom"
        //let address = "1 Aldwych London WC2B 4BZ"
    
        geoCoder.geocodeAddressString(address! , completionHandler: { placemarks, error in
            if let error = error {
                print(error)
                self.displayMessage(message: "The Address you entered is Invalid. Please try again")
                return
            }
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                
                self.latitude = placemark.location?.coordinate.latitude
                self.longitude = placemark.location?.coordinate.longitude
                print("Lat: \(String(describing: self.latitude)), Lon: \(String(describing: self.longitude))")
                
                if self.latitude == 0.0 && self.longitude == 0.0 {
                    //UIViewController.removeSpinner(spinner: sv)
                    self.displayMessage(message: "The Address you entered is Invalid. Please try again")
                } else {
                    self.saveRecord()
                }
            }
        }
    )}
    
    func saveRecord(){
        let sv = UIViewController.displaySpinner(onView: self.view)
        let query = PFQuery(className: "TagOwnerInfo")

        query.whereKey("objectId", equalTo: owner.ownerObjectId)
        //print(owner.ownerObjectId)
        query.getFirstObjectInBackground {(object: PFObject?, error: Error?) in
            if let error = error {
                // NO MATCH FOUND
                UIViewController.removeSpinner(spinner: sv)
                print(error.localizedDescription)
                self.displayErrorMessage(message: error.localizedDescription)
            } else if let object = object {
                
                /*
                 TITLE
                 SUBTITLE
                 PRICE
                 
                 COMPANY  //CANNOT CHANGE
                 CONTACT
                 PHONE
                 EMAIL  //CANNOT CHANGE
                 
                 ADDRFULL
                 URL
                 
                 INFO
                 */
                
                object["ownerTitle"] = self.titleTextField.text
                object["ownerSubTitle"] = self.subTitleTextField.text
                object["ownerPrice"] = self.priceTextField.text
                
                //DO NOT ALLOW USER TO CHANGE object["ownerCompany"] = self.companyTextField.text
                object["ownerName"] = self.contactTextField.text
                object["ownerPhone"] = self.phoneTextField.text
                //DO NOT ALLOW USER TO CHANGE object["ownerEmail"] = self.emailTextField.text
                
                object["ownerAddrFull"] = self.addressTextField.text
                object["ownerUrl"] = self.websiteTextField.text
                object["ownerInfo"] = self.descriptionTextView.text
                
                object["latitude"] = self.latitude.map { String($0) } ?? "0.0"
                object["longitude"] = self.longitude.map { String($0) } ?? "0.0"
                
                //object latitudeD = self.latitude
                //object longitudeD = self.longitude
                
                let point = PFGeoPoint(latitude: self.latitude!, longitude: self.longitude!)
                object["location"] = point
                
                
                object.saveInBackground {
                    (success: Bool, error: Error?) in
                    if (success) {
                        print("The object has been saved.")
                        self.ownerTitleKeep = self.titleTextField.text
                        self.ownersubTitleKeep = self.subTitleTextField.text
                        self.ownerPriceKeep = self.priceTextField.text
                        
                        //DO NOT ALLOW USER TO CHANGE object["ownerCompany"] = self.companyTextField.text
                        self.ownerNameKeep = self.contactTextField.text
                        self.ownerPhoneKeep = self.phoneTextField.text
                        //DO NOT ALLOW USER TO CHANGE object["ownerEmail"] = self.emailTextField.text
                        
                        self.ownerAddrFullKeep = self.addressTextField.text
                        self.ownerUrlKeep = self.websiteTextField.text
                        self.ownerInfoKeep = self.descriptionTextView.text
                        UIViewController.removeSpinner(spinner: sv)
                    } else {
                        print ("There was a problem, check error.description")
                        self.displayErrorMessage(message: "Cannot save Info")
                        UIViewController.removeSpinner(spinner: sv)
                    }
                    //BAIL OUT IF NOTHING MORE TO DO
                    if self.isDirtyPhoto == false {
                        //NEED TO UPDATE TEXT
                        //self.navigationController?.popViewController(animated: true)
                        self.performSegue(withIdentifier: "unwindToRefreshWithSegue", sender: self)
                    } else {
                        self.uploadImage()
                    }
                }
                
                print("Successfully UPDATED")
            }
        }

    }
    
    func uploadImage(){
        if self.imageToUpload == nil {return}
        
        let resizedImage = resizeImage(image: imageToUpload!, withSize: CGSize(width:375, height:360)
        )
        //let resizedImage:UIImage? = imageToUpload
        photoImageView.image = resizedImage

        
        //TODO: RESIZE PHOTO
        
        //        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        //            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        //
        
        //            //            let resizedImage:UIImage = scaleUIImageToSize(image: image!, size: CGSize(width: 100, height: 200))
        
        //            let resizedImage = image //scaleImageToWidth(with: image, scaledToWidth: 300.0)
        //
        //            //self.dismissViewControllerAnimated(true, completion: nil)
        //            photoImageView.image = resizedImage
        //
        //            imageToUpload = resizedImage!
        //        }
        
        //CRITICAL:  CLEAS CACHE!!
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        
        
        //       imageToUpload = UIImage()
        //
        //        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        //        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        //        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        //        if let dirPath          = paths.first
        //        {
        //            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("Image2.png") //Your image name here
        //            let image    = UIImage(contentsOfFile: imageURL.path)
        //            imageToUpload = image!
        //        }
        
        //UPLOADS FILE EXAMPLE: https://photos.homecards.com/rebeacons/Tag-bEGrwzfWdV-1.jpg
        
        progressBar.isHidden = false
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        let photoName:String? = createPhotoName("Tag", withID: owner.ownerObjectId, withNumber: 1) ?? ""
        print (photoName!)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append((resizedImage.jpegData(compressionQuality: 1.0)!), withName: "Photo", fileName: photoName!, mimeType: "image/jpeg")
        }, to:SERVERNAME)
        { (result) in
            
            switch result {
                
            case .success(let upload, _, _):
                //print(result)
                
                upload.uploadProgress(closure: { (progress) in
                    //print(progress)
                    //self.progressBar.setProgress(to: self.progress, withAnimation: true)
                    
                })
                
                upload.uploadProgress { progress in
                    self.photoImageView.alpha = CGFloat((1.0 - progress.fractionCompleted))
                    print(progress.fractionCompleted)

                    self.progressBar.setProgress(to: progress.fractionCompleted, withAnimation: true)
                }
                
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    print(response)
                    if let err = response.error{
                        self.displayErrorMessage(message: err as! String)
                        return
                    }
                    UIViewController.removeSpinner(spinner: sv)
                    self.onCompletion()
                }
                
                //                upload.responseJSON { response in
                //                    //print response.result
                //                    UIViewController.removeSpinner(spinner: sv)
                //                    self.isDirtyPhoto = false;
                //                    print(response);
                //                    self.navigationController?.popToRootViewController(animated: true)
                //
                //                }
                
            case .failure(let encodingError):
                UIViewController.removeSpinner(spinner: sv)
                
                print(encodingError);
            }
        }
        
    }
    
    func onCompletion () {
        self.progressBar.setProgress(to: 100.0, withAnimation: true)
        
        //NOTE THE USE OF popToROOTViewController. THIS IS CRITICAL !!!!!
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - RESIZE ROUTINES
    
    //    func resizeImage(withWidth newWidth: CGFloat) -> UIImage? {
    //
    //        let scale = newWidth / self.size.width
    //        let newHeight = self.size.height * scale
    //        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    //        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    //        let newImage = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //
    //        return newImage
    //    }
    
    /**
     * Scales an image to fit within a bounds with a size governed by
     * the passed size. Also keeps the aspect ratio.
     *
     * Switch MIN to MAX for aspect fill instead of fit.
     *
     * @param newSize the size of the bounds the image must fit within.
     * @return a new scaled image.
     */
    //    func scaleUIImageToSize( image: UIImage, size: CGSize) -> UIImage {
    //        let hasAlpha = false
    //        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
    //
    //        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
    //        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
    //
    //        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
    //        UIGraphicsEndImageContext()
    //
    //        return scaledImage
    //    }
    
    //let resizedImage = scaleImageToWidth(with: image, scaledToWidth: 300.0)
    
//    func scaleImageToWidth(with sourceImage: UIImage?, scaledToWidth i_width: Float) -> UIImage? {
//        let oldWidth = Float(sourceImage?.size.width ?? 0.0)
//        let scaleFactor: Float = i_width / oldWidth
//        let newHeight = Float((sourceImage?.size.height ?? 0.0) * CGFloat(scaleFactor))
//        let newWidth: Float = oldWidth * scaleFactor
//
//        UIGraphicsBeginImageContext(CGSize(width: CGFloat(newWidth), height: CGFloat(newHeight)))
//        sourceImage?.draw(in: CGRect(x: 0, y: 0, width: CGFloat(newWidth), height: CGFloat(newHeight)))
//        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage
//    }
    
    /*
     import AVFoundation
     
     let imageSizeSameAspectRatio = CGSize(width: 50, height: 100)
     let imageSizeDiffAspectRatio = CGSize(width: 70, height: 70)
     
     let containerViewRect = CGRect(x: 0, y: 0, width: 100, height: 200)
     
     AVMakeRectWithAspectRatioInsideRect(imageSizeSameAspectRatio, containerViewRect) // Returns {x 0 y 0 w 100 h 200}
     AVMakeRectWithAspectRatioInsideRect(imageSizeDiffAspectRatio, containerViewRect) // Returns {x 0 y 50 w 100 h 100}
 */
    
    func resizeImage(image: UIImage, withSize: CGSize) -> UIImage {
        //resizeImage(image: UIImage(named: "ImageName"), withSize: CGSize(width: 300, height: 300))
        
        var actualHeight: CGFloat = image.size.height
        var actualWidth: CGFloat = image.size.width
        let maxHeight: CGFloat = withSize.width
        let maxWidth: CGFloat = withSize.height
        var imgRatio: CGFloat = actualWidth/actualHeight
        let maxRatio: CGFloat = maxWidth/maxHeight
        let compressionQuality:CGFloat = 0.75
        
        if (actualHeight > maxHeight || actualWidth > maxWidth) {
            if(imgRatio < maxRatio) {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            } else if(imgRatio > maxRatio) {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let image: UIImage  = UIGraphicsGetImageFromCurrentImageContext()!
        //let imageData = UIImageJPEGRepresentation(image, CGFloat(compressionQuality))
        let imageData = image.jpegData(compressionQuality: compressionQuality)
        
        UIGraphicsEndImageContext()
        let resizedImage = UIImage(data: imageData!)
        return resizedImage!
        
    }
    
    // MARK: - MISC ROUTINES
    
    func createPhotoURL(_ useAction: String?, withID useID: String?, withNumber useNumber: Int) -> String? {
        if useID == nil {
            return nil
        }
        let url = String(format: "%@%@-%@-%ld.jpg", SERVERFILENAME, useAction ?? "", useID ?? "", useNumber)
        return url
    }
    
    func createPhotoName(_ useAction: String?, withID useID: String?, withNumber useNumber: Int) -> String? {
        if useID == nil {
            return nil
        }
        let photoName = String(format: "%@-%@-%ld.jpg",useAction ?? "", useID ?? "", useNumber)
        return photoName
    }
    
    func displayMessage(message:String) {
        let alertView = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
    
    func displayErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
    
    func isDirtyText() -> Bool {
        var isDirty = false
        
        if ownerTitleKeep != titleTextField.text {isDirty = true}
        if ownersubTitleKeep != subTitleTextField.text {isDirty = true}
        if ownerPriceKeep != priceTextField.text  {isDirty = true}
        
        if ownerNameKeep != contactTextField.text  {isDirty = true}
        if ownerPhoneKeep != phoneTextField.text  {isDirty = true}

        if ownerAddrFullKeep != addressTextField.text  {isDirty = true}
        
        if ownerUrlKeep != websiteTextField.text  {isDirty = true}
        if ownerInfoKeep != descriptionTextView.text  {isDirty = true}
        
        return isDirty
    }
    
    // MARK: - SET PHOTO CONSTRAINTS
    
//    func setPhotoConstraints() {
//        let leadingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
//        leadingConstraint.isActive = true
//
//        let trailingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
//        trailingConstraint.isActive = true
//
//        let topConstraint = NSLayoutConstraint(item: photoImageView, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
//        topConstraint.isActive = true
//
//        let bottomConstraint = NSLayoutConstraint(item: photoImageView, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
//        bottomConstraint.isActive = true
//
//    }
    
}

