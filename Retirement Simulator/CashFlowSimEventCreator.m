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

@protocol SimEventCreator;

@implementation CashFlowSimEventCreator

@synthesize cashFlow;



- (id)initWithCashFlow:(CashFlowInput*)theCashFlow
{
    self = [super init];
    if(self)
    {
        assert(theCashFlow != nil);
        self.cashFlow = theCashFlow;
        return self;
    }
    else
    {
        return nil;
    }
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

    
}


@end
