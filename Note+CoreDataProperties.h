//
//  Note+CoreDataProperties.h
//  ICloudWithCoreDtaSync
//
//  Created by Pushpanjali Pawar on 6/22/16.
//  Copyright © 2016 Pushpanjali Pawar. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Note.h"

NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSDate *createdDate;
@property (nullable, nonatomic, retain) Notebook *notebook;

@end

NS_ASSUME_NONNULL_END
