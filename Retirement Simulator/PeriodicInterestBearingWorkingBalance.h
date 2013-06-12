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
}

@property(nonatomic,retain )id<ValueAsOfCalculator> interestRateCalc;
@property(nonatomic,retain ) NSString *workingBalanceName;
@property(nonatomic,retain) InputValDigestSummation *accruedInterest;

- (id) initWithStartingBalance:(double)theStartBalance
	andInterestRate:(DateSensitiveValue*)theInterestRate
	andWorkingBalanceName:(NSString*)wbName
	andStartDate:(NSDate*)theStartDate;

- (void)advanceCurrentBalanceToNextPeriodOnDate:(NSDate*)newDate;

@end
