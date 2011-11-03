//
//  ItemizedTaxAmtFieldPopulator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxAmtFieldPopulator.h"
#import "ItemizedTaxAmts.h"

#import "IncomeItemizedTaxAmt.h"
#import "ExpenseItemizedTaxAmt.h"

@implementation ItemizedTaxAmtFieldPopulator


@synthesize itemizedTaxAmts;

@synthesize itemizedIncomes;
@synthesize itemizedExpenses;
@synthesize itemizedAccountInterest;
@synthesize itemizedAccountContribs;
@synthesize itemizedAccountWithdrawals;
@synthesize itemizedAssets;
@synthesize itemizedLoans;


-(id)initWithItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts
{
	self = [super init];
	if(self)
	{
		assert(theItemizedTaxAmts != nil);
		self.itemizedTaxAmts = theItemizedTaxAmts;
		
		self.itemizedIncomes = [[[NSMutableArray alloc] init] autorelease];
		self.itemizedExpenses =  [[[NSMutableArray alloc] init] autorelease];
		self.itemizedAccountInterest = [[[NSMutableArray alloc] init] autorelease];
		self.itemizedAccountContribs = [[[NSMutableArray alloc] init] autorelease];
		self.itemizedAccountWithdrawals = [[[NSMutableArray alloc] init] autorelease];
		self.itemizedAssets = [[[NSMutableArray alloc] init] autorelease];
		self.itemizedLoans = [[[NSMutableArray alloc] init] autorelease];
		
		for(ItemizedTaxAmt *itemizedTaxAmt in self.itemizedTaxAmts.itemizedAmts)
		{
			assert(itemizedTaxAmt != nil);
			[itemizedTaxAmt acceptVisitor:self];
		}

	}
	return self;
}

-(void)visitIncomeItemizedTaxAmt:(IncomeItemizedTaxAmt *)itemizedTaxAmt
{
	assert(itemizedTaxAmt != nil);
	[self.itemizedIncomes addObject:itemizedTaxAmt];
}

-(void)visitExpenseItemizedTaxAmt:(ExpenseItemizedTaxAmt *)itemizedTaxAmt
{
	assert(itemizedTaxAmt != nil);
	[self.itemizedExpenses addObject:itemizedTaxAmt];
}

-(void)visitAccountInterestItemizedTaxAmt:(AccountInterestItemizedTaxAmt *)itemizedTaxAmt
{
	assert(itemizedTaxAmt != nil);
	[self.itemizedAccountInterest addObject:itemizedTaxAmt];
}

-(void)visitAccountContribItemizedTaxAmt:(AccountContribItemizedTaxAmt *)itemizedTaxAmt
{
	assert(itemizedTaxAmt != nil);
	[self.itemizedAccountContribs addObject:itemizedTaxAmt];
}

-(void)visitAccountWithdrawalItemizedTaxAmt:(AccountWithdrawalItemizedTaxAmt *)itemizedTaxAmt
{
	assert(itemizedTaxAmt != nil);
	[self.itemizedAccountWithdrawals addObject:itemizedTaxAmt];
}

-(void)visitAssetGainItemizedTaxAmt:(AssetGainItemizedTaxAmt *)itemizedTaxAmt
{
	assert(itemizedTaxAmt != nil);
	[self.itemizedAssets addObject:itemizedTaxAmt];
}

-(void)visitLoanInterestItemizedTaxAmt:(LoanInterestItemizedTaxAmt *)itemizedTaxAmt
{
	assert(itemizedTaxAmt != nil);
	[self.itemizedLoans addObject:itemizedTaxAmt];
}

-(void)dealloc
{
	[super dealloc];
	[itemizedTaxAmts release];
	
	[itemizedIncomes release];
	[itemizedExpenses release];
	[itemizedAccountInterest release];
	[itemizedAccountContribs release];
	[itemizedAccountWithdrawals release];
	[itemizedAssets release];
	[itemizedLoans release];
}

@end
