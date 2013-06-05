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
#import "LoanPmtProcessor.h"

@implementation LoanPmtDigestEntry

@synthesize loanInfo;
@synthesize pmtProcessor;

- (void)dealloc
{
	[loanInfo release];
	[pmtProcessor release];
	[super dealloc];
}


-(id)initWithLoanInfo:(LoanSimInfo*)theLoanInfo andPmtProcessor:(id<LoanPmtProcessor>)thePmtProcessor
{
	self = [super init];
	if(self)
	{
		assert(theLoanInfo != nil);
		self.loanInfo = theLoanInfo;
		
		assert(thePmtProcessor != nil);
		self.pmtProcessor = thePmtProcessor;
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
	[self.pmtProcessor processPmtForLoanInfo:self.loanInfo andProcessingParams:processingParams];	
}



@end
