//
//  SingleNoteViewController.swift
//  ICloudWithCoreDtaSync
//
//  Created by Pushpanjali Pawar on 6/23/16.
//  Copyright © 2016 Pushpanjali Pawar. All rights reserved.
//

import UIKit

class SingleNoteViewController: UIViewController {

    @IBOutlet weak var noteView: UITextView!
    
    var moc:NSManagedObjectContext!
    var selectedNote:Note!
    var textField:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let context = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        {
            moc=context
            
        }
        
        textField = UITextField()
        textField.frame=CGRectMake(0, 0, 200, 30)
        textField.font=UIFont.boldSystemFontOfSize(19)
        textField.textAlignment = .Center
        
        self.navigationItem.titleView=textField
        
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop,target: self,action: #selector(SingleNoteViewController.dismissVC))
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save,target: self,action: #selector(SingleNoteViewController.saveNote))
        
        if let noteTitle=selectedNote.title
        {
         textField.text=noteTitle
        }
        else
        {
         textField.text="insert title here"
        }
        
        if let contentView=selectedNote.content
        {
         noteView.text=contentView
        }
        else
        {
         noteView.text=""
        }
        
    }
    func dismissVC()
    {
    self.navigationController?.popToRootViewControllerAnimated(true)
        
    }

    func saveNote()
    {
    
        selectedNote.title=textField.text
        selectedNote.content=noteView.text
        do {
            try self.moc.save()
        } catch let error as NSError {
            
            NSLog("Unresolved error \(error), \(error.userInfo)")
            // Handle Error
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
