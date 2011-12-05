//
//  CashFlowDigestEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IncomeDigestEntry.h"
#import "InputValDigestSummation.h"
#import "WorkingBalanceMgr.h"
#import "DigestEntryProcessingParams.h"

@implementation IncomeDigestEntry


-(void)processDigestEntry:(DigestEntryProcessingParams*)processingParams
{
	[self.cashFlowSummation adjustSum:self.amount onDay:processingParams.dayIndex];
	[processingParams.workingBalanceMgr incrementCashBalance:self.amount 
			asOfDate:processingParams.currentDate];
}



@end
