//
//  ExpenseInputSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEventCreator.h"

@class OneTimeExpenseInput,EventRepeater;

@interface ExpenseInputSimEventCreator : NSObject <SimEventCreator> {
    @private
        int numEventsCreated;
        OneTimeExpenseInput *expense;
        EventRepeater *eventRepeater;
}

- (id)initWithExpense:(OneTimeExpenseInput*)theExpense;

@property(nonatomic,retain) OneTimeExpenseInput *expense;

@end
