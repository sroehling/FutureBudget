//
//  TransferSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransferSimEventCreator.h"
#import "TransferSimInfo.h"
#import "SimParams.h"
#import "TransferInput.h"
#import "TransferSimEvent.h"

@implementation TransferSimEventCreator

@synthesize transferInfo;

-(id)initWithTransferSimInfo:(TransferSimInfo *)theTransferInfo
{
	self = [super initWithCashFlow:theTransferInfo.transferInput 
		andSimStartDate:theTransferInfo.simParams.simStartDate];
	if(self)
	{
		assert(theTransferInfo != nil);
		self.transferInfo = theTransferInfo;
	}
	return self;
}

- (id)initWithCashFlow:(CashFlowInput *)theCashFlow
{
	assert(0); // must init with income info
}


- (SimEvent*) createCashFlowSimEvent:(double)cashFlowAmount andEventDate:(NSDate*)theDate
{

	TransferSimEvent *transferEvent = [[[TransferSimEvent alloc] 
		initWithEventCreator:self andEventDate:theDate] autorelease];
	transferEvent.transferInfo = self.transferInfo;
	transferEvent.transferAmount = cashFlowAmount;
    
    transferEvent.tieBreakPriority = SIM_EVENT_TIE_BREAK_PRIORITY_TRANSFER;
	
	return transferEvent;
}

-(void)dealloc
{
	[transferInfo release];
	[super dealloc];
}




@end
