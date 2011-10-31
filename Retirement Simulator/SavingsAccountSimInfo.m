//
//  SavingsAccountSimInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavingsAccountSimInfo.h"
#import "SavingsAccount.h"
#import "InterestBearingWorkingBalance.h"
#import "SimParams.h"
#import "SimDate.h"
#import "SimInputHelper.h"
#import "MultiScenarioSimDate.h"

@implementation SavingsAccountSimInfo
	
@synthesize savingsAcct;
@synthesize savingsBal;	
	
-(id)initWithSavingsAcct:(SavingsAccount*)theSavingsAcct andSimParams:(SimParams *)simParams
{
	self = [super init];
	if(self)
	{
		assert(theSavingsAcct != nil);
		self.savingsAcct = theSavingsAcct;
		
		self.savingsBal = 
			[[[InterestBearingWorkingBalance alloc] initWithSavingsAcct:theSavingsAcct 
				andSimParams:simParams] autorelease];
				
		if([SimInputHelper multiScenBoolVal:theSavingsAcct.deferredWithdrawalsEnabled
			andScenario:simParams.simScenario])
		{
			NSDate *deferWithdrawalsDate = [SimInputHelper 
				multiScenFixedDate:theSavingsAcct.deferredWithdrawalDate.simDate 
					andScenario:simParams.simScenario];
			assert(deferWithdrawalsDate != nil);
			self.savingsBal.deferWithdrawalsUntil = deferWithdrawalsDate;
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
	[savingsAcct release];
	[savingsBal release];
}	
	
@end
