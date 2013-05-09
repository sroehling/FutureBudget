//
//  AccountSimInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AccountSimInfo.h"
#import "Account.h"
#import "AccountWorkingBalance.h"
#import "SimParams.h"
#import "SimDate.h"
#import "SimInputHelper.h"
#import "MultiScenarioSimDate.h"
#import "InputValDigestSummation.h"
#import "InputValDigestSummations.h"
#import "CashWorkingBalance.h"

@implementation AccountSimInfo
	
@synthesize account;
@synthesize acctBal;
@synthesize simParams;
@synthesize dividendPayments;

-(void)dealloc
{
	[account release];
	[acctBal release];
	[dividendPayments release];
	[simParams release];
	[super dealloc];
}	
	
-(id)initWithAcct:(Account*)theAcct andSimParams:(SimParams *)theSimParams
{
	self = [super init];
	if(self)
	{
		assert(theAcct != nil);
		self.account = theAcct;
		
		assert(theSimParams != nil);
		self.simParams =theSimParams;
		
		self.acctBal = [[[AccountWorkingBalance alloc] initWithAcct:theAcct
				andSimParams:simParams] autorelease];

		self.dividendPayments = [[[InputValDigestSummation alloc] init] autorelease];
				
		// TBD - Is this the best place to populate the SimParam's digestSums for the 
		// savings acct? Should it instead be done inside the WorkingBalance?
		[simParams.digestSums addDigestSum:self.dividendPayments];
		


	}
	return self;
}

-(id)init
{
	assert(0); // must init with savings account
	return nil;
}


-(void)addContribution:(double)contributionAmount onDate:(NSDate*)contributionDate
{
	assert(contributionAmount >= 0.0);
	[self.acctBal incrementBalance:contributionAmount asOfDate:contributionDate];	
}


	
@end
