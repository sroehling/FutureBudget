//
//  PeriodicInterestBearingWorkingBalance.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/10/13.
//
//

#import "WorkingBalanceBaseImpl.h"
#import "ValueAsOfCalculator.h"

@class InputValDigestSummation;
@class DateSensitiveValue;
@class VariableRateCalculator;
@class PeriodicInterestPaymentResult;


@interface PeriodicInterestBearingWorkingBalance : WorkingBalanceBaseImpl
{
    @private
		id<ValueAsOfCalculator> interestRateCalc;
		InputValDigestSummation *accruedInterest;
		NSString *workingBalanceName;
		
		// The dates below track the date the period was
		// advanced. startingPeriodInterestStartDate is setup to
		// support reseting the balance, which occurs for
		// multi-pass digest processing during simulation.
		NSDate *currPeriodInterestStartDate;
		NSDate *startingPeriodInterestStartDate;
		
		NSUInteger startingNumRemainingPeriods;
		NSUInteger currRemainingPeriods;
		
		double startingMonthlyPeriodicRate;
		double currMonthlyPeriodicRate;
		
		double startingPeriodicPayment;
		double currPeriodicPayment;
}

@property(nonatomic,retain )id<ValueAsOfCalculator> interestRateCalc;
@property(nonatomic,retain ) NSString *workingBalanceName;
@property(nonatomic,retain) InputValDigestSummation *accruedInterest;

@property(nonatomic,retain) NSDate *currPeriodInterestStartDate;
@property(nonatomic,retain) NSDate *startingPeriodInterestStartDate;
@property double currPeriodicPayment;
@property double startingPeriodicPayment;
@property NSUInteger currRemainingPeriods;

@property NSUInteger startingNumRemainingPeriods;
@property double startingMonthlyPeriodicRate;
@property double currMonthlyPeriodicRate;

- (id) initWithStartingBalance:(double)theStartBalance
	andInterestRate:(DateSensitiveValue*)theInterestRate
	andWorkingBalanceName:(NSString*)wbName
	andStartDate:(NSDate*)theStartDate
	andNumPeriods:(NSUInteger)numPeriods;


- (id) initWithExplicitStartingBalance:(double)theStartBalance
	andOtherBalance:(PeriodicInterestBearingWorkingBalance*)otherBal;
- (id) initWithOtherBalance:(PeriodicInterestBearingWorkingBalance*)otherBal;

-(double)decrementPeriodicPaymentOnDate:(NSDate*)pmtDate
		withExtraPmtAmount:(double)extraPmt;
-(PeriodicInterestPaymentResult*)decrementInterestOnlyPaymentOnDate:(NSDate*)pmtDate
	withExtraPmtAmount:(double)extraPmt;
-(double)skippedPaymentOnDate:(NSDate*)pmtDate withExtraPmtAmount:(double)extraPmt;
-(double)decrementFirstNonDeferredPeriodicPaymentOnDate:(NSDate*)pmtDate
		withExtraPmtAmount:(double)extraPmt;

@end
