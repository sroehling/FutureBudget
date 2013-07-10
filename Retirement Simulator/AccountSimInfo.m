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
@synthesize dividendPayouts;

-(void)dealloc
{
	[account release];
	[acctBal release];
	[dividendPayments release];
	[dividendPayouts release];
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
		self.dividendPayouts = [[[InputValDigestSummation alloc] init] autorelease];
				
		// Populate the SimParam's digestSums for the 
		// savings acct. This will cause the digest sums to be reset when
		// there are multiple passes of digest calculation in a year.
		[simParams.digestSums addDigestSum:self.dividendPayments];
		[simParams.digestSums addDigestSum:self.dividendPayouts];
		


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
