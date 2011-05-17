//
//  ExpenseInputSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEventCreator.h"

@class ExpenseInput,EventRepeater;

@interface ExpenseInputSimEventCreator : NSObject <SimEventCreator> {
    @private
        ExpenseInput *expense;
        EventRepeater *eventRepeater;
}

- (id)initWithExpense:(ExpenseInput*)theExpense;

@property(nonatomic,assign) ExpenseInput *expense;

@end
