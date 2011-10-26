//
//  ExpenseDigestEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExpenseDigestEntry.h"
#import "InputValDigestSummation.h"
#import "WorkingBalanceMgr.h"
#import "DigestEntryProcessingParams.h"

@implementation ExpenseDigestEntry

-(void)processDigestEntry:(DigestEntryProcessingParams*)processingParams
{
	[self.cashFlowSummation incrementSum:self.amount];
	
	[processingParams.workingBalanceMgr decrementBalanceFromFundingList:self.amount 
		asOfDate:processingParams.currentDate];
}


@end
