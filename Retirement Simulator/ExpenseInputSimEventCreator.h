//
//  ExpenseInputSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEventCreator.h"

@class OneTimeExpenseInput;

@interface ExpenseInputSimEventCreator : NSObject <SimEventCreator> {
    int numEventsCreated;
    OneTimeExpenseInput *expense;
}

@property(nonatomic,retain) OneTimeExpenseInput *expense;

@end
