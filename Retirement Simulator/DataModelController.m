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


@synthesize managedObjectContext=__managedObjectContext;

@synthesize managedObjectModel=__managedObjectModel;

@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

@synthesize sharedAppVals;


- (void)dealloc
{
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
	[sharedAppVals release];
    [super dealloc];
}

- (void)initOneRepeatFrequencyWithPeriod: (EventPeriod)thePeriod andMultiplier:(int)theMultiplier
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
	EventRepeatFrequency *repeatFrequency  = (EventRepeatFrequency*)
    [NSEntityDescription insertNewObjectForEntityForName:EVENT_REPEAT_FREQUENCY_ENTITY_NAME 
                                  inManagedObjectContext:context];
    repeatFrequency.period = [NSNumber numberWithInt:thePeriod];
    [repeatFrequency setPeriodWithPeriodEnum:thePeriod];
    repeatFrequency.periodMultiplier = [NSNumber numberWithInt:theMultiplier];
    NSLog(@"New default repeat frequency: %@",repeatFrequency.description);

}

- (void)initializeDatabaseDefaults
{
    NSLog(@"Initializing database with default data ...");
    
    
    if(![self entitiesExistForEntityName:EVENT_REPEAT_FREQUENCY_ENTITY_NAME])
    {
        [self initOneRepeatFrequencyWithPeriod:kEventPeriodOnce andMultiplier:1];
        [self initOneRepeatFrequencyWithPeriod:kEventPeriodWeek andMultiplier:1];
        [self initOneRepeatFrequencyWithPeriod:kEventPeriodWeek andMultiplier:2];
        [self initOneRepeatFrequencyWithPeriod:kEventPeriodMonth andMultiplier:1];
        [self initOneRepeatFrequencyWithPeriod:kEventPeriodMonth andMultiplier:3];
        [self initOneRepeatFrequencyWithPeriod:kEventPeriodMonth andMultiplier:6];
        [self initOneRepeatFrequencyWithPeriod:kEventPeriodYear andMultiplier:1];        
    }

    if(![self entitiesExistForEntityName:SHARED_APP_VALUES_ENTITY_NAME])
	{
		NSLog(@"Initializing shared values ...");
		SharedAppValues *sharedVals = [self insertObject:SHARED_APP_VALUES_ENTITY_NAME];
		NeverEndDate *theNeverEndDate = [self insertObject:NEVER_END_DATE_ENTITY_NAME];
		theNeverEndDate.date = [[[NSDate alloc] init] autorelease];
		sharedVals.sharedNeverEndDate = theNeverEndDate;
		
		DefaultScenario *defaultScenario = [self insertObject:DEFAULT_SCENARIO_ENTITY_NAME];
		sharedVals.defaultScenario = defaultScenario;

		self.sharedAppVals = sharedVals;

	}
	else
	{
		NSSet *theAppVals = [self fetchObjectsForEntityName:SHARED_APP_VALUES_ENTITY_NAME];
		assert([theAppVals count] == 1);
		self.sharedAppVals = (SharedAppValues*)[theAppVals anyObject];
	}
        
    [self saveContext];

    
}


+(DataModelController*)theDataModelController
{  
    static DataModelController *theDataModelController;  
    @synchronized(self)  
    {    if(!theDataModelController)      
            theDataModelController =[[DataModelController alloc] init];
            return theDataModelController;
    }
}

- (void)saveContext
{
    NSError *error = nil;
    if (self.managedObjectContext!= nil)
    {
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error])
        {
            /*
             TODO: Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ExampleCoreData.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
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
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
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
    return [NSEntityDescription insertNewObjectForEntityForName:entityName 
            inManagedObjectContext:self.managedObjectContext];
}

- (void)deleteObject:(NSManagedObject*)theObj
{
    assert(theObj != nil);
    [self.managedObjectContext deleteObject:theObj];
    [self saveContext];
    
}


@end
