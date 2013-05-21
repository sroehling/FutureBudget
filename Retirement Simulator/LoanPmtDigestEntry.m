//
//  LoanPmtDigestEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoanPmtDigestEntry.h"
#import "InterestBearingWorkingBalance.h"
#import "DigestEntryProcessingParams.h"
#import "WorkingBalanceMgr.h"
#import "LoanSimInfo.h"
#import "LoanPmtAmtCalculator.h"

@implementation LoanPmtDigestEntry

@synthesize loanInfo;
@synthesize pmtCalculator;

- (void)dealloc
{
	[loanInfo release];
	[pmtCalculator release];
	[super dealloc];
}


-(id)initWithLoanInfo:(LoanSimInfo*)theLoanInfo andPmtCalculator:(id<LoanPmtAmtCalculator>)thePmtCalculator
{
	self = [super init];
	if(self)
	{
		assert(theLoanInfo != nil);
		self.loanInfo = theLoanInfo;
		
		assert(thePmtCalculator != nil);
		self.pmtCalculator = thePmtCalculator;
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

	double paymentAmt = [self.pmtCalculator paymentAmtForLoanInfo:self.loanInfo andPmtDate:processingParams.currentDate];
	
	double balancePaid = [self.loanInfo.loanBalance decrementAvailableBalanceForNonExpense:paymentAmt
		asOfDate:processingParams.currentDate];
		
	[processingParams.workingBalanceMgr decrementBalanceFromFundingList:balancePaid 
		asOfDate:processingParams.currentDate];
}



@end
