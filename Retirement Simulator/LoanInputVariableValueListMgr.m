//
//  LoanInputVariableValueListMgr.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoanInputVariableValueListMgr.h"
#import "DataModelController.h"
#import "VariableValue.h"
#import "CollectionHelper.h"
#import "LoanExtraPmtAmt.h"
#import "LoanDownPmtAmt.h"
#import "LoanCostAmt.h"


@implementation LoanInputVariableValueListMgr

@synthesize loan;
@synthesize variableValEntityName;

-(id)initWithLoan:(LoanInput*)theLoan andVariableValEntityName:(NSString*)theEntityName
{
	self = [super init];
	if(self)
	{
		assert(theLoan != nil);
		self.loan = theLoan;
		
		assert(theEntityName != nil);
		self.variableValEntityName = theEntityName;
	}
	return self;
}

-(id)initWithLoan:(LoanInput*)theLoan
{
	assert(0); // must be overridden
	return nil;
}


-(id)init
{
	assert(0); // must call with InputLoan
	return nil;
}

-(void)dealloc
{
	[super dealloc];
	[loan release];
	[variableValEntityName release];
}

- (VariableValue*)createNewValue
{
	return (VariableValue*)[[DataModelController theDataModelController]
							insertObject:self.variableValEntityName];
}

- (NSArray*)variableValues
{
	assert(0); // must be overridden
	return nil;	
}

-(void)objectFinshedBeingAdded:(NSManagedObject*)addedObject
{
	assert(0); // must be overriden
}

@end



@implementation LoanExtraPmtAmountVariableValueListMgr

-(id)initWithLoan:(LoanInput*)theLoan
{
	self = [super initWithLoan:theLoan andVariableValEntityName:LOAN_EXTRA_PMT_AMT_ENTITY_NAME];
	return self;
}

- (NSArray*)variableValues
{
	return [CollectionHelper setToSortedArray:self.loan.variableExtraPmtAmt withKey:@"name"];	
}

-(void)objectFinshedBeingAdded:(NSManagedObject*)addedObject
{
	[self.loan addVariableExtraPmtAmtObject:(VariableValue*)addedObject];
}

@end




@implementation LoanDownPmtAmountVariableValueListMgr

-(id)initWithLoan:(LoanInput*)theLoan
{
	self = [super initWithLoan:theLoan andVariableValEntityName:LOAN_DOWN_PMT_AMT_ENTITY_NAME];
	return self;
}

- (NSArray*)variableValues
{
	return [CollectionHelper setToSortedArray:self.loan.variableDownPmtAmt withKey:@"name"];	
}

-(void)objectFinshedBeingAdded:(NSManagedObject*)addedObject
{
	[self.loan addVariableDownPmtAmtObject:(VariableValue*)addedObject];
}

@end



@implementation LoanCostAmtVariableValueListMgr

-(id)initWithLoan:(LoanInput*)theLoan
{
	self = [super initWithLoan:theLoan andVariableValEntityName:LOAN_COST_AMT_ENTITY_NAME];
	return self;
}

- (NSArray*)variableValues
{
	return [CollectionHelper setToSortedArray:self.loan.variableLoanCostAmt withKey:@"name"];	
}

-(void)objectFinshedBeingAdded:(NSManagedObject*)addedObject
{
	[self.loan addVariableLoanCostAmtObject:(VariableValue*)addedObject];
}

@end
