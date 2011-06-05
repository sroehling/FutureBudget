//
//  CashFlowInput.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Input.h"

@class EventRepeatFrequency;
@class DateSensitiveValue;
@class VariableDate;
@class FixedDate;

@interface CashFlowInput : Input {
@private
}
// TBD - Should amount be a variable value? (like growth rates)
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic,retain) DateSensitiveValue *amountGrowthRate; 
@property (nonatomic, retain) NSDate * transactionDate;
@property (nonatomic, retain) EventRepeatFrequency * repeatFrequency;
@property (nonatomic,retain) VariableDate *startDate;


// fixedStartDate is used to hold onto a single fixed
// date value the user can select. If the user then
// selects a milestone date, he/she can come back and select
// the same fixed start date, rather than the fixed
// date reverting back to zero.
@property(nonatomic,retain) FixedDate *fixedStartDate;

@end
