//
//  MasterViewController.swift
//  rsnt-really-simple-note-taking-ios
//
//  Created by Németh László Harri on 2019. 01. 21..
//  Copyright © 2019. Németh László Harri. All rights reserved.
//

import UIKit
import Parse
import Alertift

class NotesViewController: UITableViewController {

    //THE FOLLOWING 4 VARIABLES PASSED FROM DETAILVIEWCONTROLLER
    var currentTagId:String = ""
    var currentPhotoRef:String = ""
    var currentNoteOwner:String = ""
    var currentNoteTagTitle:String = ""
    
    var detailViewController: DetailViewController? = nil
    private var noteObjects:[NoteModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //THE FOLLOWING TWO VARIABLES ARE PASSED FROM THE TAG RECORD FOR ADDNEW
        //TODO: ALEX FIX THIS
//        currentTagId = "g0p978oKXB"
//        currentPhotoRef = "wsBAstguyt"
        
        print("currentTagId: \(currentTagId)")
        print("currentPhotoRef: \(currentPhotoRef)")
        print("currentNoteOwner: \(currentNoteOwner)")
        print("currentNoteTagTitle: \(currentNoteTagTitle)")
        
        self.title = currentNoteTagTitle

        setupDarkMode()
        setupNavigationBar()
        
        tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.backgroundColor = backgroundColor
        
        //SET BACKGROUND COLOR BEHIND TABLE
        self.view.backgroundColor = backgroundColor
        //HIDE EMPTY CELLS WHEM YOU HAVE TOO FEW TO FILL THE TABLE
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
//    //navigationController?.navigationBar.prefersLargeTitles = false
//        navigationItem.largeTitleDisplayMode = .never
//        navigationController?.navigationBar.tintColor = mainColor

        

        
//        // Core data initialization
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            // create alert
//            let alert = UIAlertController(
//                title: "Could not get app delegate",
//                message: "Could not get app delegate, unexpected error occurred. Try again later.",
//                preferredStyle: .alert)
//
//            // add OK action
//            alert.addAction(UIAlertAction(title: "OK",
//                                          style: .default))
//            // show alert
//            self.present(alert, animated: true)
//
//            return
//        }
        
//        // As we know that container is set up in the AppDelegates so we need to refer that container.
//        // We need to create a context from this container
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        // set context in the storage
//        ReallySimpleNoteStorage.storage.setManagedContext(managedObjectContext: managedContext)
        

        
        // Do any additional setup after loading the view, typically from a nib.
        //navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        loadNotesTable()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //setupNavigationBar()
    }
    
    func  setupDarkMode() {
        if  (kAppDelegate.isDarkMode == true)
            {if #available(iOS 13.0, *) {overrideUserInterfaceStyle = .dark}
        } else
            {if #available(iOS 13.0, *) {overrideUserInterfaceStyle = .light}
        }
    }
        
//    func  setupDarkMode() {
//    if (kAppDelegate.isDarkMode == true) {
//        if #available(iOS 13.0, *) {
//            overrideUserInterfaceStyle = .dark
//        } else {
//            // Fallback on earlier versions
//        }} else {if #available(iOS 13.0, *) {
//        overrideUserInterfaceStyle = .light
//    } else {
//        // Fallback on earlier versions
//        kAppDelegate.isDarkMode = false
//        }}
//    }
    
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
    
    func loadNotesTable()
    {
        let query = PFQuery(className:"Notes")

        query.whereKey("noteTagId", equalTo: currentTagId)

        query.order(byDescending: "updatedAt")
        query.limit = 500
        noteObjects = []  //or removeAll
        var rowCount = 0
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            if let error = error {
                UIViewController.removeSpinner(spinner: sv)
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                // The find succeeded.
//                print("Successfully retrieved \(objects.count) NOTE objects.")
                UIViewController.removeSpinner(spinner: sv)
                for object in objects {
                    
                    let createdAt:Date = object.createdAt!
                    let noteObjectId:String = object.objectId!
                    let noteTitle:String? = object["noteTitle"] as? String ?? ""
                    let noteText:String? = object["noteText"] as? String ?? ""
                    let noteTagId:String? = object["noteTagId"] as? String ?? ""
                    let notePhotoRef:String? = object["notePhotoRef"] as? String ?? ""
                    
                    let noteOwner:String? = object["noteOwner"] as? String ?? ""
                    let noteTagTitle:String? = object["noteTagTitle"] as? String ?? ""
                    
                    let newObject = NoteModel(createdAt: createdAt,noteObjectId: noteObjectId, noteTitle: noteTitle!, noteText: noteText!, noteTagId: noteTagId!, notePhotoRef: notePhotoRef!, noteOwner: noteOwner!, noteTagTitle: noteTagTitle!)

                    self.noteObjects.append(newObject)
                    rowCount = rowCount + 1
                }
                self.tableView.reloadData()
            }
        }
    }


    @objc
    func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "showCreateNoteSegue", sender: self)
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //ADDED BY ALEX
        if segue.identifier == "showCreateNoteSegue" {
            let vc = segue.destination as! NoteCreateChangeViewController
            vc.passTagId = currentTagId
            vc.passPhotoRef = currentPhotoRef
            vc.passNoteOwner = currentNoteOwner
            vc.passNoteTagTitle = currentNoteTagTitle

        }
        
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                //let object = objects[indexPath.row]
                //TODO: ALEX FIX READNOTE
//                let object = ReallySimpleNoteStorage.storage.readNote(at: indexPath.row)
                
//                let controller = (segue.destination as! UINavigationController).topViewController as! NoteDetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
                
                let note:NoteModel = noteObjects[indexPath.row]
                //let alex:Date = note.createdAt
                
                let destinationController = segue.destination as! NoteDetailViewController
                destinationController.detailItem = note //object
                destinationController.currentNoteObjectId = note.noteObjectId
            }
        }
    }

    // MARK: - Table View
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return objects.count
        //print(self.noteObjects.count)
        //return ReallySimpleNoteStorage.storage.count()
        return self.noteObjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoteTableViewCell
        
        let object = self.noteObjects[indexPath.row]
        
        cell.selectionStyle = .none  //CRITICAL. DONT SHOW A GREY BACKGROUND WHEN SELECTED
        cell.backgroundColor = backgroundColor
        cell.noteTitleLabel.textColor = textColor
        cell.noteTextLabel.textColor = mainColor

        cell.noteDateLabel.textColor = secondaryLabel


        /*
        HelveticaNeue-Bold,HelveticaNeue-CondensedBlack,HelveticaNeue-Medium,HelveticaNeue,HelveticaNeue-Light,HelveticaNeue-CondensedBold,HelveticaNeue-LightItalic,HelveticaNeue-UltraLightItalic,HelveticaNeue-UltraLight,HelveticaNeue-BoldItalic,HelveticaNeue-Italic
        */
 
        cell.noteTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        cell.noteDateLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        cell.noteTextLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        
        cell.noteTitleLabel!.text = object.noteTitle
        cell.noteTextLabel!.text = object.noteText
        
        
        //ReallySimpleNoteDateHelper.convertDate(date: Date.init(seconds: object.noteTimeStamp))
        //TODO: Implement currentLocale = NSLocale.current as NSLocale
        //let date = cellDataParse.object(forKey: "createdAt") as? Date ?? NSDate() as Date
        let date = object.createdAt
        let format = DateFormatter()
        format.dateFormat = "EEE, MMM d, h:mm a"
        //@"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
        let formattedDate = format.string(from: date)

        cell.noteDateLabel!.text = "Date: " + formattedDate
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //objects.remove(at: indexPath.row)
//            ReallySimpleNoteStorage.storage.removeNote(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
            let note = self.noteObjects[indexPath.row]
            //self.deleteObjectId = note.noteObjectId
             //print("DELETE1 + \(self.deleteObjectId)")
             
             Alertift.alert(title: "Remove Item",message: "Are you sure you wish to Remove this Item?")
                 .action(.default("Yes"), isPreferred: true) { (_, _, _) in
                     //print("YES!")
                    //let sv = UIViewController.displaySpinner(onView: self.view)
                    
                    self.removeNote(objectId: note.noteObjectId)
                     //ReallySimpleNoteStorage.removeItem(note.noteObjectId)
                 }
                 .action(.cancel("No")) { (_, _, _) in
                     //print("No/Cancel Clicked")
                 }
                 .show()

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //TODO: NEVER USE THE FOLLOWING LINE. IT DESTROYS PASSING ANYTHING IN THE SEGUE!!!
        //tableView.deselectRow(at: indexPath, animated: true)
        
        //self.currentRow = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: self)//showCreateNoteSegue
    }
    
    func removeNote(objectId: String) {
        //print("DELETE2 + \(self.deleteObjectId)")
        let query = PFQuery(className: "Notes")
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        query.getObjectInBackground(withId: objectId) { (object: PFObject?, error: Error?) in
            if let error = error {
                // The query failed
                UIViewController.removeSpinner(spinner: sv)
                print(error.localizedDescription)
                //self.displayMessage(message: error.localizedDescription)
            } else if let object = object {
                // The query succeeded with a matching result
                print("SUCCESS DELETED")

                object.deleteInBackground(block: { (deleteSuccessful, error) -> Void in
                    // User deleted
                    //self.tableView.reloadData()
                    UIViewController.removeSpinner(spinner: sv)
                    self.loadNotesTable() //DELETE
                })
                
                
            } else {
                // The query succeeded but no matching result was found
                //self.displayMessage(message: "No Record Found")
                print("NO MATCH FOUND")
            }
        }
    }
    
@IBAction func unwindToMaster(segue:UIStoryboardSegue) {
    //print("BACK HERE")
    loadNotesTable()
    }
    
}

