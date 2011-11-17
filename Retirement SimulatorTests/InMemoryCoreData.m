//
//  InMemoryCoreData.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InMemoryCoreData.h"


@implementation InMemoryCoreData

@synthesize managedObjModel;
@synthesize persistentStoreCoord;
@synthesize managedObjContext;

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory 
		inDomains:NSUserDomainMask] lastObject];
}


- (id) init
{
	self = [super init];
	if(self)
	{
		NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
		self.managedObjModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] autorelease];
	//	self.managedObjModel =
	//	   [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
		self.persistentStoreCoord =[[[NSPersistentStoreCoordinator alloc] 
			initWithManagedObjectModel:self.managedObjModel] autorelease]; 
	
	NSError *error = nil;

		
/*		
	NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TestData.sqlite"];
    if (![self.persistentStoreCoord addPersistentStoreWithType:NSSQLiteStoreType 
	   configuration:nil URL:storeURL options:nil error:&error])	
*/


		if (![self.persistentStoreCoord addPersistentStoreWithType:NSInMemoryStoreType 
			configuration:nil URL:nil options:nil error:&error])

		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			[NSException raise:NSGenericException format:[error description] arguments:nil];
		}    

		
		self.managedObjContext =[[[NSManagedObjectContext alloc] init] autorelease];  
		
		
		
		
		self.managedObjContext.persistentStoreCoordinator = self.persistentStoreCoord;
			
	}
	return self;
}

- (id)createObj:(NSString*)entityName
{
	return [NSEntityDescription insertNewObjectForEntityForName:entityName 
					inManagedObjectContext:self.managedObjContext];
}


- (id)createDataModelObject:(NSString*)entityName
{
	return [self createObj:entityName];
}


- (void)deleteObject:(NSManagedObject*)theObj
{
    assert(theObj != nil);
    [self.managedObjContext deleteObject:theObj];
}


- (NSArray*)fetchResults:(NSString*)entityName includePendingChanges:(BOOL)doIncludePendingChanges
{

	NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entityName 
                                   inManagedObjectContext:self.managedObjContext];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entity];
	
	// IMPORTANT: The default for includesPendingChanges is TRUE, meaning
	// the returned results will include any pending changes not saved
	// to the persistent store. Setting to FALSE gives a results that mirrors
	// what is actually stored.
	request.includesPendingChanges = doIncludePendingChanges;
	
	
   NSError *error = nil;
    NSArray *results = [self.managedObjContext executeFetchRequest:request 
                                                                error:&error];
    if (error != nil)
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [NSException raise:NSGenericException format:[error description] arguments:nil];
    }

	return results;
}


- (void)saveContext
{
    NSError *error = nil;
    if (self.managedObjContext!= nil)
    {
        if ([self.managedObjContext hasChanges] && ![self.managedObjContext save:&error])
        {
             NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			[NSException raise:NSGenericException format:[error description] arguments:nil];
        } 
    }
}


- (void) dealloc
{
	[super dealloc];
	[managedObjModel release];
	[persistentStoreCoord release];
	
}

@end
