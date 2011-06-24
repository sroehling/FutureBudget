//
//  ExpenseInputSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CashFlowInputSimEvent.h"
#import "ExpenseInput.h"
#import "NumberHelper.h"

@implementation CashFlowInputSimEvent

@synthesize originatingEventCreator,cashFlow,eventDate;
@synthesize cashFlowAmount;

- (id) initWithEventCreator:(id<SimEventCreator>)eventCreator {
    self = [super init];
    if (self != nil) {
        self.eventDate = [[NSDate alloc]init]; // today
        self.originatingEventCreator = eventCreator;
    }
    return self;
}


// Do the actual event
- (void)doSimEvent
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
	
	
	NSString *currencyAmount = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:self.cashFlowAmount]];
	
    
    NSLog(@"Doing expense event: %@ %@ %@",
          cashFlow.name,
          [dateFormatter stringFromDate:eventDate],
		  currencyAmount);
    
    [dateFormatter release];
    
}

- (void)dealloc {
    // release owned objects here
    [super dealloc]; 
    [eventDate release];
    [cashFlow release];
}


@end
