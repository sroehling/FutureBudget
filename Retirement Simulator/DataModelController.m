//
//  DataModelController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataModelController.h"
#import "EventRepeatFrequency.h"


@implementation DataModelController


@synthesize managedObjectContext=__managedObjectContext;

@synthesize managedObjectModel=__managedObjectModel;

@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;


- (void)dealloc
{
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [super dealloc];
}

- (void)initOneRepeatFrequencyWithPeriod: (EventPeriod)thePeriod andMultiplier:(int)theMultiplier
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
	EventRepeatFrequency *repeatFrequency  = (EventRepeatFrequency*)
    [NSEntityDescription insertNewObjectForEntityForName:@"EventRepeatFrequency" 
                                  inManagedObjectContext:context];
    repeatFrequency.period = [NSNumber numberWithInt:thePeriod];
    [repeatFrequency setPeriodWithPeriodEnum:kEventPeriodOnce];
    repeatFrequency.periodMultiplier = [NSNumber numberWithInt:theMultiplier];

}

- (void)initializeDatabaseDefaults
{
    NSLog(@"Initializing database with default data ...");
    
    
    if(![self entitiesExistForEntityName:@"EventRepeatFrequency"])
    {
        [self initOneRepeatFrequencyWithPeriod:kEventPeriodOnce andMultiplier:1];
        [self initOneRepeatFrequencyWithPeriod:kEventPeriodWeek andMultiplier:1];
        [self initOneRepeatFrequencyWithPeriod:kEventPeriodWeek andMultiplier:2];
        [self initOneRepeatFrequencyWithPeriod:kEventPeriodMonth andMultiplier:1];
        [self initOneRepeatFrequencyWithPeriod:kEventPeriodMonth andMultiplier:3];
        [self initOneRepeatFrequencyWithPeriod:kEventPeriodMonth andMultiplier:6];
        [self initOneRepeatFrequencyWithPeriod:kEventPeriodYear andMultiplier:1];        
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
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
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
        abort();
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

// Convenience method to retrieve all the objects for a given entity name.
- (NSSet *)fetchObjectsForEntityName:(NSString *)entityName
{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entityName 
                                   inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request 
                                                                error:&error];
    if (error != nil)
    {
        [NSException raise:NSGenericException format:[error description] arguments:nil];
    }
    
    return [NSSet setWithArray:results];
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


@end
