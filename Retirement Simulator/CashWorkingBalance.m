//
//  CashWorkingBalance.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CashWorkingBalance.h"
#import "Cash.h"
#import "SharedAppValues.h"


@implementation CashWorkingBalance

- (id) init
{
	Cash *theCash = [SharedAppValues singleton].cash;
	assert(theCash != nil);
	double startingCashBalance = [theCash.startingBalance doubleValue];
	
	self = [super initWithStartingBalance:startingCashBalance];
	if(self)
	{
	}
	return self;
}

- (void)carryBalanceForward:(NSDate*)newStartDate
{
	[super carryBalanceForward:newStartDate];
	startingBalance = self.currentBalance;
}


@end
