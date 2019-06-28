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
//import AlamofireImage
import Kingfisher

class NewRestaurantController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let SERVERNAME = "https://photos.homecards.com/admin/uploads/rebeacons/"
    var owner = OwnerModel()
    var imageToUpload:UIImage? = UIImage()
    
    @IBOutlet var photoImageView: UIImageView!
    
    @IBOutlet var nameTextField: RoundedTextField! {
        didSet {
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
            
        }
    }
    
    @IBOutlet var typeTextField: RoundedTextField! {
        didSet {
            typeTextField.tag = 2
            typeTextField.delegate = self
        }
    }
    
    @IBOutlet var addressTextField: RoundedTextField! {
        didSet {
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    
    @IBOutlet var phoneTextField: RoundedTextField! {
        didSet {
            phoneTextField.tag = 4
            phoneTextField.delegate = self
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
        

        
        // Configure navigation bar appearance
        navigationController?.navigationBar.tintColor = .green
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Rubik-Medium", size: 35.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont ]
        }
        
        // Configure table view
        tableView.separatorStyle = .none
        

        
        showInfo()
        
    }
        

      func showInfo() {
        let alex = owner.ownerObjectId
        print(alex)
        nameTextField.text = owner.ownerObjectId
        
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
        //let size = CGSize(width: 200, height: 200)
        let processor = ResizingImageProcessor.init(referenceSize: CGSize(width: 375, height: 200), mode: .aspectFit)
        
//        photoImageView.kf.setImage(with: imageUrl! , placeholder: UIImage(named: "placeholder"), options: [.transition(ImageTransition.fade(1)), .processor(processImage)], progressBlock: nil, completionHandler: nil)
        
        

//        let processor = DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))
//            >> RoundCornerImageProcessor(cornerRadius: 20)
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

    // MARK: - UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = true
                    imagePicker.sourceType = .camera
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
//                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//                    let imagePicker = UIImagePickerController()
//                    imagePicker.allowsEditing = false
//                    imagePicker.sourceType = .photoLibrary
//                    imagePicker.delegate = self
//
//                    self.present(imagePicker, animated: true, completion: nil)
//                }
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
    
    
    
    // MARK: - UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
//            let resizedImage:UIImage = scaleUIImageToSize(image: image!, size: CGSize(width: 100, height: 200))
            let resizedImage = image //scaleImageToWidth(with: image, scaledToWidth: 300.0)
            
            //self.dismissViewControllerAnimated(true, completion: nil)
            photoImageView.image = resizedImage

            imageToUpload = resizedImage!
        }
        
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

        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Action method (Exercise #2)
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
        
        
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
        
        //uploadImage()
        
        //dismiss(animated: true, completion: nil)
        //navigationController?.popViewController(animated: true)
        navigationController?.popToRootViewController(animated: true)
        //[self dismissViewControllerAnimated:YES completion:nil];
        //dismiss(animated: true, completion: nil)
    }
    
    // MARK: - ACTION BUTTONS
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
        //displayMessage(message: "SAVED")
        uploadImage()
        //navigationController?.popViewController(animated: true)
        //navigationController?.popToRootViewController(animated: true)
        //[self dismissViewControllerAnimated:YES completion:nil];
        //dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(){
        if self.imageToUpload == nil {return}
        
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
                })
                
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

