//
//  SavingsContributionSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavingsContributionSimEvent.h"
#import "DateHelper.h"
#import "NumberHelper.h"
#import "SavingsAccount.h"
#import "SavingsWorkingBalance.h"
#import "FiscalYearDigest.h"


@implementation SavingsContributionSimEvent

@synthesize savingsBalance;
@synthesize contributionAmount;

- (void)doSimEvent:(FiscalYearDigest*)digest
{
	NSString *currencyAmount = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:self.contributionAmount]];
    
    NSLog(@"Doing savings contribution event: %@ %@ %@",
          self.savingsBalance.savingsAcct.name,
          [[DateHelper theHelper].longDateFormatter stringFromDate:self.eventDate],
		  currencyAmount);
		  
	[digest addExpense:self.contributionAmount onDate:self.eventDate];
}



- (void) dealloc
{
	[super dealloc];
	[savingsBalance release];
}

@end
