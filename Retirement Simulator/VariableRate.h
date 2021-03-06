//
//  VariableRate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VariableRate : NSObject {
    @private
		double dailyRate;
		unsigned int daysSinceStart;
}

@property double dailyRate;
@property unsigned int daysSinceStart;

// Helper to convert annual rate down to daily, monthly, etc.
+(double)annualRateToPerPeriodRate:(double)theAnnualRate andNumPeriods:(double)numPeriodsPerYear;
+(double)periodicPaymentForPrincipal:(double)principalAmt andPeriodRate:(double)theRate 
	andNumPeriods:(double)numPayments;

- (id) initWithDailyRate:(double)theRate andDaysSinceStart:(unsigned int)theDaysSinceStart;
- (id) initWithAnnualRate:(double)theRate andDaysSinceStart:(unsigned int)theDaysSinceStart;


@end
