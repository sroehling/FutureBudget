//
//  SavingsContribDigestEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AccountContribDigestEntry.h"
#import "DigestEntryProcessingParams.h"
#import "WorkingBalanceMgr.h"
#import "AccountSimInfo.h"
#import "InterestBearingWorkingBalance.h"

@implementation AccountContribDigestEntry

@synthesize acctSimInfo;
@synthesize contribAmount;

- (void) dealloc
{
	[acctSimInfo release];
	[super dealloc];
}

- (id) initWithAcctSimInfo:(AccountSimInfo*)theAcctSimInfo
	andContribAmount:(double)theAmount
{
	self = [super init];
	if(self)
	{
		assert(theAcctSimInfo != nil);
		self.acctSimInfo = theAcctSimInfo;
		
		assert(theAmount >= 0.0);
		self.contribAmount = theAmount;
		
		
	}
	return self;
}

- (id)init
{
	assert(0); // Must init with working balance and contribution amount
}


-(void)processDigestEntry:(DigestEntryProcessingParams*)processingParams
{
	if(self.contribAmount>0.0)
	{
		double actualContrib = [processingParams.workingBalanceMgr
			decrementAvailableCashBalance:self.contribAmount 
			asOfDate:processingParams.currentDate];
		if(actualContrib>0.0)
		{
			[self.acctSimInfo addContribution:actualContrib onDate:processingParams.currentDate];
		}
	}

}



@end
