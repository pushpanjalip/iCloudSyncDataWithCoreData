
iCloud + Sync +Core Data
https://www.youtube.com/watch?v=SG_XSD84WOc
https://www.youtube.com/channel/UCysEngjfeIYapEER9K8aikw



# iCloudSyncDataWithCoreDataiCloud Storage 
•	Create an App Id:
Go to your developer center.
Click on identifiers->AppId
Give name and bundle identifier
Enable iCloud for app id
Go to edit and tick on icloud compability
Again click on edit in front of iCloud
Choose container for your app
In your Xcode project Go to Capabilities->enable iCloud
Check iCloud Documents
Use default Container and you can see the container below


When we enable iCloud in Xcode it will automatically create projname.entitlement file in your project
•	Create SingleView Application with Core Data
Create subclass of NSObject “CoreDataHelper”





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

•	Create Data models in projname.xcdatamodeld
Create NSManagedObject classes  which we’ll be use to access these data models
Select both entities and click on editor-> create NSManagedObject subclass
You can choose language for these subclasses
If you choose objective-c then create bridgim=ng header and import Note.h and Notebook.h  

•	Open AppDelegate.swift and make changes

lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        /*For iCloud*/
        
        let documentDirectory=NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last! as NSURL
        let storeURL=documentDirectory.URLByAppendingPathComponent("CoreData.sqlite")  //file for coreData database
        
        let storeOptions = [NSPersistentStoreUbiquitousContentNameKey:"CloudNoteStore"]  //provides iCloud capability
        
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: storeOptions)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
 
be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
//Changes highlighted in red














•	In TableViewController.swift
Create variables
var moc:NSManagedObjectContext!
var notebookArray=[Notebook]()

override  func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let context = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        {
            moc=context
        
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NotebookTableViewController.persistentStoreDidChange), name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NotebookTableViewController.persistentWillChange(_:)), name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: moc.persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NotebookTableViewController.receiveICloudChange(_:)), name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: moc.persistentStoreCoordinator)
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

