//
//  DataModelController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataModelInterface.h"

@interface DataModelController : NSObject <DataModelInterface> {
	@private
		// The saveEnabled flag, which is enabled by default, can be 
		// disabled by view controllers. The applicability is the
		// creation of new objects, when changes shouldn't be 
		// saved until the top-level view controller has verified
		// the new object is fully populated and valid for saving.
		BOOL saveEnabled;
}

- (id) initForInMemoryStorage; // In for in-memory storage (for testing)

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property BOOL saveEnabled;

- (void)saveContext;
- (void)saveContextAndIgnoreErrors;
- (void)rollbackUncommittedChanges;
-(void)startObservingContextChanges:(id)observer withSelector:(SEL)theSelector;
-(void)stopObservingContextChanges:(id)observer;


- (NSSet *)fetchObjectsForEntityName:(NSString *)entityName;
- (NSArray *)fetchSortedObjectsWithEntityName:(NSString *)entityName 
                                      sortKey:(NSString*)theSortKey;
- (bool) entitiesExistForEntityName:(NSString *)entityName;
- (NSFetchRequest*)createSortedFetchRequestWithEntityName:(NSString *)entityName
                                               andSortKey:(NSString*)theSortKey;
- (id)insertObject:(NSString*)entityName;
- (void)deleteObject:(NSManagedObject*)theObj;

	
@end
