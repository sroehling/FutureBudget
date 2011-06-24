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

@class CashFlowInput;


@interface CashFlowInputSimEvent : NSObject <SimEvent> {
	@private
		id<SimEventCreator> originatingEventCreator;
		NSDate *eventDate;
		CashFlowInput *cashFlow;
		double cashFlowAmount;
}

- (id) initWithEventCreator:(id<SimEventCreator>)eventCreator;

@property (nonatomic, retain) NSDate *eventDate;
// TBD - Should we turn expense into an asssigned attribute, since it is referenced/owned elsewhere

@property(nonatomic,retain)CashFlowInput *cashFlow;
@property double cashFlowAmount; 
@property (nonatomic, assign) id<SimEventCreator> originatingEventCreator;

@end
