//
//  MasterViewController.swift
//  rsnt-really-simple-note-taking-ios
//
//  Created by Németh László Harri on 2019. 01. 21..
//  Copyright © 2019. Németh László Harri. All rights reserved.
//

import UIKit
import Parse

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    private var noteObjects:[NoteModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotesTable()
        
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
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
 
        //ALEX
//        if let split = splitViewController {
//            let controllers = split.viewControllers
//            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
//        }
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
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                //let object = objects[indexPath.row]
                let object = ReallySimpleNoteStorage.storage.readNote(at: indexPath.row)
//                let controller = (segue.destination as! UINavigationController).topViewController as! NoteDetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
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
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //objects.remove(at: indexPath.row)
            ReallySimpleNoteStorage.storage.removeNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
    


}

