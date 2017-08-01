//
//  NotebookOverviewTableViewController.swift
//  ICloudWithCoreDtaSync
//
//  Created by Pushpanjali Pawar on 6/23/16.
//  Copyright © 2016 Pushpanjali Pawar. All rights reserved.
//

import UIKit
import CoreData
class NotebookOverviewTableViewController: UITableViewController {
    var selectedNote:Notebook!

    var moc:NSManagedObjectContext!
    var notesArray = [Note]()
    var newNote:Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.Cancel,target: self,action: #selector(NotebookOverviewTableViewController.dismissVC))
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add,target: self,action: #selector(NotebookOverviewTableViewController.addNote))
        

        
    }

    override  func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let context = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        {
            moc=context
            
        }
        
        newNote=nil
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NotebookTableViewController.persistentStoreDidChange), name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NotebookTableViewController.persistentWillChange(_:)), name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: moc.persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NotebookTableViewController.receiveICloudChange(_:)), name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: moc.persistentStoreCoordinator)
        
        self.loadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: moc.persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: moc.persistentStoreCoordinator)
        
    }
    func loadData()
    {
        notesArray=[Note]()
        let unsortedNotes=NSMutableArray()
        
        for singleNote in selectedNote.note!
        {
        
            let loopNote=singleNote as! Note
            unsortedNotes.addObject(loopNote)
        }
        let sortDescriptor=NSSortDescriptor(key: "creationDate",ascending: true)
        
        notesArray = unsortedNotes.sortedArrayUsingDescriptors([sortDescriptor]) as! [Note]
        self.tableView.reloadData()
    }
    
    func dismissVC()
    {
    
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    func addNote()
    {
    
        let note=CoreDataHelper.insertManagedObject(NSStringFromClass(Note), managedObjectContext: self.moc) as! Note
        note.createdDate = NSDate()
        selectedNote.addNoteObject(note)

        do {
            try self.moc.save()
        } catch let error as NSError {
            
            NSLog("Unresolved error \(error), \(error.userInfo)")
            // Handle Error
        }
        newNote=note
        self.performSegueWithIdentifier("showSingleNote", sender: self)
        

    
        //prepareSegue
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notesArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel?.text=notesArray[indexPath.row].title
        

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="showSingleNote"
        {
        let noteVC = segue.destinationViewController as! SingleNoteViewController
            if let segueNote = newNote
            {
             noteVC.selectedNote=newNote
            }
            else
            {
                if let index=self.tableView.indexPathForSelectedRow
                {
                noteVC.selectedNote = notesArray[index.row]
                }
            
            }
        }
    }
    

}
