//
//  SharedEntityVariableValueListMgr.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SharedEntityVariableValueListMgr.h"
#import "DataModelController.h"
#import "VariableValue.h"


@implementation SharedEntityVariableValueListMgr

@synthesize entityName;
@synthesize dataModelController;

- (id) initWithDataModelController:(DataModelController*)theDataModelController 
		andEntity:(NSString *)theEntityName
{
	self = [super init];
	if(self)
	{
		assert([theEntityName length] > 0);
		self.entityName = theEntityName;
		
		assert(theDataModelController != nil);
		self.dataModelController = theDataModelController;
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
	[entityName release];
	[dataModelController release];
	[super dealloc];
}


- (NSArray*)variableValues
{
	NSArray *variableValues = [self.dataModelController
		fetchSortedObjectsWithEntityName:self.entityName sortKey:VARIABLE_VALUE_DISPLAY_ORDER_KEY];
	return variableValues;
}

- (VariableValue*)createNewValue
{
	return (VariableValue*)[self.dataModelController insertObject:self.entityName];
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
