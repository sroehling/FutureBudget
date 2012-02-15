//
//  DataModelController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataModelController.h"
#import "EventRepeatFrequency.h"
#import "SharedAppValues.h"
#import "NeverEndDate.h"
#import "DefaultScenario.h"


@implementation DataModelController

@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)dealloc
{
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    [super dealloc];
}


- (void)initCoreDataObjects
{
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" 
			withExtension:@"momd"];
	self.managedObjectModel = [[[NSManagedObjectModel alloc] 
			initWithContentsOfURL:modelURL] autorelease];

	self.persistentStoreCoordinator = [[[NSPersistentStoreCoordinator alloc] 
			initWithManagedObjectModel:self.managedObjectModel] autorelease]; 

	self.managedObjectContext =[[[NSManagedObjectContext alloc] init] autorelease];
	
	// Undo Support - By default, on iOS, there is no undo manager. Setting this is needed
	// so that all changes are catalogued for the rollbackUncommittedChanges method.    
	[self.managedObjectContext setUndoManager:[[[NSUndoManager  alloc] init] autorelease]];        
	
	self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
}


-(id) init
{
	self = [super init];
	if(self)
	{
		[self initCoreDataObjects];
		
		NSError *error;
		NSURL *storeURL = [[self applicationDocumentsDirectory] 
			URLByAppendingPathComponent:@"AppData.sqlite"];
		if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
			configuration:nil URL:storeURL options:nil error:&error])
		{
        /*
         TODO - Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			[NSException raise:NSGenericException format:[error description] arguments:nil];
		}
	}
	return self;
 
}

- (id) initForInMemoryStorage
{
	self = [super init];
	if(self)
	{
		[self initCoreDataObjects];
		NSError *error = nil;
		if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType 
			configuration:nil URL:nil options:nil error:&error])
		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			[NSException raise:NSGenericException format:[error description] arguments:nil];
		}
		
	}
	return self;
}

    static DataModelController *theDataModelController;  


+(DataModelController*)tmpSingletonDataModelControllerForMultiScenarioInputValue
{  
	assert(theDataModelController != nil);
	return theDataModelController;
}

+(void)initTmpSingletonDataModelControllerForMultiScenarioInputValue:(DataModelController*)dmcSingleton
{
	assert(dmcSingleton != nil);
	theDataModelController = dmcSingleton;
}



- (void)saveContext
{
    NSError *error = nil;
    if (self.managedObjectContext!= nil)
    {
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error])
        {
             NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			[NSException raise:NSGenericException format:[error description] arguments:nil];
        } 
    }
}

-(void)startObservingContextChanges:(id)observer withSelector:(SEL)theSelector
{
	assert(observer != nil);
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	assert(dnc != nil);
	[dnc addObserver:observer selector:theSelector
		name:NSManagedObjectContextObjectsDidChangeNotification 
		  object:self.managedObjectContext];
}

-(void)stopObservingContextChanges:(id)observer
{
	assert(observer != nil);
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	assert(dnc != nil);
    [dnc removeObserver:observer 
		name:NSManagedObjectContextObjectsDidChangeNotification 
		object:self.managedObjectContext];

}


- (void)rollbackUncommittedChanges
{
	if(self.managedObjectContext != nil)
	{
		NSSet *uncommittedChanges = [self.managedObjectContext updatedObjects];
		for(NSManagedObject *uncommittedChange in uncommittedChanges)
		{
			NSLog(@"Rolling back changes: %@",[uncommittedChange description]);
		}
		[self.managedObjectContext undo];
	}
}

- (void)saveContextAndIgnoreErrors
{
    NSError *error = nil;
    if (self.managedObjectContext!= nil)
    {
        if ([self.managedObjectContext hasChanges])
		{
			[self.managedObjectContext save:&error];
		}
    }
}




- (NSFetchRequest*)createSortedFetchRequestWithEntityName:(NSString *)entityName
                                               andSortKey:(NSString*)theSortKey
{
    assert(entityName!=nil);
    assert(theSortKey!=nil);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:theSortKey ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    
    [fetchRequest autorelease];
    [sortDescriptor release];
    [sortDescriptors release];

    return fetchRequest;
    
}

- (NSArray*)executeFetchOrThrow:(NSFetchRequest*)fetchReq
{
    assert(fetchReq != nil);
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchReq 
                                                                error:&error];
    if (error != nil)
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [NSException raise:NSGenericException format:[error description] arguments:nil];
    }
    return results;
}

// Convenience method to retrieve all the objects for a given entity name.
- (NSSet *)fetchObjectsForEntityName:(NSString *)entityName
{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entityName 
                                   inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entity];
    
    
     return [NSSet setWithArray:[self executeFetchOrThrow:request]];
}

- (NSArray *)fetchSortedObjectsWithEntityName:(NSString *)entityName sortKey:(NSString*)theSortKey
{    
    NSFetchRequest *fetchRequest = [self createSortedFetchRequestWithEntityName:entityName andSortKey:theSortKey];
    
	return [self executeFetchOrThrow:fetchRequest];

}


- (NSArray*)fetchResults:(NSString*)entityName includePendingChanges:(BOOL)doIncludePendingChanges
{

	NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entityName 
                                   inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entity];
	
	// IMPORTANT: The default for includesPendingChanges is TRUE, meaning
	// the returned results will include any pending changes not saved
	// to the persistent store. Setting to FALSE gives a results that mirrors
	// what is actually stored.
	request.includesPendingChanges = doIncludePendingChanges;
	
	
   NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request 
                                                                error:&error];
    if (error != nil)
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [NSException raise:NSGenericException format:[error description] arguments:nil];
    }

	return results;
}

- (bool) entitiesExistForEntityName:(NSString *)entityName
{
    NSSet *entities = [self fetchObjectsForEntityName:entityName];
    if([entities count] > 0)
    {
        return true;
    }
    else
    {
        return false;
    }
}


- (id)insertObject:(NSString*)entityName
{
    assert(entityName != nil);
    assert([entityName length] >0);
	
	id theObject = [NSEntityDescription insertNewObjectForEntityForName:entityName 
            inManagedObjectContext:self.managedObjectContext];
	assert(theObject != nil);
	[theObject retain];
	[theObject autorelease];
	return theObject;
}

- (id)createDataModelObject:(NSString *)entityName
{
	return [self insertObject:entityName];
}

- (void)deleteObject:(NSManagedObject*)theObj
{
    assert(theObj != nil);
    [self.managedObjectContext deleteObject:theObj];
}


@end
