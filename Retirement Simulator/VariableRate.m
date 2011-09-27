//
//  VariableRate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableRate.h"


@implementation VariableRate

@synthesize dailyRate;
@synthesize daysSinceStart;

+(double)periodicPaymentForPrincipal:(double)principalAmt andPeriodRate:(double)theRate andNumPeriods:(double)numPayments
{
	assert(numPayments > 0.0);
	assert(principalAmt >= 0.0);
	assert(theRate >= 0.0);
	
	double rateMultiplier = pow(1.0 + theRate,numPayments); // (1+r)^n
	double periodicPayment =  principalAmt * 
		(
			(theRate * rateMultiplier)
							/
			 (rateMultiplier - 1.0)
		);
	assert(periodicPayment >= 0.0);
	return periodicPayment;
}

+(double)annualRateToPerPeriodRate:(double)theAnnualRate andNumPeriods:(double)numPeriodsPerYear
{
	assert(numPeriodsPerYear >0.0);
	assert(theAnnualRate >= -1.0);
	
	// This forumula accounts for compounding of interest: i.e.:
	// 1+theAnnualRate = (1+perPeriodRate)^numPeriodsPerYear
	// (1+theAnnualRate)^(1/n) = (1+perPeriodRate)
	// (1+theAnnualRate)^(1/n) - 1 = perPeriodRate
	
	double perPeriodRate =  pow(theAnnualRate + 1.0,1.0/numPeriodsPerYear) - 1.0;
	return perPeriodRate;
}

- (id) initWithDailyRate:(double)theRate andDaysSinceStart:(unsigned int)theDaysSinceStart
{
	self = [super init];
	if(self)
	{
		self.daysSinceStart = theDaysSinceStart;
		self.dailyRate = theRate;
	}
	return self;
}

- (id) initWithAnnualRate:(double)theAnnualRate andDaysSinceStart:(unsigned int)theDaysSinceStart
{
	self = [super init];
	if(self)
	{
		self.daysSinceStart = theDaysSinceStart;
		self.dailyRate = [VariableRate annualRateToPerPeriodRate:theAnnualRate andNumPeriods:365.0];
	}
	return self;
	
}

- (id) init 
{
	assert(0); // must call init above
	return nil;
}

@end
