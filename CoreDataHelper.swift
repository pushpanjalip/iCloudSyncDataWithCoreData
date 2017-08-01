//
//  CoreDataHelper.swift
//  ICloudWithCoreDtaSync
//
//  Created by Pushpanjali Pawar on 6/22/16.
//  Copyright © 2016 Pushpanjali Pawar. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject
{
    

    class func insertManagedObject(className:String,managedObjectContext:NSManagedObjectContext) -> AnyObject
    {
    
        let managedObject = NSEntityDescription.insertNewObjectForEntityForName(className, inManagedObjectContext: managedObjectContext) as NSManagedObject
        return managedObject
    
    }
    class func fetchEntities(className:String,managedObjectContext:NSManagedObjectContext,predicate:NSPredicate?)->NSArray
    {
    
        let fetchRequest=NSFetchRequest()
        let entityDecsription=NSEntityDescription.entityForName(className, inManagedObjectContext: managedObjectContext)
        fetchRequest.entity=entityDecsription
        if predicate != nil
        {
          fetchRequest.predicate=predicate!
        }
        
        fetchRequest.returnsObjectsAsFaults=false
        var items:NSArray=[]
        
        do {
            items = try managedObjectContext.executeFetchRequest(fetchRequest)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        return items
        
    
    }
}
    