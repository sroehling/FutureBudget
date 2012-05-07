//
//  EndpointWorkingBalanceResolver.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EndpointWorkingBalanceResolver.h"

#import "TransferEndpointCash.h"
#import "TransferEndpointAcct.h"
#import "SimParams.h"
#import "WorkingBalance.h"
#import "TransferEndpoint.h"
#import "WorkingBalanceMgr.h"
#import "CashWorkingBalance.h"
#import "AccountSimInfo.h"
#import "InputSimInfoCltn.h"
#import "InterestBearingWorkingBalance.h"
#import "TransferEndpointAcct.h"
#import "Account.h"


@implementation EndpointWorkingBalanceResolver

@synthesize simParams;
@synthesize resolvedBalance;

-(id)initWithSimParams:(SimParams*)theSimParams
{
	self = [super init];
	if(self)
	{
		assert(theSimParams != nil);
		self.simParams = theSimParams;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

-(void)visitCashEndpoint:(TransferEndpointCash*)endpoint
{
	self.resolvedBalance = self.simParams.workingBalanceMgr.cashWorkingBalance;
}

-(void)visitAcctEndpoint:(TransferEndpointAcct*)endpoint
{
	AccountSimInfo *acctInfo = (AccountSimInfo *)[self.simParams.acctInfo getSimInfo:endpoint.account];
	self.resolvedBalance =  acctInfo.acctBal;
}

-(WorkingBalance*)resolveWorkingBalance:(TransferEndpoint*)endpoint
{
	self.resolvedBalance = nil;
	[endpoint acceptEndpointVisitor:self];
	assert(self.resolvedBalance!=nil);
	return self.resolvedBalance;
}

-(void)dealloc
{
	[resolvedBalance release];
	[simParams release];
	[super dealloc];
}


@end
