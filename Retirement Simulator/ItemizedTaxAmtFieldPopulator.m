//
//  ItemizedTaxAmtFieldPopulator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxAmtFieldPopulator.h"

#import "IncomeItemizedTaxAmt.h"
#import "ItemizedTaxAmts.h"

@implementation ItemizedTaxAmtFieldPopulator

@synthesize itemizedIncomes;
@synthesize itemizedTaxAmts;


-(id)initWithItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts
{
	self = [super init];
	if(self)
	{
		assert(theItemizedTaxAmts != nil);
		self.itemizedTaxAmts = theItemizedTaxAmts;
		
		self.itemizedIncomes = [[[NSMutableArray alloc] init] autorelease];
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

-(void)dealloc
{
	[super dealloc];
	[itemizedTaxAmts release];
}

@end
