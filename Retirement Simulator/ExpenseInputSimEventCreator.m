//
//  ExpenseInputSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExpenseInputSimEventCreator.h"
#import "ExpenseInputSimEvent.h"

#import "OneTimeExpenseInput.h"
#import "EventRepeater.h"

@protocol SimEventCreator;

@implementation ExpenseInputSimEventCreator

@synthesize expense;



- (id)initWithExpense:(OneTimeExpenseInput*)theExpense
{
    self = [super init];
    if(self)
    {
        assert(theExpense != nil);
        expense = theExpense;
        return self;
    }
    else
    {
        return nil;
    }
}

- (void)resetSimEventCreation
{
    numEventsCreated = 0;
    [eventRepeater release];
    eventRepeater = [[EventRepeater alloc] 
                     initWithEventRepeatFrequency:expense.repeatFrequency 
                     andStartDate:expense.transactionDate];
   
}

- (id<SimEvent>)nextSimEvent
{
    assert(eventRepeater!=nil);
    NSDate *nextDate = [eventRepeater nextDate];
    if(nextDate !=nil)
    {
        ExpenseInputSimEvent *theEvent = [[ExpenseInputSimEvent alloc]initWithEventCreator:self ];
        assert(expense != nil);
        theEvent.expense = expense;
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
    [expense release];
    [eventRepeater release];
    
}


@end
