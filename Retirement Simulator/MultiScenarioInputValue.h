//
//  MultiScenarioInputValue.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME;

@protocol DataModelInterface;

@class ScenarioValue;
@class Scenario;
@class InputValue;
@class SharedAppValues;

@class ItemizedTaxAmt;
@class Account;
@class AssetInput;
@class TaxInput;
@class CashFlowInput;
@class LoanInput;
@class MultiScenarioAmount;
@class MultiScenarioGrowthRate;
@class MultiScenarioSimDate;
@class DataModelController;
@class MultiScenarioSimEndDate;

@interface MultiScenarioInputValue : NSManagedObject {
	@private
}

@property (nonatomic, retain) NSSet* scenarioVals;

// Properties to satisfy inverse relationships
@property (nonatomic, retain) ItemizedTaxAmt * itemizedTaxAmtApplicablePerc;
@property (nonatomic, retain) Account * accountContribEnabled;
@property (nonatomic, retain) Account * accountContribRepeatFrequency;
@property (nonatomic, retain) Account * accountDeferredWithdrawalsEnabled;
@property (nonatomic, retain) Account * accountWithdrawalPriority;
@property (nonatomic, retain) AssetInput * assetEnabled;
@property (nonatomic, retain) TaxInput * taxEnabled;
@property (nonatomic, retain) CashFlowInput * cashFlowEnabled;
@property (nonatomic, retain) CashFlowInput * cashFlowEventRepeatFrequency;
@property (nonatomic, retain) LoanInput * loanDownPmtEnabled;
@property (nonatomic, retain) LoanInput * loanDownPmtPercent;
@property (nonatomic, retain) LoanInput * loanDownPmtPercentFixed;
@property (nonatomic, retain) LoanInput * loanDuration;
@property (nonatomic, retain) LoanInput * loanEnabled;
@property (nonatomic, retain) LoanInput * loanExtraPmtEnabled;
@property (nonatomic, retain) LoanInput * loanExtraPmtFrequency;
@property (nonatomic, retain) MultiScenarioAmount * multiScenAmountAmount;
@property (nonatomic, retain) MultiScenarioAmount * multiScenarioDefaultFixedAmount;
@property (nonatomic, retain) MultiScenarioSimDate * multiScenSimDateDefaultSimDate;
@property (nonatomic, retain) MultiScenarioSimDate * multiScenSimDateSimDate;
@property (nonatomic, retain) MultiScenarioGrowthRate * multiScenGrowthRateDefaultFixedGrowthRate;
@property (nonatomic, retain) MultiScenarioGrowthRate * multiScenGrowthRateGrowthRate;
@property (nonatomic, retain) MultiScenarioSimEndDate * multiScenSimEndDateDefaultFixedSimDate;
@property (nonatomic, retain) MultiScenarioSimEndDate * multiScenSimEndDateFixedRelativeEndDate;
@property (nonatomic, retain) MultiScenarioSimEndDate * multiScenSimEndDateSimDate;


-(void)setValueForScenario:(Scenario*)scenario andInputValue:(InputValue*)inputValue;
-(void)setDefaultValue:(InputValue*)inputValue;
-(InputValue*)findInputValueForScenarioOrDefault:(Scenario*)scenario;
-(InputValue*)getValueForCurrentOrDefaultScenario;
-(InputValue*)getDefaultValue;
- (InputValue*)findInputValueForScenario:(Scenario*)scenario;
- (InputValue*)getValueForScenarioOrDefault:(Scenario*)theScenario;

@end
