//
//  ExpenseInputSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CashFlowSimEventCreator.h"
#import "CashFlowInputSimEvent.h"

#import "ExpenseInput.h"
#import "EventRepeater.h"
#import "CashFlowInput.h"
#import "VariableDate.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "DateHelper.h"
#import "VariableRateCalculator.h"
#import "ValueAsOfCalculatorCreator.h"

@protocol SimEventCreator;

@implementation CashFlowSimEventCreator

@synthesize cashFlow;
@synthesize varRateCalc;
@synthesize startAmountGrowthDate;
@synthesize varAmountCalc;

- (id)initWithCashFlow:(CashFlowInput*)theCashFlow
{
    self = [super init];
    if(self)
    {
        assert(theCashFlow != nil);
        self.cashFlow = theCashFlow;
	
	
		self.startAmountGrowthDate = theCashFlow.startDate.date;

		DateSensitiveValueVariableRateCalculatorCreator *calcCreator = 
		   [[[DateSensitiveValueVariableRateCalculatorCreator alloc] init] autorelease];
		self.varRateCalc = [calcCreator 
							createForDateSensitiveValue:self.cashFlow.amountGrowthRate 
							andStartDate:self.startAmountGrowthDate];
							
		ValueAsOfCalculatorCreator *varAmountCalcCreator = 
			[[[ValueAsOfCalculatorCreator alloc] init] autorelease];
		self.varAmountCalc = [varAmountCalcCreator createForDateSensitiveValue:self.cashFlow.amount];
							
    }
    return self;
}

- (id) init 
{
	assert(0);
	return nil;
}



- (void)resetSimEventCreation
{
    if(eventRepeater!=nil)
    {
        [eventRepeater release];
    }
    eventRepeater = [[EventRepeater alloc] 
                     initWithEventRepeatFrequency:self.cashFlow.repeatFrequency 
                     andStartDate:self.cashFlow.startDate.date];
   
}

- (id<SimEvent>)nextSimEvent
{
    assert(eventRepeater!=nil);
    NSDate *nextDate = [eventRepeater nextDate];
    if(nextDate !=nil)
    {
        CashFlowInputSimEvent *theEvent = [[CashFlowInputSimEvent alloc]initWithEventCreator:self ];
        assert(cashFlow != nil);
        theEvent.cashFlow = cashFlow;
        theEvent.eventDate = nextDate;
		
		NSTimeInterval secondsSinceAmountGrowth = [nextDate timeIntervalSinceDate:self.startAmountGrowthDate];
		// TBD - is the right to not include values which come before the start date? Or
		// Should the startingvalue come before all other values, meaning a variable
		// value could be in effect at the start date.
		assert(secondsSinceAmountGrowth >= 0.0);
		unsigned int daysSinceStart = floor(secondsSinceAmountGrowth/SECONDS_PER_DAY);
		double amountMultiplier = [self.varRateCalc valueMultiplierForDay:daysSinceStart];
		double unadjustedAmount = [self.varAmountCalc valueAsOfDate:nextDate];
		double growthAdjustedCashFlowAmount = unadjustedAmount * amountMultiplier;
		
		theEvent.cashFlowAmount = growthAdjustedCashFlowAmount;
		
        [theEvent autorelease];
        
        return theEvent;
       
    }
    else
    {
        // TBD - Is this good objective C style to return nil for governing control flow
        return nil;
    }
}

- (void)dealloc {
    // release owned objects here
    [super dealloc]; // pretty important.
    if(eventRepeater!=nil)
    {
        [eventRepeater release];
    }
	[varRateCalc release];
	[startAmountGrowthDate release];
	[varAmountCalc release];
}


@end
