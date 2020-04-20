//
//  CartViewController.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 4/17/20.
//  Copyright © 2020 Hillside Software. All rights reserved.
//


import Parse
import UIKit
import Kingfisher
import Alertift
import Alamofire
import AlamofireImage
import PKHUD


private var ownerObjects:[CartModel] = []
private var cellIdentifier = "CartItemCell"
private var placeholderImage:UIImage?
private var numberOfItems:Int = 0


    final class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartFooter: CartFooterCell!
    private let cart = Cart.sharedInstance

        override func awakeFromNib() {
            super.awakeFromNib()

            //TODO: PUT BACK
            // Listen to notifications about the cart being updated.
//            NotificationCenter.default.addObserver(self, selector: #selector(refreshCartDisplay), name: NSNotification.Name(rawValue: Cart.cartUpdatedNotificationName), object: self.cart)
            
        NotificationCenter.default.addObserver(self, selector: #selector(stepperValueChanged), name: Notification.Name("STEPPERVALUECHANGED"), object: nil)
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping Cart"
        setupDarkMode()
        setupNavigationBar()

//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goBackButtonPressed))
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        //self.navigationItem.leftBarButtonItem  = button1
        
//        backButton:UIBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backButt"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackButtonPressed)]
        
//        self.navigationItem.leftBarButtonItem = backButton;
        
        tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.backgroundColor = backgroundColor
        
        //SET BACKGROUND COLOR BEHIND TABLE
        self.view.backgroundColor = backgroundColor
        //HIDE EMPTY CELLS WHEM YOU HAVE TOO FEW TO FILL THE TABLE
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.tableFooterView = UIView()
        
        // Put a label as the background view to display when the cart is empty.
        let emptyCartLabel = UILabel()
        emptyCartLabel.numberOfLines = 0
        emptyCartLabel.textAlignment = .center
        emptyCartLabel.textColor = mainColor
        emptyCartLabel.font = UIFont.systemFont(ofSize: CGFloat(20))
        emptyCartLabel.text = NSLocalizedString("cart_empty", comment: "")
        self.tableView.backgroundView = emptyCartLabel
        self.tableView.backgroundView?.isHidden = true
        self.tableView.backgroundView?.alpha = 0
        loadObjects()
    }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.tableView.reloadData()
            toggleEmptyCartLabel()
        }
        
        @objc func goBackButtonPressed() {
            dismiss(animated: true, completion: nil)
        }
        
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

        //navigationController?.navigationBar.barTintColor = .systemGreen
                    
        //THE FOLLOWING LINE IS CRITICAL TO SHOW THE BACKARROW WHEN CHOOSING SHOP AS FIRST OPTION FROM MENU!!
        navigationController?.navigationBar.tintColor =  mainColor
                    
                    
//        self.navigationController!.navigationBar.titleTextAttributes =
//          [NSAttributedString.Key.backgroundColor: navbarBackColor]

                    } else {

                    //METHOD2. NOT iOS13
                    if let customFont = UIFont(name: "Rubik-Medium", size: 34.0) {
                        navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor .darkText, NSAttributedString.Key.font: customFont ]
                        }
                    }
            }
        
        @objc func stepperValueChanged(_ notification: Notification) {
            //let cartItem = ownerObjects[indexPath.row] //The Vige
            print("stepperValueChanged")
            //ROMEE4
            if let dict = notification.userInfo as? [String: String]
            {
                let cartObjectId:String = dict["OBJECTID"]!
                let stepperValue:String = dict["STEPPERVALUE"]!
                updateCartQuantity(objectId: cartObjectId, stepperValue: stepperValue)
            }

        }
        
            func loadObjects()
            {
                let query = PFQuery(className: "Cart")
                query.whereKey("userEmail", equalTo:kAppDelegate.currentUserEmail!)
                query.whereKey("paidUp",equalTo: "N")
                query.order(byDescending: "updatedDate")
                query.order(byAscending: "rating")
                
                query.limit = 30
                ownerObjects = []  //or removeAll
                var rowCount = 0
                
                //HUD.show(.progress)
                //HUD.show(.labeledProgress(title: "Title", subtitle:"SubTitle"))


//              let sv = UIViewController.displaySpinner(onView: self.view)
                HUD.show(.progress)
                query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                    
                    if let error = error {
//                        UIViewController.removeSpinner(spinner: sv)
                        HUD.show(.error)
                        HUD.hide(afterDelay: 2.0)
                        // Log details of the failure
                        print(error.localizedDescription)
                    } else if let objects = objects {
                        
                        for object in objects {
                            
                            let createdAt:Date = object.createdAt!
                            let tagObjectId:String = object.objectId! 
                            
                            //TODO: SEE HERE HOW IT IS DONE
                            //let alex = object["ownerPhone"] as? String ?? ""
                            //print(alex)
                            
                            let tagTitle = object["tagTitle"] as? String ?? ""
                            let tagPhotoRef = object["tagPhotoRef"] as? String ?? ""
                            let userName = object["userName"] as? String ?? ""
                            let userEmail = object["userEmail"] as? String ?? ""
                            let rating = object["rating"] as? String ?? ""
                            let tagPrice = object["tagPrice"] as? String ?? ""
                            let paidUp = object["paidUp"] as? String ?? ""
                            let price:Float = object["price"] as? Float ?? 0.0
                            let quantity:Int = object["quantity"] as? Int ?? 1

                            let newObject = CartModel(createdAt: createdAt, tagObjectId: tagObjectId,tagPhotoRef: tagPhotoRef, tagTitle: tagTitle, userName: userName, userEmail: userEmail, rating: rating,tagPrice: tagPrice, paidUp: paidUp, price: price, quantity: quantity)
                            
                            
                            ownerObjects.append(newObject)
                            rowCount = rowCount + 1
                        }

                    }
                    
                    //RUN ON MAIN THREAD
                    DispatchQueue.main.async {
                        

                        self.tableView.reloadData()
                        self.configureWithCart()
                        HUD.hide()
//                        UIViewController.removeSpinner(spinner: sv)
                    }
                }
            }
            
        // MARK: UITableViewDelegate

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            return 80
        }
        
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfItems = ownerObjects.count
        return numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CartItemCell

        // Find the corresponding cart item.
        //let cartItem = cart.items[indexPath.row]
        let cartItem = ownerObjects[indexPath.row]

        // Configure the cell with the cart item.
        cell.configureWithCartItem(cartItem: cartItem)
        cell.backgroundColor = navbarBackColor //backgroundColor
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.accessoryView = UIImageView(image: UIImage(named: "DisclosureIndicator"))
        
        cell.accessoryType = .detailDisclosureButton
        
        cell.backgroundColor = backgroundColor

        return cell
    }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                //objects.remove(at: indexPath.row)
    //            ReallySimpleNoteStorage.storage.removeNote(at: indexPath.row)
    //            tableView.deleteRows(at: [indexPath], with: .fade)
                let cartItem = ownerObjects[indexPath.row]
            
                //self.deleteObjectId = note.noteObjectId
                 //print("DELETE1 + \(self.deleteObjectId)")
                 
                 Alertift.alert(title: "Remove Item",message: "Are you sure you wish to Remove this Item?")
                     .action(.default("Yes"), isPreferred: true) { (_, _, _) in
                         //print("YES!")
                        //let sv = UIViewController.displaySpinner(onView: self.view)
                        
                        self.removeCartItem(objectId: cartItem.tagObjectId)
                        
                     }
                     .action(.cancel("No")) { (_, _, _) in
                         //print("No/Cancel Clicked")
                     }
                     .show()

            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            }
        }
        
        
         
         //TODO: HANDLE DELETE
         /*
         func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                                 forRowAt indexPath: IndexPath) {
             guard editingStyle == .delete else { return }

              Remove this item from the cart and refresh the table view.
             cart.items.remove(at: indexPath.row)

              Either delete some rows within the section (leaving at least one) or the entire section.
             if cart.items.count > 0 {
                 tableView.deleteRows(at: [indexPath], with: .fade)
             } else {
                 let set = IndexSet(arrayLiteral: indexPath.section)
                 tableView.deleteSections(set, with: .fade)
             }
         }

*/

         // MARK: Utilities


        
        
//        @objc private func refreshCartDisplay() {
//            //TODO: PUT BACK
//            //ROMEE6
////             cartFooter.configureWithCart(cart: cart)
////             toggleEmptyCartLabel()
//         }

 
        
        func removeCartItem(objectId: String) {
            //print("DELETE2 + \(self.deleteObjectId)")
            let query = PFQuery(className: "Cart")
            //let sv = UIViewController.displaySpinner(onView: self.view)
            HUD.show(.progress)
            
            query.getObjectInBackground(withId: objectId) { (object: PFObject?, error: Error?) in
                if let error = error {
                    // The query failed
                    //UIViewController.removeSpinner(spinner: sv)
                    HUD.show(.error)
                    HUD.hide(afterDelay: 2.0)
                    print(error.localizedDescription)
                    //self.displayMessage(message: error.localizedDescription)
                } else if let object = object {
                    // The query succeeded with a matching result
                    print("SUCCESS DELETED")

                    object.deleteInBackground(block: { (deleteSuccessful, error) -> Void in
                        // User deleted
                        //self.tableView.reloadData()
                        //UIViewController.removeSpinner(spinner: sv)
                        HUD.hide()
                        self.loadObjects() //DELETE
                    })
                    
                } else {
                    // The query succeeded but no matching result was found
                    //self.displayMessage(message: "No Record Found")
                    print("NO MATCH FOUND")
                }
            }
        }
        
        func updateCartQuantity(objectId: String, stepperValue:  String) {
            let query = PFQuery(className: "Cart")
            //let sv = UIViewController.displaySpinner(onView: self.view)
            HUD.show(.progress)
            
            query.getObjectInBackground(withId: objectId) { (object: PFObject?, error: Error?) in
                if let error = error {
                    // The query failed
                    //UIViewController.removeSpinner(spinner: sv)
                    HUD.show(.error)
                    HUD.hide(afterDelay: 2.0)
                    print(error.localizedDescription)
                    //self.displayMessage(message: error.localizedDescription)
                } else if let object = object {
                    // The query succeeded with a matching result
                    print("Match Found")
                    object["quantity"] = Int(stepperValue)
                    
                    object.saveInBackground(block: { (deleteSuccessful, error) -> Void in
                        // User deleted
                        //UIViewController.removeSpinner(spinner: sv)
                        HUD.hide()
                        self.loadObjects()
                    })
                    
                } else {
                    // The query succeeded but no matching result was found
                    //self.displayMessage(message: "No Record Found")
                    print("NO MATCH FOUND")
                }
            }
        }
        

        
            func configureWithCart() {
                let totalCartItemsCount = ownerObjects.count
                var totalCartPrice:Float = 0.0
                var totalPrice:Float = 0.0
                var q:Float = 0

                for i in 0..<ownerObjects.count {
                    let cartItem = ownerObjects[i]
                    q = Float(cartItem.quantity)
                    totalPrice = (cartItem.price * q)
                    totalCartPrice = totalCartPrice + totalPrice
                }
 
                if (totalCartItemsCount > 1) {
                    cartFooter.totalItemsLabel.text = "\(totalCartItemsCount) " + NSLocalizedString("items", comment: "")
                } else {
                    cartFooter.totalItemsLabel.text = NSLocalizedString("item_one", comment: "")
                }
                cartFooter.totalPriceLabel.text = formatPrice(value:totalCartPrice)
                
                toggleEmptyCartLabel()
            }
        
        private func toggleEmptyCartLabel() {
            cartFooter.totalPriceLabel.textColor = mainColor
            cartFooter.totalItemsLabel.textColor = mainColor
            cartFooter.backgroundColor = secondarySystemBackground
            
            if (numberOfItems > 0) {  //cart.isEmpty() {
                UIView.animate(withDuration: 0.15,
                    animations: {
                        self.tableView.backgroundView!.alpha = 0
                    },
                    completion: { finished in
                        self.tableView.backgroundView!.isHidden = false
                        self.cartFooter.isHidden = false
                    }
                )
             } else {
                UIView.animate(withDuration: 0.15) {
                    self.tableView.backgroundView!.isHidden = false
                    self.cartFooter.isHidden = true
                    self.tableView.backgroundView!.alpha = 1
                }
             }
         }
        
        @IBAction func orderReceivedButtonPressed(_ sender: Any) {
            processOrder()
        }
        
        func processOrder()
        {
            let query = PFQuery(className: "Cart")
            query.whereKey("userEmail", equalTo:kAppDelegate.currentUserEmail!)
            query.whereKey("paidUp",equalTo: "N")
            query.order(byDescending: "updatedDate")
            query.order(byAscending: "rating")
            
            HUD.show(.labeledProgress(title: "Cart", subtitle:"Processing"))
            
                query.findObjectsInBackground(block: { results, error in
                var saveAllOfMe: [AnyHashable] = []
                for object in results ?? [] {
//                    guard let object = object as? PFObject else {
//                        continue
//                    }
                    object["paidUp"] = "Y"
                    saveAllOfMe.append(object)
                }
                    PFObject.saveAll(inBackground: saveAllOfMe as? [PFObject], block: { success, error in
                    // Check result of the operation, all objects should have been saved by now
                        //print("DONE!")
                        HUD.hide()
                        self.performSegue(withIdentifier: "ORDERRECEIVEDSEGUE", sender: self)
                })
            })
        }

}


