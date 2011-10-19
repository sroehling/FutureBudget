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


#define DEFAULT_LOAN_DURATION_MONTHS 60.0

@class MultiScenarioInputValue;
@class MultiScenarioAmount;
@class MultiScenarioGrowthRate;
@class MultiScenarioSimDate;

extern NSString * const LOAN_INPUT_ENTITY_NAME;

extern NSString * const LOAN_INPUT_TAXABLE_INTEREST_KEY;
extern NSString * const INPUT_LOAN_STARTING_BALANCE_KEY;
extern NSString * const INPUT_LOAN_MULTI_SCEN_DOWN_PMT_PERCENT_KEY;


@interface LoanInput : Input {
@private
}
@property (nonatomic, retain) NSNumber * taxableInterest;
@property (nonatomic, retain) NSNumber * startingBalance;

@property (nonatomic, retain) MultiScenarioInputValue * loanEnabled;

@property (nonatomic, retain) MultiScenarioGrowthRate * interestRate;
@property (nonatomic, retain) MultiScenarioInputValue * extraPmtEnabled;
@property (nonatomic, retain) MultiScenarioInputValue * extraPmtFrequency;
@property (nonatomic, retain) MultiScenarioAmount * extraPmtAmt;
@property (nonatomic, retain) MultiScenarioGrowthRate * extraPmtGrowthRate;
@property (nonatomic, retain) MultiScenarioInputValue * downPmtEnabled;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioDownPmtPercent;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioDownPmtPercentFixed;

@property (nonatomic, retain) MultiScenarioSimDate * origDate;

@property (nonatomic, retain) MultiScenarioAmount * loanCost;
@property (nonatomic, retain) MultiScenarioGrowthRate *loanCostGrowthRate;

@property (nonatomic, retain) MultiScenarioInputValue * loanDuration;



@end
