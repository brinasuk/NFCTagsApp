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
    
    var photoIsDirty:Bool? = false
    var textIsDirty:Bool? = false
    
    let SERVERNAME = "https://photos.homecards.com/admin/uploads/rebeacons/"
    var owner = OwnerModel()

    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet weak var progressBar: CircularProgressBar!
    
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
    
  /*
 ADD HERE CONTACT/PHONE/EMAIL
 */
    
    @IBOutlet var addressTextField: RoundedTextField! {
        didSet {
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    
    @IBOutlet var websiteTextField: RoundedTextField! {
        didSet {
            websiteTextField.tag = 4
            websiteTextField.delegate = self
        }
    }
    
    @IBOutlet var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.tag = 5
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
        
        //HIDE THE KEYBOARD WHEN VIEW FIRST APPEARS OR WHEN USER TAPS ON TABLE
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        handleTap()
        
    }
    
    // MARK: - Crop Controller Delegate Methods
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
        
        
        // MARK: - SET PHOTO CONSTRAINTS
        
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
        
        /*
         if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
         let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
         
         //            let resizedImage:UIImage = scaleUIImageToSize(image: image!, size: CGSize(width: 100, height: 200))
         let resizedImage = image //scaleImageToWidth(with: image, scaledToWidth: 300.0)
         
         //self.dismissViewControllerAnimated(true, completion: nil)
         photoImageView.image = resizedImage
         
         imageToUpload = resizedImage!
 */
        
        self.image = image
        picker.dismiss(animated: true, completion: {
            self.present(cropController, animated: true, completion: nil)
            //self.navigationController!.pushViewController(cropController, animated: true)
        })
        
            /*
            //If profile picture, push onto the same navigation stack
            if croppingStyle == .circular {
                if picker.sourceType == .camera {
                    picker.dismiss(animated: true, completion: {
                        self.present(cropController, animated: true, completion: nil)
                    })
                } else {
                    picker.pushViewController(cropController, animated: true)
                }
            }
            else { //otherwise dismiss, and then present from the main controller
                picker.dismiss(animated: true, completion: {
                    self.present(cropController, animated: true, completion: nil)
                    //self.navigationController!.pushViewController(cropController, animated: true)
                })
            }
            */
        }
        
        public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            self.croppedRect = cropRect
            self.croppedAngle = angle
            updateImageViewWithImage(image, fromCropViewController: cropViewController)
        }

        public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
            imageView.image = image
            imageToUpload = image
            //layoutImageView()
            

//            self.navigationItem.rightBarButtonItem?.isEnabled = true
//
//            if cropViewController.croppingStyle != .circular {
//                imageView.isHidden = true
//
//                cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
//                                                       toView: imageView,
//                                                       toFrame: CGRect.zero,
//                                                       setup: { self.layoutImageView() },
//                                                       completion: { self.imageView.isHidden = false })
//            }
//            else {
//                self.imageView.isHidden = false
//                cropViewController.dismiss(animated: true, completion: nil)
//
//            }
            

            photoImageView.image = image
            cropViewController.dismiss(animated: true, completion: nil)
        }
 
    
    /*
     // MARK: - UIImagePickerControllerDelegate methods
     
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
     }

     dismiss(animated: true, completion: nil)
     }
     */
    
    // MARK: - Misc Routines
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        titleTextField.resignFirstResponder()
    }
        

      func showInfo() {

        titleTextField.text = owner.ownerTitle
        subTitleTextField.text = owner.ownerSubTitle
        /*
         PRICE
         
         COMPANY  //CANNOT CHANGE
         CONTACT
         PHONE
         EMAIL  //CANNOT CHANGE
         
         ADDRFULL
         URL
         
         INFO
 */
        
        // SHOW PHOTO
        //photoImageView.contentMode = .scaleAspectFit
        //photoImageView.clipsToBounds = true
        
        if isDirtyText() == true {
            print("YES - IS DIRTY")}
        else {
            print("NO - NOT DIRTY")
        }
        
        
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
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
        //=================================================
        
        imageToUpload = (photoImageView.image ?? UIImage())! //or UIImage(
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    func isDirtyText() -> Bool {
 
        return true
    }

    // MARK: - UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                    let imagePicker = UIImagePickerController()
//                    imagePicker.allowsEditing = false
//                    imagePicker.sourceType = .camera
//                    imagePicker.delegate = self
//                    self.present(imagePicker, animated: true, completion: nil)
                    
                    /////////////////////////////////////////
                    //self.croppingStyle = .default
                    
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = false
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//                    let imagePicker = UIImagePickerController()
//                    imagePicker.allowsEditing = false
//                    imagePicker.sourceType = .photoLibrary
//                    imagePicker.delegate = self
//                    self.present(imagePicker, animated: true, completion: nil)
                    
                    /////////////////////////////////////////
                    //self.croppingStyle = .default
                    
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.allowsEditing = false
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
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

         //addButtonTapped(sender: self)
            
    }
    
    /*
    @objc public func addButtonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "Crop Image", style: .default) { (action) in
            //self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let profileAction = UIAlertAction(title: "Make Profile Picture", style: .default) { (action) in
            //self.croppingStyle = .circular
            
            let imagePicker = UIImagePickerController()
            imagePicker.modalPresentationStyle = .popover
            imagePicker.popoverPresentationController?.barButtonItem = (sender as! UIBarButtonItem)
            imagePicker.preferredContentSize = CGSize(width: 320, height: 568)
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        alertController.addAction(defaultAction)
        alertController.addAction(profileAction)
        alertController.modalPresentationStyle = .popover
        
        let presentationController = alertController.popoverPresentationController
        presentationController?.barButtonItem = (sender as! UIBarButtonItem)
        present(alertController, animated: true, completion: nil)
    }
 */
    
    // MARK: - ACTION BUTTONS
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        //        if nameTextField.text == "" || typeTextField.text == "" || addressTextField.text == "" || phoneTextField.text == "" || descriptionTextView.text == "" {
        //            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
        //            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        //            alertController.addAction(alertAction)
        //            present(alertController, animated: true, completion: nil)
        //
        //            return
        //        }
        //
        //        print("Name: \(nameTextField.text ?? "")")
        //        print("Type: \(typeTextField.text ?? "")")
        //        print("Location: \(addressTextField.text ?? "")")
        //        print("Phone: \(phoneTextField.text ?? "")")
        //        print("Description: \(descriptionTextView.text ?? "")")
        uploadImage()
        //dismiss(animated: true, completion: nil)
    }

    
    func uploadImage(){
        //TODO: FIX if self.imageToUpload == nil {return}
        
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
                    print(response);
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }
                
            case .failure(let encodingError):
                print(encodingError);
            }
        }
        
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
}

