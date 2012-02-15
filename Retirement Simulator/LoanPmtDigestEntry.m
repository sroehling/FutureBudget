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

@implementation LoanPmtDigestEntry

@synthesize loanBalance;
@synthesize paymentAmt;

-(id)initWithBalance:(InterestBearingWorkingBalance*)theLoanBal andPayment:(double)thePayment
{
	self = [super init];
	if(self)
	{
		assert(theLoanBal != nil);
		self.loanBalance = theLoanBal;
	
		assert(thePayment >= 0.0);
		self.paymentAmt = thePayment;
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
	double balancePaid = [self.loanBalance decrementAvailableBalanceForNonExpense:self.paymentAmt 
		asOfDate:processingParams.currentDate];
		
	[processingParams.workingBalanceMgr decrementBalanceFromFundingList:balancePaid 
		asOfDate:processingParams.currentDate];
}


- (void)dealloc
{
	[loanBalance release];
	[super dealloc];
}

@end
