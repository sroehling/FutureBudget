//
//  MultiScenarioAmount.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const MULTI_SCEN_AMOUNT_ENTITY_NAME;
extern NSString * const MULTI_SCEN_AMOUNT_AMOUNT_KEY;


@class MultiScenarioInputValue, VariableValue;

@interface MultiScenarioAmount : NSManagedObject {
@private
}
@property (nonatomic, retain) MultiScenarioInputValue * amount;
@property (nonatomic, retain) MultiScenarioInputValue * defaultFixedAmount;
@property (nonatomic, retain) NSSet* variableAmounts;

- (void)addVariableAmountsObject:(VariableValue *)value;

@end
