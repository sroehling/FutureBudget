//
//  AccountSimInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AccountSimInfo.h"
#import "Account.h"
#import "InterestBearingWorkingBalance.h"
#import "SimParams.h"
#import "SimDate.h"
#import "SimInputHelper.h"
#import "MultiScenarioSimDate.h"
#import "InputValDigestSummations.h"

@implementation AccountSimInfo
	
@synthesize account;
@synthesize acctBal;	
	
-(id)initWithAcct:(Account*)theAcct andSimParams:(SimParams *)simParams
{
	self = [super init];
	if(self)
	{
		assert(theAcct != nil);
		self.account = theAcct;
		
		self.acctBal = [[[InterestBearingWorkingBalance alloc] initWithAcct:theAcct 
				andSimParams:simParams] autorelease];
		// TBD - Is this the best place to populate the SimParam's digestSums for the 
		// savings acct? Should it instead be done inside the WorkingBalance?
		[simParams.digestSums addDigestSum:self.acctBal.contribs];
		[simParams.digestSums addDigestSum:self.acctBal.withdrawals];
		[simParams.digestSums addDigestSum:self.acctBal.accruedInterest];

				
		if([SimInputHelper multiScenBoolVal:theAcct.deferredWithdrawalsEnabled
			andScenario:simParams.simScenario])
		{
			NSDate *deferWithdrawalsDate = [SimInputHelper 
				multiScenFixedDate:theAcct.deferredWithdrawalDate.simDate 
					andScenario:simParams.simScenario];
			assert(deferWithdrawalsDate != nil);
			self.acctBal.deferWithdrawalsUntil = deferWithdrawalsDate;
		}


	}
	return self;
}

-(id)init
{
	assert(0); // must init with savings account
	return nil;
}

-(void)dealloc
{
	[super dealloc];
	[account release];
	[acctBal release];
}	
	
@end
