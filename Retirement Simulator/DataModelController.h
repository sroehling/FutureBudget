//
//  DataModelController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataModelInterface.h"

@class SharedAppValues;

@interface DataModelController : NSObject <DataModelInterface> {
}

+(DataModelController*)theDataModelController; // singleton

- (id) initForInMemoryStorage; // In for in-memory storage (for testing)

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSSet *)fetchObjectsForEntityName:(NSString *)entityName;
- (NSArray *)fetchSortedObjectsWithEntityName:(NSString *)entityName 
                                      sortKey:(NSString*)theSortKey;
- (bool) entitiesExistForEntityName:(NSString *)entityName;
- (NSFetchRequest*)createSortedFetchRequestWithEntityName:(NSString *)entityName
                                               andSortKey:(NSString*)theSortKey;
- (id)insertObject:(NSString*)entityName;
- (void)deleteObject:(NSManagedObject*)theObj;

@end
