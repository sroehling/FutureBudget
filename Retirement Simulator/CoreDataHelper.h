//
//  CoreDataHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CoreDataHelper : NSObject {
    
}

+ (id)insertObjectWithEntityName:(NSString*)entityName
	inManagedObectContext:(NSManagedObjectContext*)managedObjContext;
+(BOOL)sameCoreDataObjects:(NSManagedObject*)obj1 comparedTo:(NSManagedObject*)obj2;

+ (NSArray*)executeFetchOrThrow:(NSFetchRequest*)fetchReq 
	inManagedObectContext:(NSManagedObjectContext*)managedObjContext;
+(NSSet *)fetchObjectsForEntityName:(NSString *)entityName 
		inManagedObectContext:(NSManagedObjectContext*)managedObjContext;
+(NSManagedObject*)fetchSingleObjectForEntityName:(NSString *)entityName 
		inManagedObectContext:(NSManagedObjectContext*)managedObjContext;

@end
