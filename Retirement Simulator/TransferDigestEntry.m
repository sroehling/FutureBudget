//
//  TransferDigestEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransferDigestEntry.h"
#import "InputValDigestSummation.h"
#import "WorkingBalanceMgr.h"
#import "DigestEntryProcessingParams.h"
#import "TransferSimInfo.h"
#import "WorkingBalance.h"

@implementation TransferDigestEntry

@synthesize transferInfo;


-(id)initWithTransferInfo:(TransferSimInfo*)theTransferInfo
	andTransferAmount:(double)transferAmount
{
	self = [super initWithAmount:transferAmount andCashFlowSummation:theTransferInfo.digestSum];
	if(self)
	{
		self.transferInfo = theTransferInfo;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

-(id)initWithAmount:(double)theAmount andCashFlowSummation:(InputValDigestSummation *)theSummation
{
	assert(0);
	return nil;
}

-(void)processDigestEntry:(DigestEntryProcessingParams*)processingParams
{
	if(self.amount>0.0)
	{
		double actualTransfer = [self.transferInfo.fromWorkingBal 
			decrementAvailableBalanceForNonExpense:self.amount asOfDate:processingParams.currentDate];;
		if(actualTransfer>0.0)
		{
			[self.transferInfo.toWorkingBal incrementBalance:actualTransfer 
					asOfDate:processingParams.currentDate];				
		}
		[self.cashFlowSummation adjustSum:actualTransfer onDay:processingParams.dayIndex];
	}
}

-(void)dealloc
{
	[transferInfo release];
	[super dealloc];
}



@end
