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

@class MultiScenarioInputValue, VariableValue;

@class Account;
@class AssetInput;
@class TaxInput;
@class CashFlowInput;
@class LoanInput;

@interface MultiScenarioAmount : NSManagedObject {
@private
}
@property (nonatomic, retain) MultiScenarioInputValue * amount;
@property (nonatomic, retain) MultiScenarioInputValue * defaultFixedAmount;
@property (nonatomic, retain) NSSet* variableAmounts;

// Inverse relationships
@property (nonatomic, retain) Account * accountContribAmount;
@property (nonatomic, retain) AssetInput * assetCost;
@property (nonatomic, retain) TaxInput * taxExemptionAmt;
@property (nonatomic, retain) TaxInput * taxStdDeductionAmt;
@property (nonatomic, retain) CashFlowInput * cashFlowAmount;
@property (nonatomic, retain) LoanInput * loanCost;
@property (nonatomic, retain) LoanInput * loanExtraPmtAmt;


- (void)addVariableAmountsObject:(VariableValue *)value;

@end
