//
//  PeriodicInterestBearingWorkingBalance.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/10/13.
//
//

#import "PeriodicInterestBearingWorkingBalance.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "DateHelper.h"
#import "InputValDigestSummation.h"
#import "ValueAsOfCalculatorCreator.h"

@implementation PeriodicInterestBearingWorkingBalance

@synthesize interestRateCalc;
@synthesize workingBalanceName;
@synthesize accruedInterest;


- (void) dealloc
{
	[interestRateCalc release];
	[workingBalanceName release];
	[accruedInterest release];
	[super dealloc];
}


- (id) initWithStartingBalance:(double)theStartBalance
	andInterestRate:(DateSensitiveValue*)theInterestRate
	andWorkingBalanceName:(NSString*)wbName
	andStartDate:(NSDate*)theStartDate
{
	self = [super initWithStartingBalance:theStartBalance 
		andStartDate:theStartDate andWithdrawPriority:WORKING_BALANCE_WITHDRAW_PRIORITY_MAX];
	if(self) {
	
		ValueAsOfCalculatorCreator *valCalculatorCreator = [[[ValueAsOfCalculatorCreator alloc] init] autorelease];
		
		self.interestRateCalc = [valCalculatorCreator 
							createForDateSensitiveValue:theInterestRate];
		self.workingBalanceName = wbName;
		self.accruedInterest = [[[InputValDigestSummation alloc] init] autorelease];
	}
	return self;
}

- (void)advanceCurrentBalanceToDate:(NSDate*)newDate
{
	assert(newDate != nil);
	
	// Advancing to the current date is a no-op if the newDate is before the current date.
	// If the current date is in the future, then this working balance is typically for 
	// an input such as a loan or asset which is originated or purchased in the future. 
	if([DateHelper dateIsLater:newDate otherDate:self.currentBalanceDate])
	{
		self.currentBalanceDate = newDate;
		// NOTE - current balance is left unchanged
	}

}

- (void)advanceCurrentBalanceToNextPeriodOnDate:(NSDate*)newDate
{

		double currInterestRate = [self.interestRateCalc valueAsOfDate:newDate];
		assert(currInterestRate >= -100.0);
		double unadjustedAnnualRate = currInterestRate/100.0;
		double monthlyPeriodicRate = unadjustedAnnualRate / 12.0;
		
		double newBalance = currentBalance * (1.0 + monthlyPeriodicRate);
		double interestAmount = newBalance - currentBalance;
		
		NSUInteger dayIndex = [DateHelper daysOffset:newDate vsEarlierDate:self.balanceStartDate];
		[self.accruedInterest adjustSum:interestAmount onDay:dayIndex];

		currentBalance = newBalance;
		self.currentBalanceDate = newDate;

}

- (NSString*)balanceName
{
	return self.workingBalanceName;
}




@end
