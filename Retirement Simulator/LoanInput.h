//
//  LoanInput.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Input.h"

@class MultiScenarioInputValue;
@class VariableValue;

extern NSString * const LOAN_INPUT_ENTITY_NAME;

extern NSString * const LOAN_INPUT_TAXABLE_INTEREST_KEY;
extern NSString * const INPUT_LOAN_STARTING_BALANCE_KEY;
extern NSString * const INPUT_LOAN_MULTI_SCEN_EXTRA_PMT_AMT_KEY;

extern NSString * const LOAN_MULTI_SCEN_ORIG_DATE_KEY;
extern NSString * const INPUT_LOAN_MULTI_SCEN_DOWN_PMT_AMT_KEY;
extern NSString * const INPUT_LOAN_MULTI_SCEN_LOAN_COST_AMT_KEY;

extern NSString * const INPUT_LOAN_MULTI_SCEN_EXTRA_PMT_GROWTH_RATE_KEY;
extern NSString * const INPUT_LOAN_MULTI_SCEN_LOAN_COST_GROWTH_RATE_KEY;

extern NSString * const LOAN_INTEREST_RATE_KEY;

@interface LoanInput : Input {
@private
}
@property (nonatomic, retain) NSNumber * taxableInterest;
@property (nonatomic, retain) NSNumber * startingBalance;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioInterestRateFixed;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioInterestRate;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioOrigDate;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioDownPmtAmt;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioDownPmtAmtFixed;

@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioExtraPmtEnabled;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioExtraPmtAmt;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioExtraPmtFrequency;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioExtraPmtAmtFixed;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioExtraPmtGrowthRate;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioExtraPmtGrowthRateFixed;

@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioDownPmtEnabled;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioOrigDateFixed;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioLoanCostAmt;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioLoanCostAmtFixed;

@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioLoanCostGrowthRate;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioLoanCostGrowthRateFixed;

@property (nonatomic,retain) NSSet* variableExtraPmtAmt;
@property (nonatomic,retain) NSSet* variableDownPmtAmt;
@property (nonatomic,retain) NSSet* variableLoanCostAmt;

- (void)addVariableExtraPmtAmtObject:(VariableValue *)value;
- (void)addVariableDownPmtAmtObject:(VariableValue *)value;
- (void)addVariableLoanCostAmtObject:(VariableValue *)value;


@end
