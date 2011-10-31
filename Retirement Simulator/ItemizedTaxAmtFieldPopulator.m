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
@synthesize itemizedSavingsInterest;


-(id)initWithItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts
{
	self = [super init];
	if(self)
	{
		assert(theItemizedTaxAmts != nil);
		self.itemizedTaxAmts = theItemizedTaxAmts;
		
		self.itemizedIncomes = [[[NSMutableArray alloc] init] autorelease];
		self.itemizedExpenses =  [[[NSMutableArray alloc] init] autorelease];
		self.itemizedSavingsInterest = [[[NSMutableArray alloc] init] autorelease];
		
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

-(void)visitSavingsInterestItemizedTaxAmt:(SavingsInterestItemizedTaxAmt *)itemizedTaxAmt
{
	assert(itemizedTaxAmt != nil);
	[self.itemizedSavingsInterest addObject:itemizedTaxAmt];
}

-(void)dealloc
{
	[super dealloc];
	[itemizedTaxAmts release];
	
	[itemizedIncomes release];
	[itemizedExpenses release];
	[itemizedSavingsInterest release];
}

@end
