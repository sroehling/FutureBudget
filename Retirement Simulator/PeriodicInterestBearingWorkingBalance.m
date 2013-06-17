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
#import "VariableRate.h"
#import "VariableRateCalculator.h"
#import "LoanPmtHelper.h"

@implementation PeriodicInterestBearingWorkingBalance

@synthesize interestRateCalc;
@synthesize workingBalanceName;
@synthesize accruedInterest;
@synthesize periodInterestStartDate;
@synthesize startingPeriodInterestStartDate;

- (void) dealloc
{
	[interestRateCalc release];
	[workingBalanceName release];
	[accruedInterest release];
	
	[periodInterestStartDate release];
	[startingPeriodInterestStartDate release];
	
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
		
		self.periodInterestStartDate = theStartDate;
		self.startingPeriodInterestStartDate = theStartDate;
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

- (double)advanceCurrentBalanceToNextPeriodOnDate:(NSDate*)newDate
{		
		double monthlyPeriodicRate = [LoanPmtHelper monthlyPeriodicLoanInterestRate:
			[self.interestRateCalc valueAsOfDate:newDate]];
		
		double newBalance = currentBalance * (1.0 + monthlyPeriodicRate);
		double interestAmount = newBalance - currentBalance;
		
		NSUInteger dayIndex = [DateHelper daysOffset:newDate vsEarlierDate:self.balanceStartDate];
		[self.accruedInterest adjustSum:interestAmount onDay:dayIndex];

		currentBalance = newBalance;
		self.currentBalanceDate = newDate;
		
		self.periodInterestStartDate = newDate;
		
		assert(interestAmount >= 0.0);
		return interestAmount;
}



- (double)zeroOutBalanceAsOfDate:(NSDate*)newDate
{
	// The loanBalance property is a PeriodicInterestBearingWorkingBalance, so
	// the interest is accrued on a monthly basis. However, the zeroOutBalanceAsOfDate needs
	// to prorate the interest when the balance is being zeroed out.

	// First advance the date, ensuring that any interest/adjustement leading up
	// to newDate are included in the balance.
	[self advanceCurrentBalanceToDate:newDate];
	
	double adjustedAnnualRate = [LoanPmtHelper annualizedPeriodicLoanInterestRate:
			[self.interestRateCalc valueAsOfDate:self.periodInterestStartDate]];
	
	VariableRateCalculator *rateCalc = [[[VariableRateCalculator alloc] 
		initWithSingleAnnualRate:adjustedAnnualRate andStartDate:self.periodInterestStartDate] autorelease];
		
	double balanceMultiplier = [rateCalc valueMultiplierForDate:newDate];
	double newBalance = currentBalance * balanceMultiplier;
	double proratedInterestAmount = newBalance - currentBalance;

	currentBalance = newBalance;
	self.currentBalanceDate = newDate;
		
	NSUInteger dayIndex = [DateHelper daysOffset:newDate vsEarlierDate:self.balanceStartDate];
	[self.accruedInterest adjustSum:proratedInterestAmount onDay:dayIndex];

	return [super zeroOutBalanceAsOfDate:newDate];
		
}

- (void) resetCurrentBalance
{
	[super resetCurrentBalance];
	// Reset the period interst start date to the one set via carryBalanceForward
	// at the start of the year.
	self.periodInterestStartDate = self.startingPeriodInterestStartDate;
	
}

-(void)carryBalanceForward:(NSDate *)newStartDate
{
	[super carryBalanceForward:newStartDate];
	// Advance the starting period interest start date to the last
	// period interest start date set for the year.
	self.startingPeriodInterestStartDate = self.periodInterestStartDate;
}



- (NSString*)balanceName
{
	return self.workingBalanceName;
}




@end
