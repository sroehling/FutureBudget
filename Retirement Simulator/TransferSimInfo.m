//
//  TransferSimInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransferSimInfo.h"

#import "TransferInput.h"
#import "SimParams.h"
#import "InputValDigestSummation.h"
#import "SimParams.h"
#import "InputValDigestSummations.h"
#import "WorkingBalance.h"

#import "EndpointWorkingBalanceResolver.h"

@implementation TransferSimInfo

@synthesize transferInput;
@synthesize simParams;
@synthesize digestSum;
@synthesize fromWorkingBal;
@synthesize toWorkingBal;


-(id)initWithTransferInput:(TransferInput*)theTransferInput 
		andSimParams:(SimParams*)theSimParams
{
	self = [super init];
	if(self)
	{
		assert(theSimParams != nil);
		assert(theTransferInput != nil);
		self.simParams = theSimParams;
		self.transferInput = theTransferInput;
		
		self.digestSum = [[[InputValDigestSummation alloc] init] autorelease];
		[theSimParams.digestSums addDigestSum:self.digestSum];
		
		EndpointWorkingBalanceResolver *balResolver = [[[EndpointWorkingBalanceResolver alloc]
			initWithSimParams:theSimParams] autorelease];
		self.fromWorkingBal = [balResolver resolveWorkingBalance:self.transferInput.fromEndpoint];
		self.toWorkingBal = [balResolver resolveWorkingBalance:self.transferInput.toEndpoint];
		

	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

-(void)dealloc
{
	[simParams release];
	[digestSum release];
	[transferInput release];
	[fromWorkingBal release];
	[toWorkingBal release];
	[super dealloc];
}

@end
