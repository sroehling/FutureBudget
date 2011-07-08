//
//  DataModelController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SharedAppValues;

@interface DataModelController : NSObject {
}

+(DataModelController*)theDataModelController; // singleton

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void) initializeDatabaseDefaults;
- (NSSet *)fetchObjectsForEntityName:(NSString *)entityName;
- (NSArray *)fetchSortedObjectsWithEntityName:(NSString *)entityName 
                                      sortKey:(NSString*)theSortKey;
- (bool) entitiesExistForEntityName:(NSString *)entityName;
- (NSFetchRequest*)createSortedFetchRequestWithEntityName:(NSString *)entityName
                                               andSortKey:(NSString*)theSortKey;
- (id)insertObject:(NSString*)entityName;
- (void)deleteObject:(NSManagedObject*)theObj;

@end
