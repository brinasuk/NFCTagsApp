//
//  NewRestaurantController.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 6/6/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import Kingfisher
import CropViewController


class NewTagController: UITableViewController, UITextFieldDelegate, CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let imageView = UIImageView()
    
    private var image: UIImage?
    private var imageToUpload:UIImage? = UIImage()
    private var croppingStyle = CropViewCroppingStyle.default
    
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    var isDirtyPhoto:Bool? = false
    
    let SERVERNAME = "https://photos.homecards.com/admin/uploads/rebeacons/"
    var owner = OwnerModel()

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
    
    @IBOutlet var companyTextField: RoundedTextField! {
        didSet {
            companyTextField.tag = 4
            companyTextField.delegate = self
        }
    }
    
    @IBOutlet var contactTextField: RoundedTextField! {
        didSet {
            contactTextField.tag = 5
            contactTextField.delegate = self
        }
    }
    @IBOutlet var phoneTextField: RoundedTextField! {
        didSet {
            phoneTextField.tag = 6
            phoneTextField.delegate = self
        }
    }
    @IBOutlet var emailTextField: RoundedTextField! {
        didSet {
            emailTextField.tag = 7
            emailTextField.delegate = self
        }
    }
    
    @IBOutlet var addressTextField: RoundedTextField! {
        didSet {
            addressTextField.tag = 8
            addressTextField.delegate = self
        }
    }
    
    @IBOutlet var websiteTextField: RoundedTextField! {
        didSet {
            websiteTextField.tag = 9
            websiteTextField.delegate = self
        }
    }
    
    @IBOutlet var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.tag = 10
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
        
        // SHOW PHOTO
        //photoImageView.contentMode = .scaleAspectFit
        //photoImageView.clipsToBounds = true

        //let tagPhotoRef = owner.ownerObjectId
        let cloudinaryAction = "Tag"
        let usePhotoRef:String? = owner.ownerObjectId
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
        
        let processor = ResizingImageProcessor.init(referenceSize: CGSize(width: 375, height: 200), mode: .aspectFit)
        
        photoImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
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
        //dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {

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
        //
        dismiss(animated: true, completion: nil)
    }

    func saveText () {
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        let query = PFQuery(className: "TagOwnerInfo")
        query.whereKey("objectId", equalTo: owner.ownerObjectId)
        print(owner.ownerObjectId)
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
                
                
                object.saveInBackground {
                    (success: Bool, error: Error?) in
                    if (success) {
                        print("The object has been saved.")
                        UIViewController.removeSpinner(spinner: sv)
                    } else {
                        print ("There was a problem, check error.description")
                        UIViewController.removeSpinner(spinner: sv)
                    }
                }
                
                print("Successfully UPDATED")
            }
        }
    }
    
    func uploadImage(){
        //TODO: FIX if self.imageToUpload == nil {return}
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
            multipartFormData.append((self.imageToUpload?.jpegData(compressionQuality: 0.75)!)!, withName: "Photo", fileName: photoName!, mimeType: "image/jpeg")
        }, to:SERVERNAME)
        { (result) in

            switch result {
            
            case .success(let upload, _, _):
                print(result)
                
                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                    //self.progressBar.setProgress(to: self.progress, withAnimation: true)
                    
                })
                
                upload.uploadProgress { progress in
                    self.photoImageView.alpha = CGFloat((1.0 - progress.fractionCompleted))
                    print(progress.fractionCompleted)
                    self.progressBar.setProgress(to: progress.fractionCompleted, withAnimation: true)
                }
                
                
                
                
                upload.responseJSON { response in
                    //print response.result
                    UIViewController.removeSpinner(spinner: sv)
                    self.isDirtyPhoto = false;
                    print(response);
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }
                
            case .failure(let encodingError):
                UIViewController.removeSpinner(spinner: sv)
                self.isDirtyPhoto = false;
                print(encodingError);
            }
        }
        
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
    
    func scaleImageToWidth(with sourceImage: UIImage?, scaledToWidth i_width: Float) -> UIImage? {
        let oldWidth = Float(sourceImage?.size.width ?? 0.0)
        let scaleFactor: Float = i_width / oldWidth
        let newHeight = Float((sourceImage?.size.height ?? 0.0) * CGFloat(scaleFactor))
        let newWidth: Float = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width: CGFloat(newWidth), height: CGFloat(newHeight)))
        sourceImage?.draw(in: CGRect(x: 0, y: 0, width: CGFloat(newWidth), height: CGFloat(newHeight)))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
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
        
        //       var photoName = String(format: "%@%@-%@-%ld.jpg", SERVERFILENAME, useAction ?? "", useID ?? "", useNumber)
        var photoName = String(format: "%@-%@-%ld.jpg",useAction ?? "", useID ?? "", useNumber)
        
        //NSLog(@"PHOTONAME: %@",photoName);
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
    
    func setPhotoConstraints() {
        let leadingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true

        let trailingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true

        let topConstraint = NSLayoutConstraint(item: photoImageView, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true

        let bottomConstraint = NSLayoutConstraint(item: photoImageView, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true

    }
}
