//
//  IncomeSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IncomeSimEventCreator.h"
#import "IncomeInput.h"
#import "IncomeSimEvent.h"


@implementation IncomeSimEventCreator

@synthesize income;

- (SimEvent*) createCashFlowSimEvent:(double)cashFlowAmount andEventDate:(NSDate*)theDate
{
	IncomeSimEvent *incomeEvent = [[[IncomeSimEvent alloc]initWithEventCreator:self 
			andEventDate:theDate ] autorelease];
	incomeEvent.income = self.income;
	incomeEvent.incomeAmount = cashFlowAmount;

	return incomeEvent;
}

- (id) initWithIncome:(IncomeInput *)theIncome
{
	self = [super initWithCashFlow:theIncome];
	if(self)
	{
		self.income = theIncome;
	}
	return self;
}

- (id)initWithCashFlow:(CashFlowInput *)theCashFlow
{
	assert(0); // must init with income
}

- (void)dealloc
{
	[super dealloc];
	[income release];
}

@end
