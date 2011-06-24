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

- (id) init
{
	self = [super init];
	if(self)
	{
		self.managedObjModel =
		   [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
		self.persistentStoreCoord =[[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjModel] autorelease]; 
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

- (void) dealloc
{
	[super dealloc];
	[managedObjModel release];
	[persistentStoreCoord release];
	
}

@end
