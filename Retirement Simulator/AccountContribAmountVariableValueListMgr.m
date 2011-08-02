//
//  AccountContribAmountVariableValueListMgr.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AccountContribAmountVariableValueListMgr.h"
#import "Account.h"
#import "CollectionHelper.h"
#import "DataModelController.h"


@implementation AccountContribAmountVariableValueListMgr

@synthesize account;

- (id) initWithAccount:(Account*)theAccount
{
	self = [super init];
	if(self)
	{
		self.account = theAccount;
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
	[account release];
}


- (NSArray*)variableValues
{
	return [CollectionHelper setToSortedArray:self.account.variableContribAmounts withKey:@"name"];	
}

- (VariableValue*)createNewValue
{
	return (VariableValue*)[[DataModelController theDataModelController]
							insertObject:ACCOUNT_CONTRIB_AMOUNT_ENTITY_NAME];
	// The following properties must be filled in before the new objectwill be created.
    //    newVariableValue.name
    //    newVariableValue.startingValue
	
}

-(void)objectFinshedBeingAdded:(NSManagedObject*)addedObject
{
	[self.account addVariableContribAmountsObject:(VariableValue*)addedObject];
}

@end
