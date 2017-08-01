//
//  Notebook+CoreDataProperties.h
//  ICloudWithCoreDtaSync
//
//  Created by Pushpanjali Pawar on 6/22/16.
//  Copyright © 2016 Pushpanjali Pawar. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Notebook.h"

NS_ASSUME_NONNULL_BEGIN

@interface Notebook (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *creationDate;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *note;

@end

@interface Notebook (CoreDataGeneratedAccessors)

- (void)addNoteObject:(NSManagedObject *)value;
- (void)removeNoteObject:(NSManagedObject *)value;
- (void)addNote:(NSSet<NSManagedObject *> *)values;
- (void)removeNote:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
