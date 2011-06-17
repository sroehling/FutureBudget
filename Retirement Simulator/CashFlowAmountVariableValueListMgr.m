//
//  CashFlowAmountVariableValueListMgr.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CashFlowAmountVariableValueListMgr.h"
#import "CashFlowInput.h"
#import "CollectionHelper.h"
#import "DataModelController.h"


@implementation CashFlowAmountVariableValueListMgr

@synthesize cashFlow;

- (id) initWithCashFlow:(CashFlowInput*)theCashFlow
{
	self = [super init];
	if(self)
	{
		self.cashFlow = theCashFlow;
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
	[cashFlow release];
}


- (NSArray*)variableValues
{
	return [CollectionHelper setToSortedArray:self.cashFlow.variableAmounts withKey:@"name"];	
}

- (VariableValue*)createNewValue
{
	return (VariableValue*)[[DataModelController theDataModelController]
							insertObject:@"CashFlowAmount"];
	// The following properties must be filled in before the new objectwill be created.
    //    newVariableValue.name
    //    newVariableValue.startingValue
	
}

-(void)objectFinshedBeingAdded:(NSManagedObject*)addedObject
{
	[self.cashFlow addVariableAmountsObject:(VariableValue*)addedObject];
}



@end
