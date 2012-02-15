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
@synthesize simParams;	
	
-(id)initWithAcct:(Account*)theAcct andSimParams:(SimParams *)theSimParams
{
	self = [super init];
	if(self)
	{
		assert(theAcct != nil);
		self.account = theAcct;
		
		assert(theSimParams != nil);
		self.simParams =theSimParams;
		
		self.acctBal = [[[InterestBearingWorkingBalance alloc] initWithAcct:theAcct 
				andSimParams:simParams] autorelease];
				
		// TBD - Is this the best place to populate the SimParam's digestSums for the 
		// savings acct? Should it instead be done inside the WorkingBalance?
		[simParams.digestSums addDigestSum:self.acctBal.contribs];
		[simParams.digestSums addDigestSum:self.acctBal.withdrawals];
		[simParams.digestSums addDigestSum:self.acctBal.accruedInterest];

				
		// Initialize the optional parameters of the working balance to setup
		// a deferred withdrawal date (if any) and list of expenses to limit the
		// withdrawal to.		
		if([SimInputHelper multiScenBoolVal:theAcct.deferredWithdrawalsEnabled
			andScenario:simParams.simScenario])
		{
			NSDate *deferWithdrawalsDate = [SimInputHelper 
				multiScenFixedDate:theAcct.deferredWithdrawalDate.simDate 
					andScenario:simParams.simScenario];
			assert(deferWithdrawalsDate != nil);
			self.acctBal.deferWithdrawalsUntil = deferWithdrawalsDate;
		}
		self.acctBal.limitWithdrawalsToExpense = self.account.limitWithdrawalExpenses;


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
	[account release];
	[acctBal release];
	[super dealloc];
}	
	
@end
