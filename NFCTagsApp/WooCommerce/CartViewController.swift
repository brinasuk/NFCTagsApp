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
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(stepperValueChanged), name: Notification.Name("STEPPERVALUECHANGED"), object: nil)
        
        title = "Shopping Cart"
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.tableFooterView = UIView()
        
        //TODO: PUT BACK
        cartFooter.configureWithCart(cart: cart)

        // Put a label as the background view to display when the cart is empty.
        let emptyCartLabel = UILabel()
        emptyCartLabel.numberOfLines = 0
        emptyCartLabel.textAlignment = .center
        emptyCartLabel.textColor = UIColor.darkGray
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
        
        @objc func stepperValueChanged(_ notification: Notification) {
            //let cartItem = ownerObjects[indexPath.row] //The Vige
            print("stepperValueChanged")
            //ROMEE4
            if let dict = notification.userInfo as? [String: String]
            {
                var cartObjectId:String? = dict["OBJECTID"]
                //UPDATE QUANTITY
                //LOADOBJECTS
            }

        }
        
            func loadObjects()
            {
                let query = PFQuery(className: "Cart")
                query.whereKey("userEmail", equalTo:kAppDelegate.currentUserEmail!)
                query.order(byDescending: "updatedDate")
                query.order(byAscending: "rating")
                
                query.limit = 30
                ownerObjects = []  //or removeAll
                var rowCount = 0
                
                let sv = UIViewController.displaySpinner(onView: self.view)
                
                query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                    
                    if let error = error {
                        UIViewController.removeSpinner(spinner: sv)
                        // Log details of the failure
                        print(error.localizedDescription)
                    } else if let objects = objects {
                        
                        for object in objects {
                            
                            let createdAt:Date = object.createdAt!
                            let tagObjectId:String = object.objectId! //Used for Photo Name
                            
                            //TODO: SEE HERE HOW IT IS DONE
                            //let alex = object["ownerPhone"] as? String ?? ""
                            //print(alex)
                            
                            let tagTitle = object["tagTitle"] as? String ?? ""
                            let userName = object["userName"] as? String ?? ""
                            let userEmail = object["userEmail"] as? String ?? ""
                            let rating = object["rating"] as? String ?? ""
                            let tagPrice = object["tagPrice"] as? String ?? ""
                            let price:Float = object["price"] as? Float ?? 0.0
                            let quantity:Int = object["quantity"] as? Int ?? 1

                            let newObject = CartModel(createdAt: createdAt, tagObjectId: tagObjectId, tagTitle: tagTitle, userName: userName, userEmail: userEmail, rating: rating,tagPrice: tagPrice, price: price, quantity: quantity)
                            
                            
                            ownerObjects.append(newObject)
                            rowCount = rowCount + 1
                        }
                    }
                    
                    //RUN ON MAIN THREAD
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.toggleEmptyCartLabel()
                        UIViewController.removeSpinner(spinner: sv)
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
        let cartItem = ownerObjects[indexPath.row] //The Vige

        // Keep a weak reference on the table view.
        cell.cartItemQuantityChangedCallback = { [unowned self] in
            self.refreshCartDisplay()
            self.tableView.reloadData()
            self.cartFooter.configureWithCart(cart: self.cart)
        }


        // Configure the cell with the cart item.
        cell.configureWithCartItem(cartItem: cartItem)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.accessoryView = UIImageView(image: UIImage(named: "DisclosureIndicator"))
        
        cell.accessoryType = .detailDisclosureButton
        
        cell.backgroundColor = backgroundColor

        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        print(indexPath.row)
            
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

         @objc private func refreshCartDisplay() {
            //TODO: PUT BACK
             cartFooter.configureWithCart(cart: cart)
             toggleEmptyCartLabel()
         }

         private func toggleEmptyCartLabel() {
            print(numberOfItems)
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


}
