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

@class OneTimeExpenseInput;


@interface ExpenseInputSimEvent : NSObject <SimEvent> {
    id<SimEventCreator> originatingEventCreator;
    NSDate *eventDate;
    OneTimeExpenseInput *expense;
}

- (id) initWithEventCreator:(id<SimEventCreator>)eventCreator;

@property (nonatomic, retain) NSDate *eventDate;
@property(nonatomic,retain)OneTimeExpenseInput *expense;
@property (nonatomic, assign) id<SimEventCreator> originatingEventCreator;

@end
