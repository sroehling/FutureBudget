//
//  SavingsContribDigestEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavingsContribDigestEntry.h"
#import "BalanceAdjustment.h"
#import "DigestEntryProcessingParams.h"
#import "WorkingBalanceMgr.h"
#import "InterestBearingWorkingBalance.h"

@implementation SavingsContribDigestEntry

@synthesize workingBalance;
@synthesize contribAmount;

- (id) initWithWorkingBalance:(InterestBearingWorkingBalance*)theBalance 
	andContribAmount:(double)theAmount
{
	self = [super init];
	if(self)
	{
		assert(theBalance != nil);
		self.workingBalance = theBalance;
		
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
//			BalanceAdjustment *interestAccruedLeadingUpToSavingsContribution = 
			[self.workingBalance incrementBalance:actualContrib 
					asOfDate:processingParams.currentDate];				
		}
	}

}


- (void) dealloc
{
	[super dealloc];
	[workingBalance release];
}

@end
