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

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    private var noteObjects:[NoteModel] = []
    var currentTagId:String = ""
    var currentPhotoRef:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Notes"
        
        //THE FOLLOWING TWO VARIABLES ARE PASSED FROM THE TAG RECORD FOR ADDNEW
        //TODO: ALEX FIX THIS
        currentTagId = "g0p978oKXB"
        currentPhotoRef = "wsBAstguyt"
        
        // Core data initialization
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            // create alert
            let alert = UIAlertController(
                title: "Could not get app delegate",
                message: "Could not get app delegate, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            // add OK action
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default))
            // show alert
            self.present(alert, animated: true)

            return
        }
        
        // As we know that container is set up in the AppDelegates so we need to refer that container.
        // We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // set context in the storage
        ReallySimpleNoteStorage.storage.setManagedContext(managedObjectContext: managedContext)
        

        
        // Do any additional setup after loading the view, typically from a nib.
        //navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
 
        //ALEX
//        if let split = splitViewController {
//            let controllers = split.viewControllers
//            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
//        }
        
        loadNotesTable()
    }

    override func viewWillAppear(_ animated: Bool) {
//ALEX        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        
    }
    
    func loadNotesTable()
    {
        let query = PFQuery(className:"Notes")

        //query.whereKey("userEmail", equalTo: userEmail!)
        //query.order(byDescending: "createdAt")
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
                print("Successfully retrieved \(objects.count) NOTE objects.")
                UIViewController.removeSpinner(spinner: sv)
                for object in objects {
                    
                    let createdAt:Date = object.createdAt!
                    let noteObjectId:String = object.objectId!
                    let noteTitle:String? = object["noteTitle"] as? String ?? ""
                    let noteText:String? = object["noteText"] as? String ?? ""
                    let noteTagId:String? = object["noteTagId"] as? String ?? ""
                    let notePhotoRef:String? = object["notePhotoRef"] as? String ?? ""
                    
                    let newObject = NoteModel(createdAt: createdAt,noteObjectId: noteObjectId, noteTitle: noteTitle!, noteText: noteText!, noteTagId: noteTagId!, notePhotoRef: notePhotoRef!)

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
            let vc = segue.destination as! ReallySimpleNoteCreateChangeViewController
            vc.passTagId = currentTagId
            vc.passPhotoRef = currentPhotoRef
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
                
                let destinationController = segue.destination as! NoteDetailViewController
                destinationController.detailItem = note //object
                destinationController.currentNoteObjectId = note.noteObjectId
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return objects.count
        //return ReallySimpleNoteStorage.storage.count()
        return self.noteObjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ReallySimpleNoteUITableViewCell
        
//        let cellIdentifier = "Cell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AuteurTableViewCell
        
        let object = self.noteObjects[indexPath.row]
        
//        if let object = ReallySimpleNoteStorage.storage.readNote(at: indexPath.row) {
//        cell.noteTitleLabel!.text = object.noteTitle
//        cell.noteTextLabel!.text = object.noteText
//        cell.noteDateLabel!.text = ReallySimpleNoteDateHelper.convertDate(date: Date.init(seconds: object.noteTimeStamp))
//        }
            
        cell.noteTitleLabel!.text = object.noteTitle
        cell.noteTextLabel!.text = object.noteText
        cell.noteDateLabel!.text = "ALEX FIX" //ReallySimpleNoteDateHelper.convertDate(date: Date.init(seconds: object.noteTimeStamp))
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
        performSegue(withIdentifier: "showDetail", sender: self)
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
    print("BACK HERE")
    loadNotesTable()
    }
    
}

