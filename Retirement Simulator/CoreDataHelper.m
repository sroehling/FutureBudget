//
//  CoreDataHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataHelper.h"
#import "StringValidation.h"

@implementation CoreDataHelper


+ (id)insertObjectWithEntityName:(NSString*)entityName
	inManagedObectContext:(NSManagedObjectContext*)managedObjContext
{
	assert([StringValidation nonEmptyString:entityName]);
	assert(managedObjContext != nil);
	
	id theObject = [NSEntityDescription insertNewObjectForEntityForName:entityName 
            inManagedObjectContext:managedObjContext];
	assert(theObject != nil);
	[theObject retain];
	[theObject autorelease];
	return theObject;
}

+(BOOL)sameCoreDataObjects:(NSManagedObject*)obj1 comparedTo:(NSManagedObject*)obj2
{
	NSURL *obj1Rep = [[obj1 objectID] URIRepresentation];
	NSURL *obj2Rep = [[obj2 objectID] URIRepresentation];
	return [obj1Rep isEqual:obj2Rep];
}

+ (NSArray*)executeFetchOrThrow:(NSFetchRequest*)fetchReq 
	inManagedObectContext:(NSManagedObjectContext*)managedObjContext
{
    assert(fetchReq != nil);
	assert(managedObjContext != nil);

    NSError *error = nil;
    NSArray *results = [managedObjContext executeFetchRequest:fetchReq 
                                                                error:&error];
    if (error != nil)
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [NSException raise:NSGenericException format:[error description] arguments:nil];
    }
    return results;
}


+(NSSet *)fetchObjectsForEntityName:(NSString *)entityName 
		inManagedObectContext:(NSManagedObjectContext*)managedObjContext
{
	assert([StringValidation nonEmptyString:entityName]);
	assert(managedObjContext != nil);

    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entityName 
                                   inManagedObjectContext:managedObjContext];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entity];
    
    
     return [NSSet setWithArray:[self executeFetchOrThrow:request inManagedObectContext:managedObjContext]];
}

+(NSManagedObject*)fetchSingleObjectForEntityName:(NSString *)entityName 
		inManagedObectContext:(NSManagedObjectContext*)managedObjContext
{
	assert([StringValidation nonEmptyString:entityName]);
	assert(managedObjContext != nil);

	NSSet *theObjs = [CoreDataHelper fetchObjectsForEntityName:entityName
		inManagedObectContext:managedObjContext];
	assert([theObjs count] == 1);
	NSManagedObject *theObj = (NSManagedObject*)[theObjs anyObject];
	assert(theObj != nil);
	[theObj retain];
	[theObj autorelease];
	return theObj;
}



@end
