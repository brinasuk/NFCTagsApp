
import Parse
import UIKit
import Kingfisher
import Alertift
import Alamofire
import AlamofireImage

final class CartItemCell: UITableViewCell {

    static let reuseIdentifier = "CartItemCell"

    var cartItemQuantityChangedCallback: (() -> ())!

    private weak var cartItem: CartModel!

    // MARK: Properties

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var quantityLabel: UILabel!

    @IBOutlet weak var quantityStepper: UIStepper!

    @IBOutlet weak var availabilityLabel: UILabel!

    @IBOutlet weak var productImageView: UIImageView!
    
    override func awakeFromNib() {
        // Resize the stepper.
        quantityStepper.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        // Draw a border layer at the top.
        //self.drawTopBorderWithColor(color: UIColor.brown, height: 0.5)
        
        nameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        priceLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        quantityLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        availabilityLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        //ROMEE6 DARKMODE
        
        nameLabel.textColor = secondaryLabel
        priceLabel.textColor = mainColor
        quantityLabel.textColor = mainColor
        availabilityLabel.textColor = secondaryLabel
        quantityStepper.tintColor = mainColor
    }

    // MARK: IBActions

    @IBAction func quantityStepperValueChanged(_ sender: Any) {
        //TODO: ALEX  ROMEE4

        let value = Int((sender as! UIStepper).value)
        quantityLabel.text = NSLocalizedString("quantity", comment: "") + ": \(value)"
        
        let objectId:String = Cart.sharedInstance.findObjectIdInCart(item: cartItem)
        let scores = ["OBJECTID": objectId, "STEPPERVALUE": "\(value)"]
        //let scores = ["Bob": 5, "Alice": 3, "Arthur": 42]

        NotificationCenter.default.post(name: NSNotification.Name("STEPPERVALUECHANGED"), object: self, userInfo: (scores as [AnyHashable : Any]))
        

        
        
//        let updateSuccesfull = Cart.sharedInstance.updateQuantity(item: cartItem, value: value)
//        if (updateSuccesfull) {
//            quantityLabel.text = NSLocalizedString("quantity", comment: "") + ": \(value)"
        
//            cartItemQuantityChangedCallback()
//        }
    }
    
//    func removeItem () {
//        //print("DELETE2 + \(self.deleteObjectId)")
//        let query = PFQuery(className: "Tags")
//
//        let sv = UIViewController.displaySpinner(onView: self.view)
//
//        query.getObjectInBackground(withId: self.deleteObjectId) { (object: PFObject?, error: Error?) in
//            if let error = error {
//                // The query failed
//                UIViewController.removeSpinner(spinner: sv)
//                print(error.localizedDescription)
//                //self.displayMessage(message: error.localizedDescription)
//            } else if let object = object {
//                // The query succeeded with a matching result
//                //print("SUCCESS")
//
//                object.deleteInBackground(block: { (deleteSuccessful, error) -> Void in
//                    // User deleted
//                    //self.tableView.reloadData()
//                    UIViewController.removeSpinner(spinner: sv)
//                    self.loadTagTable() //DELETE
//                })
//
//
//            } else {
//                // The query succeeded but no matching result was found
//                //self.displayMessage(message: "No Record Found")
//                print("NO MATCH FOUND")
//            }
//        }
//    }
    



    
//    func getVariationDescription(variation: WooProductVariation) -> String{
//        var attributes = [String]()
//        for attribute in variation.attributes! {
//            attributes.append(attribute.name! + ": " + attribute.option!)
//        }
//        return attributes.joined(separator: ", ")
//    }
    
    func configureWithCartItem(cartItem: CartModel) {
        self.cartItem = cartItem
        var placeholderImage:UIImage?
        
        //Romee5
        
        // Assign the labels.
        nameLabel.text = cartItem.tagTitle
        let q:Float = Float(cartItem.quantity)
        let totalPrice = (cartItem.price * q)
        priceLabel.text = formatPrice(value: totalPrice)
                
        //        availabilityLabel.text = (cartItem.variation != nil) ? getVariationDescription(variation: cartItem.variation!) : cartItem.product.categories?.first?.name
        
        //Show the RATING in the availability Label
        availabilityLabel.text = cartItem.rating
                
        quantityLabel.text = NSLocalizedString("quantity", comment: "") + ": \(cartItem.quantity)"
                
        quantityStepper.value = Double(cartItem.quantity)


        // Load the image from the network and give it the correct aspect ratio.
//        if (cartItem.product.images?.isEmpty == false) {
//            productImageView.sd_setImage(with: cartItem.product.images?[0].src);
//        }

                
        //==== IMAGE CODE ======================================
        //let cloudinaryAction = "Tag"
        //let usePhotoRef:String? = cartItem.tagObjectId
        //let photoNumber = 1
//                        let propertyPhotoFileUrl:String? = createNewPhotoURL(cloudinaryAction, withID: usePhotoRef, withNumber: photoNumber) ?? ""
                
                
        let photoRef:String = cartItem.tagPhotoRef
        var propertyPhotoFileUrl:String = ""
        if (photoRef.isEmpty) {
            propertyPhotoFileUrl = ""
        } else {
            propertyPhotoFileUrl = String(format: "%@%@-%@-%ld.jpg", SERVERFILENAME, "Tag", cartItem.tagPhotoRef, 1)
            //print("CARTPHOTO: \(propertyPhotoFileUrl)")
        }

                //productImageView.layer.cornerRadius
                //productImageView.frame.size.width
                productImageView.layer.masksToBounds = true
                productImageView.clipsToBounds = true
                
                productImageView.kf.indicatorType = .activity
                
//                // METHOD 1: ======================================
//                        productImageView.image = placeholderImage
//                        if let url = URL(string: propertyPhotoFileUrl ) {
//                            productImageView.image = resizedImage(at: url, for: CGSize(width: 88,height: 88))
//                        }
//
//                print(propertyPhotoFileUrl)
                
                // METHOD 2: ======================================
                if let url = URL(string: propertyPhotoFileUrl ) {
                    //            cell.tagImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
                    // Round corner
                    //let processor = RoundCornerImageProcessor(cornerRadius: 20)
        
                    /*
                     // Downsampling
                     let processor = DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))
        
                     // Cropping
                     let processor = CroppingImageProcessor(size: CGSize(width: 100, height: 100), anchor: CGPoint(x: 0.5, y: 0.5))
        
                     // Blur
                     let processor = BlurImageProcessor(blurRadius: 5.0)
        
                     // Overlay with a color & fraction
                     let processor = OverlayImageProcessor(overlay: .red, fraction: 0.7)
        
                     // Tint with a color
                     let processor = TintImageProcessor(tint: .blue)
        
                     // Adjust color
                     let processor = ColorControlsProcessor(brightness: 1.0, contrast: 0.7, saturation: 1.1, inputEV: 0.7)
        
                     // Black & White
                     let processor = BlackWhiteProcessor()
        
                     // Blend (iOS)
                     let processor = BlendImageProcessor(blendMode: .darken, alpha: 1.0, backgroundColor: .lightGray)
        
                     // Compositing
                     let processor = CompositingImageProcessor(compositingOperation: .darken, alpha: 1.0, backgroundColor: .lightGray)
        
                     // Use the process in view extension methods.
                     imageView.kf.setImage(with: url, options: [.processor(processor)])
                     */
                    //TODO: FIX SIZE
                    let processor = CroppingImageProcessor(size: CGSize(width: 100, height: 100), anchor: CGPoint(x: 0.5, y: 0.5))
                    let placeholderImage = UIImage(named: "icons8-camera-1")
                    productImageView.kf.setImage(with: url, placeholder: placeholderImage, options: [.processor(processor)])
                }
        
                //=================================================
                        productImageView.contentMode = .scaleAspectFit //APRIL 2018 WAS FILL
 
    }
}
