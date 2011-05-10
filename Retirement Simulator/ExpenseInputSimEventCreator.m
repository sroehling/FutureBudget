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

@protocol SimEventCreator;

@implementation ExpenseInputSimEventCreator

@synthesize expense;

- (void)resetSimEventCreation
{
    numEventsCreated = 0;
}

- (id<SimEvent>)nextSimEvent
{
    if(numEventsCreated == 0)
    {
        numEventsCreated++;
        ExpenseInputSimEvent *theEvent = [[ExpenseInputSimEvent alloc]initWithEventCreator:self ];
        assert(expense != nil);
        theEvent.expense = expense;
        theEvent.eventDate = expense.transactionDate;
        [theEvent autorelease];
        
        return theEvent;
    }
    else
    {
        return nil;
    }
}

- (void)dealloc {
    // release owned objects here
    [super dealloc]; // pretty important.
    [expense release];
    
}


@end
