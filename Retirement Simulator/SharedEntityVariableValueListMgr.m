//
//  SharedEntityVariableValueListMgr.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SharedEntityVariableValueListMgr.h"
#import "DataModelController.h"


@implementation SharedEntityVariableValueListMgr

@synthesize entityName;

- (id) initWithEntity:(NSString *)theEntityName
{
	self = [super init];
	if(self)
	{
		assert([theEntityName length] > 0);
		self.entityName = theEntityName;
	}
	return self;
}

- (id) init
{
	assert(0); // must not be called
	return nil;
}

- (void) dealloc
{
	[super dealloc];
	[entityName release];
}


- (NSArray*)variableValues
{
	NSArray *variableValues = [[DataModelController theDataModelController]
		fetchSortedObjectsWithEntityName:self.entityName sortKey:@"name"];
	return variableValues;
}

- (VariableValue*)createNewValue
{
	return (VariableValue*)[[DataModelController theDataModelController]
					 insertObject:self.entityName];
	// The following properties must be filled in before the new objectwill be created.
    //    newVariableValue.name
    //    newVariableValue.startingValue

}

-(void)objectFinshedBeingAdded:(NSManagedObject*)addedObject
{
	// No-op for this type of VariableValueListMgr, since, the object is simply inserted
	// into the database table (i.e., there is reference from an individual object's private
	// list of variable values).
}


@end
