//
//  LoanEarlyPayoffDigestEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LoanEarlyPayoffDigestEntry.h"
#import "LoanSimInfo.h"
#import "InterestBearingWorkingBalance.h"
#import "DigestEntryProcessingParams.h"
#import "WorkingBalanceMgr.h"


@implementation LoanEarlyPayoffDigestEntry

@synthesize loanInfo;

- (id)initWithLoanInfo:(LoanSimInfo*)theLoanInfo
{
	self = [super init];
	if(self)
	{
		assert(theLoanInfo != nil);
		self.loanInfo = theLoanInfo;
	}
	return self;
}


-(id) init
{
	assert(0); // must init with balance and payment amount
	return nil;
}

-(void)processDigestEntry:(DigestEntryProcessingParams*)processingParams
{
	double balancePaid = [self.loanInfo.loanBalance zeroOutBalanceAsOfDate:processingParams.currentDate];
		
	[processingParams.workingBalanceMgr decrementBalanceFromFundingList:balancePaid 
		asOfDate:processingParams.currentDate];
}


- (void)dealloc
{
	[loanInfo release];
	[super dealloc];
}


@end
