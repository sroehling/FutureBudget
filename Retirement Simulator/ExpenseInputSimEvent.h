//
//  ExpenseInputSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEvent.h"
#import "SimEventCreator.h"

@class ExpenseInput;


@interface ExpenseInputSimEvent : NSObject <SimEvent> {
    id<SimEventCreator> originatingEventCreator;
    NSDate *eventDate;
    ExpenseInput *expense;
}

- (id) initWithEventCreator:(id<SimEventCreator>)eventCreator;

@property (nonatomic, retain) NSDate *eventDate;
// TBD - Should we turn expense into an asssigned attribute, since it is referenced/owned elsewhere

@property(nonatomic,retain)ExpenseInput *expense;
@property (nonatomic, assign) id<SimEventCreator> originatingEventCreator;

@end
