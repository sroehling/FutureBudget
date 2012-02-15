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
#import "IncomeSimInfo.h"
#import "SimParams.h"


@implementation IncomeSimEventCreator

@synthesize incomeInfo;

- (SimEvent*) createCashFlowSimEvent:(double)cashFlowAmount andEventDate:(NSDate*)theDate
{
	IncomeSimEvent *incomeEvent = [[[IncomeSimEvent alloc]initWithEventCreator:self 
			andEventDate:theDate ] autorelease];
	incomeEvent.incomeInfo = self.incomeInfo;
	incomeEvent.incomeAmount = cashFlowAmount;

	return incomeEvent;
}


- (id)initWithIncomeSimInfo:(IncomeSimInfo*)theIncomeSimInfo
{
	self = [super initWithCashFlow:theIncomeSimInfo.income 
		andSimStartDate:theIncomeSimInfo.simParams.simStartDate];
	if(self)
	{
		assert(theIncomeSimInfo != nil);
		self.incomeInfo = theIncomeSimInfo;
	}
	return self;

}

- (id)initWithCashFlow:(CashFlowInput *)theCashFlow
{
	assert(0); // must init with income info
}

- (void)dealloc
{
	[incomeInfo release];
	[super dealloc];
}

@end
