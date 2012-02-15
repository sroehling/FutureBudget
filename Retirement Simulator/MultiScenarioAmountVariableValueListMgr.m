//
//  MultiScenarioAmountVariableValueListMgr.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiScenarioAmountVariableValueListMgr.h"
#import "MultiScenarioVariableValue.h"

#import "MultiScenarioAmount.h"
#import "DataModelController.h"
#import "CollectionHelper.h"
#import "VariableValue.h"


@implementation MultiScenarioAmountVariableValueListMgr

@synthesize amount;
@synthesize dataModelController;

-(id)initWithDataModelController:(DataModelController*)theDataModelController 
	andMultiScenarioAmount:(MultiScenarioAmount *)theAmount
{
	self = [super init];
	if(self)
	{
		assert(theAmount != nil);
		self.amount = theAmount;
		
		assert(theDataModelController != nil);
		self.dataModelController = theDataModelController;
	}
	return self;
}

-(id)init
{
	// must init with asset
	assert(0);
	return nil;
}



- (void)dealloc
{
	[amount release];
	[super dealloc];
}


- (NSArray*)variableValues
{
	return [CollectionHelper setToSortedArray:self.amount.variableAmounts withKey:VARIABLE_VALUE_DISPLAY_ORDER_KEY];	
}

- (VariableValue*)createNewValue
{
	return (VariableValue*)[self.dataModelController
							insertObject:MULTI_SCENARIO_VARIABLE_VALUE_ENTITY_NAME];	
}

-(void)objectFinshedBeingAdded:(NSManagedObject*)addedObject
{
	[self.amount addVariableAmountsObject:(VariableValue*)addedObject];
}


@end
