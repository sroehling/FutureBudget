//
//  InMemoryCoreData.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataModelInterface.h"

@interface InMemoryCoreData : NSObject <DataModelInterface> {
    @private
	   NSManagedObjectModel *managedObjModel;
	   NSPersistentStoreCoordinator *persistentStoreCoord;
	   NSManagedObjectContext *managedObjContext;
}

@property(nonatomic,retain) NSManagedObjectModel *managedObjModel;
@property(nonatomic,retain) NSPersistentStoreCoordinator *persistentStoreCoord;
@property(nonatomic,retain) NSManagedObjectContext *managedObjContext;

- (id)createObj:(NSString*)entityName;
- (void)deleteObject:(NSManagedObject*)theObj;
- (void)saveContext;
- (NSArray*)fetchResults:(NSString*)entityName includePendingChanges:(BOOL)doIncludePendingChanges;

@end
