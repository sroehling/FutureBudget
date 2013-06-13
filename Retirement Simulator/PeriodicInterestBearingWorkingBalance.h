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


@interface PeriodicInterestBearingWorkingBalance : WorkingBalanceBaseImpl
{
    @private
		id<ValueAsOfCalculator> interestRateCalc;
		InputValDigestSummation *accruedInterest;
		NSString *workingBalanceName;
		
		// The dates below track the date the period was
		// advanced. startingPeriodInterestStartDate is setup to
		// support reseting the balance, which occurs for
		// multi-pass digest processing which occurs for the simulation.
		NSDate *periodInterestStartDate;
		NSDate *startingPeriodInterestStartDate;
}

@property(nonatomic,retain )id<ValueAsOfCalculator> interestRateCalc;
@property(nonatomic,retain ) NSString *workingBalanceName;
@property(nonatomic,retain) InputValDigestSummation *accruedInterest;
@property(nonatomic,retain) NSDate *periodInterestStartDate;
@property(nonatomic,retain) NSDate *startingPeriodInterestStartDate;

- (id) initWithStartingBalance:(double)theStartBalance
	andInterestRate:(DateSensitiveValue*)theInterestRate
	andWorkingBalanceName:(NSString*)wbName
	andStartDate:(NSDate*)theStartDate;

- (void)advanceCurrentBalanceToNextPeriodOnDate:(NSDate*)newDate;

@end
