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
#import "DateHelper.h"
#import "SharedAppValues.h"
#import "LocalizationHelper.h"


@implementation CashWorkingBalance

- (id) init
{
	Cash *theCash = [SharedAppValues singleton].cash;
	assert(theCash != nil);
	double startingCashBalance = [theCash.startingBalance doubleValue];
	
	NSDate *startDate = [DateHelper beginningOfDay:[SharedAppValues singleton].simStartDate];
	
	self = [super initWithStartingBalance:startingCashBalance andStartDate:startDate];
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

- (NSString*)balanceName
{
	return LOCALIZED_STR(@"CASH_LABEL");
}


@end
