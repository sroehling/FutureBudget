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

-(id)initWithMultiScenarioAmount:(MultiScenarioAmount *)theAmount
{
	self = [super init];
	if(self)
	{
		assert(theAmount != nil);
		self.amount = theAmount;
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
	[super dealloc];
	[amount release];
}


- (NSArray*)variableValues
{
	return [CollectionHelper setToSortedArray:self.amount.variableAmounts withKey:@"name"];	
}

- (VariableValue*)createNewValue
{
	return (VariableValue*)[[DataModelController theDataModelController]
							insertObject:MULTI_SCENARIO_VARIABLE_VALUE_ENTITY_NAME];	
}

-(void)objectFinshedBeingAdded:(NSManagedObject*)addedObject
{
	[self.amount addVariableAmountsObject:(VariableValue*)addedObject];
}


@end
