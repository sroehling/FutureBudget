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
#import "PeriodicInterestPaymentResult.h"

@implementation PeriodicInterestBearingWorkingBalance

@synthesize interestRateCalc;
@synthesize workingBalanceName;
@synthesize accruedInterest;

@synthesize startingPeriodInterestStartDate;
@synthesize currPeriodInterestStartDate;

@synthesize startingPeriodicPayment;
@synthesize currPeriodicPayment;
@synthesize startingNumRemainingPeriods;
@synthesize currRemainingPeriods;
@synthesize startingMonthlyPeriodicRate;
@synthesize currMonthlyPeriodicRate;


- (void) dealloc
{
	[interestRateCalc release];
	[workingBalanceName release];
	[accruedInterest release];
	
	[currPeriodInterestStartDate release];
	[startingPeriodInterestStartDate release];
	
	[super dealloc];
}


- (id) initWithStartingBalance:(double)theStartBalance
	andInterestRate:(DateSensitiveValue*)theInterestRate
	andWorkingBalanceName:(NSString*)wbName
	andStartDate:(NSDate*)theStartDate
	andNumPeriods:(NSUInteger)numPeriods
{
	self = [super initWithStartingBalance:theStartBalance 
		andStartDate:theStartDate andWithdrawPriority:WORKING_BALANCE_WITHDRAW_PRIORITY_MAX];
	if(self) {
	
		ValueAsOfCalculatorCreator *valCalculatorCreator = [[[ValueAsOfCalculatorCreator alloc] init] autorelease];
		
		self.interestRateCalc = [valCalculatorCreator 
							createForDateSensitiveValue:theInterestRate];
		self.workingBalanceName = wbName;
		self.accruedInterest = [[[InputValDigestSummation alloc] init] autorelease];
		
		self.currPeriodInterestStartDate = theStartDate;
		self.startingPeriodInterestStartDate = theStartDate;
		
		assert(numPeriods > 0);
		self.startingNumRemainingPeriods = numPeriods;
		self.currRemainingPeriods = self.startingNumRemainingPeriods;
		
		self.startingMonthlyPeriodicRate = [LoanPmtHelper monthlyPeriodicLoanInterestRate:
			[self.interestRateCalc valueAsOfDate:self.startingPeriodInterestStartDate]];
		self.currMonthlyPeriodicRate = startingMonthlyPeriodicRate;
		
		self.startingPeriodicPayment = [VariableRate periodicPaymentForPrincipal:theStartBalance
			andPeriodRate:startingMonthlyPeriodicRate andNumPeriods:numPeriods];
		assert(self.startingPeriodicPayment >= 0.0);
		self.currPeriodicPayment = self.startingPeriodicPayment;
		
	}
	return self;
}

// Copy contstructor
- (id) initWithExplicitStartingBalance:(double)theStartBalance
	andOtherBalance:(PeriodicInterestBearingWorkingBalance*)otherBal
{
	self = [super initWithStartingBalance:theStartBalance 
		andStartDate:[otherBal currentBalanceDate] andWithdrawPriority:WORKING_BALANCE_WITHDRAW_PRIORITY_MAX];
	if(self) {
	
		self.interestRateCalc = otherBal.interestRateCalc;
		self.workingBalanceName = otherBal.workingBalanceName;
		self.accruedInterest = [[[InputValDigestSummation alloc] init] autorelease];
		
		NSDate *theStartDate = otherBal.currentBalanceDate;

		self.currPeriodInterestStartDate = theStartDate;
		self.startingPeriodInterestStartDate = theStartDate;
		
		self.startingNumRemainingPeriods = otherBal.startingNumRemainingPeriods;
		self.currRemainingPeriods = otherBal.currRemainingPeriods;

		self.startingMonthlyPeriodicRate = otherBal.startingMonthlyPeriodicRate;
		self.currMonthlyPeriodicRate = otherBal.currMonthlyPeriodicRate;
		
		self.startingPeriodicPayment = otherBal.startingPeriodicPayment;
		self.currPeriodicPayment = otherBal.currPeriodicPayment;
	}
	return self;
}


- (id) initWithOtherBalance:(PeriodicInterestBearingWorkingBalance*)otherBal
{
	double startBalance = otherBal.currentBalance;
	return [self initWithExplicitStartingBalance:startBalance andOtherBalance:otherBal];
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

-(void)updateCurrentPeriodicRateAndPaymentAsOfDate:(NSDate*)pmtDate
	andForceUpdate:(BOOL)doForceUpdate
{
	double monthlyPeriodicRate = [LoanPmtHelper monthlyPeriodicLoanInterestRate:
			[self.interestRateCalc valueAsOfDate:pmtDate]];
	if((monthlyPeriodicRate != self.currMonthlyPeriodicRate) || doForceUpdate)
	{
		self.currMonthlyPeriodicRate = monthlyPeriodicRate;
		self.currPeriodicPayment = [VariableRate periodicPaymentForPrincipal:self.currentBalance
			andPeriodRate:self.currMonthlyPeriodicRate andNumPeriods:self.currRemainingPeriods];
	}

}

- (double)advanceCurrentBalanceToNextPeriodOnDate:(NSDate*)newDate
	andDecrementRemainingPeriods:(NSUInteger)doDecrementPeriods
{
	if(currentBalance > 0.0)
	{
		double monthlyPeriodicRate = [LoanPmtHelper monthlyPeriodicLoanInterestRate:
			[self.interestRateCalc valueAsOfDate:newDate]];
		
		
		double newBalance = currentBalance * (1.0 + monthlyPeriodicRate);
		double interestAmount = newBalance - currentBalance;
		
		NSUInteger dayIndex = [DateHelper daysOffset:newDate vsEarlierDate:self.balanceStartDate];
		[self.accruedInterest adjustSum:interestAmount onDay:dayIndex];

		self.currentBalance = newBalance;
		self.currentBalanceDate = newDate;
		self.currPeriodInterestStartDate = newDate;

		
		if(doDecrementPeriods)
		{
			// Only decrement the remaining periods if there's periods to be decremented.
			// In general, with the amortization calculations, the payment schedule will
			// always result in the payments will draw down the balance to 0 on the last
			// period. However, if for a loan originating before simulation start (a corner
			// case), if the user sets an explicit starting balance, and that
			// starting balance is greater than the remaining balance which would have
			// occurred if the regular amortization schedule was used, the payments could
			// potentially extend beyond the number of scheduled periods.
			if(self.currRemainingPeriods > 1)
			{
				self.currRemainingPeriods = self.currRemainingPeriods-1;
			}
		}
		
		assert(interestAmount >= 0.0);
		return interestAmount;
	}
	else
	{
		return 0.0;
	}
}

-(double)decrementPeriodicPaymentOnDate:(NSDate*)pmtDate withExtraPmtAmount:(double)extraPmt
{
	[self updateCurrentPeriodicRateAndPaymentAsOfDate:pmtDate andForceUpdate:FALSE];

	[self advanceCurrentBalanceToNextPeriodOnDate:pmtDate andDecrementRemainingPeriods:TRUE];

	double totalPmt = self.currPeriodicPayment + extraPmt;
	
	double actualPmtAmt = [self decrementAvailableBalanceForNonExpense:totalPmt asOfDate:pmtDate];
			
	return actualPmtAmt;
}

-(double)decrementFirstNonDeferredPeriodicPaymentOnDate:(NSDate*)pmtDate withExtraPmtAmount:(double)extraPmt
{
	[self advanceCurrentBalanceToDate:pmtDate];
	
	// Use the balance *leading into* the first payment to calculate the monthly payment.
	// This happens before adding on the interest for the month leading into the first payment
	// (via advanceCurrentBalanceToNextPeriodOnDate).
	//
	// For the first payment after deferment, always update the periodic payment. This is
	// needed since the principal balance may have actually increased while the loan
	// was in deferment.
	[self updateCurrentPeriodicRateAndPaymentAsOfDate:pmtDate andForceUpdate:TRUE];

	[self advanceCurrentBalanceToNextPeriodOnDate:pmtDate andDecrementRemainingPeriods:TRUE];
	
	double totalPmt = currPeriodicPayment + extraPmt;
	
	double actualPmtAmt = [self decrementAvailableBalanceForNonExpense:totalPmt asOfDate:pmtDate];
			
	return actualPmtAmt;
}


-(PeriodicInterestPaymentResult*)decrementInterestOnlyPaymentOnDate:(NSDate*)pmtDate
	withExtraPmtAmount:(double)extraPmt
{
	[self updateCurrentPeriodicRateAndPaymentAsOfDate:pmtDate andForceUpdate:FALSE];

	double periodInterest = [self advanceCurrentBalanceToNextPeriodOnDate:pmtDate andDecrementRemainingPeriods:FALSE];
	
	double actualPeriodInterestPaid = 0.0;
	if(periodInterest > 0.0)
	{
		actualPeriodInterestPaid = [self decrementAvailableBalanceForNonExpense:periodInterest
			asOfDate:pmtDate];
	}
	
	double actualExtraPmtPaid = 0.0;
	if(extraPmt > 0.0)
	{
		actualExtraPmtPaid = [self decrementAvailableBalanceForNonExpense:extraPmt
			asOfDate:pmtDate];
	}

	PeriodicInterestPaymentResult *pmtResult = [[[PeriodicInterestPaymentResult alloc] init] autorelease];
	pmtResult.interestPaid = actualPeriodInterestPaid;
	pmtResult.extraPaymentPaid = actualExtraPmtPaid;
			
	return pmtResult;
}

-(double)skippedPaymentOnDate:(NSDate*)pmtDate withExtraPmtAmount:(double)extraPmt
{

	[self updateCurrentPeriodicRateAndPaymentAsOfDate:pmtDate andForceUpdate:FALSE];

	[self advanceCurrentBalanceToNextPeriodOnDate:pmtDate andDecrementRemainingPeriods:FALSE];

	double actualExtraPmtPaid = 0.0;
	if(extraPmt > 0.0)
	{
		actualExtraPmtPaid = [self decrementAvailableBalanceForNonExpense:extraPmt
			asOfDate:pmtDate];
	}

	return actualExtraPmtPaid;
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
			[self.interestRateCalc valueAsOfDate:self.currPeriodInterestStartDate]];
	
	VariableRateCalculator *rateCalc = [[[VariableRateCalculator alloc] 
		initWithSingleAnnualRate:adjustedAnnualRate andStartDate:self.currPeriodInterestStartDate] autorelease];
		
	double balanceMultiplier = [rateCalc valueMultiplierForDate:newDate];
	double newBalance = currentBalance * balanceMultiplier;
	double proratedInterestAmount = newBalance - currentBalance;

	self.currentBalance = newBalance;
	self.currentBalanceDate = newDate;
	self.currRemainingPeriods = 0;

		
	NSUInteger dayIndex = [DateHelper daysOffset:newDate vsEarlierDate:self.balanceStartDate];
	[self.accruedInterest adjustSum:proratedInterestAmount onDay:dayIndex];
	

	return [super zeroOutBalanceAsOfDate:newDate];
}

- (void) resetCurrentBalance
{
	[super resetCurrentBalance];
	
	// Reset the period interst start date to the one set via carryBalanceForward
	// at the start of the year.
	self.currPeriodInterestStartDate = self.self.startingPeriodInterestStartDate;
	self.currRemainingPeriods = self.startingNumRemainingPeriods;
	self.currMonthlyPeriodicRate = self.startingMonthlyPeriodicRate;
	self.currPeriodicPayment = self.startingPeriodicPayment;
	
}

-(void)carryBalanceForward:(NSDate *)newStartDate
{
	[super carryBalanceForward:newStartDate];
	
	// Advance the starting period interest start date to the last
	// period interest start date set for the year.
	self.startingPeriodInterestStartDate = self.currPeriodInterestStartDate;
	self.startingNumRemainingPeriods = self.currRemainingPeriods;
	self.startingMonthlyPeriodicRate = self.currMonthlyPeriodicRate;
	self.startingPeriodicPayment = self.currPeriodicPayment;
}


- (NSString*)balanceName
{
	return self.workingBalanceName;
}


@end
