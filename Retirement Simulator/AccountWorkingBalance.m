//
//  InvestmentAccountWorkingBalance.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/8/13.
//
//

#import "AccountWorkingBalance.h"
#import "CashWorkingBalance.h"
#import "SimParams.h"
#import "InterestBearingWorkingBalance.h"
#import "DateHelper.h"
#import "Account.h"
#import "SimInputHelper.h"
#import "MultiScenarioSimDate.h"
#import "SimParams.h"
#import "InputValDigestSummations.h"
#import "InputValDigestSummation.h"
#import "NumberHelper.h"

@implementation AccountWorkingBalance

@synthesize overallBal;
@synthesize costBasis;
@synthesize limitWithdrawalsToExpense;
@synthesize deferWithdrawalsUntil;
@synthesize capitalGains;
@synthesize capitalLosses;

@synthesize withdrawPriority;


-(void)dealloc
{
	[overallBal release];
	[costBasis release];
	
	[deferWithdrawalsUntil release];
	[limitWithdrawalsToExpense release];
	
	[capitalGains release];
	[capitalLosses release];
	
	[super dealloc];
}

-(id)initWithWithdrawalPriority:(double)theWithdrawPriority
	andStartDate:(NSDate*)theStartDate
	andStartingBal:(double)startingBal 	andInterestRate:(DateSensitiveValue*)theInterestRate
	andStartingCostBasis:(double)startingCostBasis andDeferWithdrawDate:(NSDate*)deferUntil
	andLimitedExpense:(NSSet*)limitedExpenses
{
	self = [super init];
	if(self)
	{
		self.withdrawPriority = theWithdrawPriority;

		self.costBasis = [[[CashWorkingBalance alloc]
				initWithStartingBalance:startingCostBasis
					andStartDate:theStartDate ] autorelease];
					
		self.overallBal = [[[InterestBearingWorkingBalance alloc]
			initWithStartingBalance:startingBal andInterestRate:theInterestRate
			andWorkingBalanceName:@"N/A" andStartDate:theStartDate
			andWithdrawPriority:theWithdrawPriority] autorelease];

		self.deferWithdrawalsUntil = deferUntil;
		
		self.limitWithdrawalsToExpense = limitedExpenses;

		self.capitalGains = [[[InputValDigestSummation alloc] init] autorelease];
		self.capitalLosses = [[[InputValDigestSummation alloc] init] autorelease];


	}
	return self;
}

- (id) initWithAcct:(Account*)theAcct andSimParams:(SimParams*)simParams
{
				
	self = [super init];
	if(self)
	{
		double acctWithdrawPriority = 
			[SimInputHelper multiScenFixedVal:theAcct.withdrawalPriority
				andScenario:simParams.simScenario];
		self.withdrawPriority = acctWithdrawPriority;
	
	
		self.overallBal = [[[InterestBearingWorkingBalance alloc]
		     initWithAcct:theAcct andSimParams:simParams] autorelease];

		double startingCostBasis = [theAcct.costBasis doubleValue];
		self.costBasis = [[[CashWorkingBalance alloc]
				initWithStartingBalance:startingCostBasis
					andStartDate:simParams.simStartDate ] autorelease];

		// Initialize the optional parameters of the working balance to setup
		// a deferred withdrawal date (if any) and list of expenses to limit the
		// withdrawal to.		
		if([SimInputHelper multiScenBoolVal:theAcct.deferredWithdrawalsEnabled
			andScenario:simParams.simScenario])
		{
			NSDate *deferWithdrawalsDate = [SimInputHelper 
				multiScenFixedDate:theAcct.deferredWithdrawalDate.simDate 
					andScenario:simParams.simScenario];
			assert(deferWithdrawalsDate != nil);
			self.deferWithdrawalsUntil = deferWithdrawalsDate;
		}

		self.limitWithdrawalsToExpense = theAcct.limitWithdrawalExpenses;
		
		self.capitalGains = [[[InputValDigestSummation alloc] init] autorelease];
		self.capitalLosses = [[[InputValDigestSummation alloc] init] autorelease];
		
		
		[simParams.digestSums addDigestSum:self.overallBal.contribs];
		[simParams.digestSums addDigestSum:self.overallBal.withdrawals];
		[simParams.digestSums addDigestSum:self.overallBal.accruedInterest];
		
		[simParams.digestSums addDigestSum:self.capitalGains];
		[simParams.digestSums addDigestSum:self.capitalLosses];


	}
	return self;
}

- (void) resetCurrentBalance
{
	[self.overallBal resetCurrentBalance];
	[self.costBasis resetCurrentBalance];
}

- (void)carryBalanceForward:(NSDate*)newStartDate
{
	[self.overallBal carryBalanceForward:newStartDate];
	[self.costBasis carryBalanceForward:newStartDate];
}

- (void)advanceCurrentBalanceToDate:(NSDate*)newDate
{
	[self.overallBal advanceCurrentBalanceToDate:newDate];
	[self.costBasis advanceCurrentBalanceToDate:newDate];
}

- (double)currentBalanceForDate:(NSDate*)balanceDate
{
	return [self.overallBal currentBalanceForDate:balanceDate];
}


- (void) incrementBalance:(double)amount asOfDate:(NSDate*)newDate
{
	[self.overallBal incrementBalance:amount asOfDate:newDate];
	[self.costBasis incrementBalance:amount asOfDate:newDate];
}

-(BOOL)withdrawalsEnabledAsOfDate:(NSDate*)theDate
{
	assert(theDate != nil);
	if(self.deferWithdrawalsUntil != nil)
	{
		if([DateHelper dateIsEqualOrLater:theDate 
			otherDate:[DateHelper beginningOfDay:self.deferWithdrawalsUntil]])
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}
	else
	{
		return TRUE;
	}
}

- (double) decrementAvailableBalanceImpl:(double)amount asOfDate:(NSDate*)newDate
{
	[self advanceCurrentBalanceToDate:newDate];
	
	assert(amount >= 0.0);	

	double decrementFromOverallAcctBal = 0.0;
	if([self withdrawalsEnabledAsOfDate:newDate])
	{
	
		double currentOverallBalanceBeforeDecrement =
			[self.overallBal currentBalanceForDate:newDate];
		double costBasisBeforeDecrement =
			[self.costBasis currentBalanceForDate:newDate];
		
		decrementFromOverallAcctBal =
			[self.overallBal decrementAvailableBalanceForNonExpense:amount asOfDate:newDate];
			
		if(decrementFromOverallAcctBal > 0.0)
		{
			double cumulativeGainOrLossAtTimeOfDecrement =
				currentOverallBalanceBeforeDecrement - costBasisBeforeDecrement;
		
			double percentGainOrLossAtTimeOfDecrement =
				cumulativeGainOrLossAtTimeOfDecrement / currentOverallBalanceBeforeDecrement;

			double capitalGainOrLoss = decrementFromOverallAcctBal * percentGainOrLossAtTimeOfDecrement;
			
			NSUInteger dayIndex = [DateHelper daysOffset:newDate vsEarlierDate:self.overallBal.balanceStartDate];
			if(capitalGainOrLoss > 0.0)
			{
				[self.capitalGains adjustSum:capitalGainOrLoss onDay:dayIndex];
			}
			else if(capitalGainOrLoss < 0.0)
			{
				[self.capitalLosses adjustSum:(-1.0 * capitalGainOrLoss) onDay:dayIndex];
			}
			
			// Decrement the outstanding cost basis by the overall withdrawal amount minus
			// the capital gain or loss. Note that for a loss, the amount deducted could be greater
			// than the actual withdrawal amount.
			double costBasisAttributableToGainOrLoss = decrementFromOverallAcctBal - capitalGainOrLoss;
			[self.costBasis decrementAvailableBalanceForNonExpense:costBasisAttributableToGainOrLoss asOfDate:newDate];
		}
	}
		
	return decrementFromOverallAcctBal;

}


- (double) decrementAvailableBalanceForExpense:(ExpenseInput*)expense 
	andAmount:(double)amount asOfDate:(NSDate*)newDate
{
	assert(expense != nil);
	if(self.limitWithdrawalsToExpense != nil)
	{
		if([self.limitWithdrawalsToExpense count] == 0)
		{
			return [self decrementAvailableBalanceImpl:amount asOfDate:newDate];
		}
		else if ([self.limitWithdrawalsToExpense containsObject:expense])
		{
			return [self decrementAvailableBalanceImpl:amount asOfDate:newDate];
		}
		else
		{
			return 0.0;
		}
	}
	else
	{
		return [self decrementAvailableBalanceImpl:amount 
				asOfDate:newDate];
;
	}
}

-(double)decrementAvailableBalanceForNonExpense:(double)amount 
	asOfDate:(NSDate *)newDate
{
	if((self.limitWithdrawalsToExpense != nil) &&
		([self.limitWithdrawalsToExpense count] > 0))
	{
		return 0.0;
	}
	else
	{
		return [self decrementAvailableBalanceImpl:amount asOfDate:newDate];
	}
}

- (double)zeroOutBalanceAsOfDate:(NSDate*)newDate
{
	// First advance the date, ensuring that any interest/adjustement leading up 
	// to newDate are included in the balance.
	[self advanceCurrentBalanceToDate:newDate];
	
	if([self withdrawalsEnabledAsOfDate:newDate])
	{
		double remainingBalance = [self.overallBal currentBalanceForDate:newDate];
	
		[self decrementAvailableBalanceImpl:remainingBalance asOfDate:newDate];

		return remainingBalance;
	}
	else
	{
		return 0.0;
	}
	
}

-(NSString *)balanceName
{
	assert(0); // must be overridden
	return  nil;
}


@end
