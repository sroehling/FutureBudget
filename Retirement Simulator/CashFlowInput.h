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
@class SimDate;
@class FixedDate;
@class FixedValue;
@class VariableValue;

@interface CashFlowInput : Input {
@private
}
// TBD - Should amount be a variable value? (like growth rates)
@property (nonatomic, retain) DateSensitiveValue *amount;
@property (nonatomic,retain) NSSet* variableAmounts;
@property (nonatomic,retain) DateSensitiveValue *amountGrowthRate; 
@property (nonatomic, retain) EventRepeatFrequency * repeatFrequency;
@property (nonatomic,retain) SimDate *startDate;
@property (nonatomic,retain) SimDate *endDate;

// fixedStartDate is used to hold onto a single fixed
// date value the user can select. If the user then
// selects a milestone date, he/she can come back and select
// the same fixed start date, rather than the fixed
// date reverting back to zero.
@property(nonatomic,retain) FixedDate *fixedStartDate;
@property(nonatomic,retain) FixedDate *fixedEndDate;

// defaultFixedGrowthRate serves the same purpose as 
// fixedStartDate.
@property(nonatomic,retain) FixedValue *defaultFixedGrowthRate;
@property(nonatomic,retain) FixedValue *defaultFixedAmount;


- (void)addVariableAmountsObject:(VariableValue *)value;

@end

