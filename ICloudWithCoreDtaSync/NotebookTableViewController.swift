//
//  NotebookTableViewController.swift
//  ICloudWithCoreDtaSync
//
//  Created by Pushpanjali Pawar on 6/22/16.
//  Copyright © 2016 Pushpanjali Pawar. All rights reserved.
//

import UIKit
import CoreData

class NotebookTableViewController: UITableViewController {

    var moc:NSManagedObjectContext!
    var notebookArray=[Notebook]()  //holds notebook class objects
    override func viewDidLoad() {
        super.viewDidLoad()

    //we have to wait for icloud to set up so we'll disable UI or you can add loading(Activity indicator)
        self.navigationItem.title="Waiting for iCloud"
        self.navigationItem.rightBarButtonItem?.enabled=false
        
    
    }

    
    
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: moc.persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: moc.persistentStoreCoordinator)
        
    }
    
    func persistentStoreDidChange()
    {
     //Re-Enable UI and Fetch Data
        self.navigationItem.title="iCloud Ready"
        self.navigationItem.rightBarButtonItem?.enabled=true
        self.loadData()
    }
    func persistentWillChange(notification:NSNotification)
    {
        self.navigationItem.title="Changes In Progress"
        
        //Disable UI
        self.navigationItem.rightBarButtonItem?.enabled=false
        moc.performBlock{() -> Void in
            if self.moc.hasChanges
            {
                do {
                    try self.moc.save()
                } catch let error as NSError {
                    
                    NSLog("Unresolved error \(error), \(error.userInfo)")
                    // Handle Error
                }
                
                //drop any managed object
                self.moc.reset()
             }
        }
    
    }
    func receiveICloudChange(notification:NSNotification)
    {
        moc.performBlock{() -> Void in
        self.moc.mergeChangesFromContextDidSaveNotification(notification)
            self.loadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notebookArray.count
    }

    @IBAction func AddNotebook(sender: AnyObject)
    {
        
        let alertController = UIAlertController(title: "New Notebook", message: "Enter notebook tile", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler(nil)
        alertController.addAction( UIAlertAction (title:"Save Notebook",style:.Default,handler:{(action:UIAlertAction)->Void in
        let textField=(alertController.textFields?.last)! as UITextField
            if(textField.text != "")
            {
            let notebook=CoreDataHelper.insertManagedObject(NSStringFromClass(Notebook), managedObjectContext: self.moc) as! Notebook
                notebook.title=textField.text
                notebook.creationDate=NSDate()
                do {
                    try self.moc.save()
                } catch let error as NSError {
                    
                    NSLog("Unresolved error \(error), \(error.userInfo)")
                    // Handle Error
                }
                
                self.loadData()
            }
        }))
        alertController.addAction(UIAlertAction(title:"Cancel",style: .Cancel,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func loadData()
    {
     notebookArray=[Notebook]()
     notebookArray = CoreDataHelper.fetchEntities(NSStringFromClass(Notebook), managedObjectContext: self.moc, predicate: nil) as! [Notebook]
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text=notebookArray[indexPath.row].title

    

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
        if segue.identifier=="ShowNotes"
        {
         let noteOverViewVC=segue.destinationViewController as! NotebookOverviewTableViewController
            if let index=self.tableView.indexPathForSelectedRow
            {
            noteOverViewVC.selectedNote=notebookArray[index.row]
            }
            
        }
    }
    
}
