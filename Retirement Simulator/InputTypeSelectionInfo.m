//
//  InputTypeSelectionInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputTypeSelectionInfo.h"
#import "ExpenseInput.h"
#import "IncomeInput.h"
#import "DataModelController.h"
#import "EventRepeatFrequency.h"
#import "FixedValue.h"
#import "FixedDate.h"
#import "NeverEndDate.h"
#import "SharedAppValues.h"
#import "SavingsAccount.h"
#import "Account.h"
#import "MultiScenarioInputValue.h"
#import "RelativeEndDate.h"
#import "BoolInputValue.h"
#import "LoanInput.h"
#import "AssetInput.h"
#import "MultiScenarioAmount.h"
#import "MultiScenarioGrowthRate.h"
#import "TaxInput.h"
#import "TaxBracket.h"
#import "ItemizedTaxAmt.h"
#import "ItemizedTaxAmts.h"
#import "InputCreationHelper.h"


@implementation InputTypeSelectionInfo

@synthesize description;

-(Input*)createInput
{
    assert(0); // must be overridden
    return nil;
}


- (MultiScenarioInputValue*)multiScenInputValueWithDefaultFixedVal:(MultiScenarioInputValue*)fixedVal
{
	InputValue *defaultFixedVal = [fixedVal getDefaultValue]; 

	MultiScenarioInputValue *msInputVal = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	[msInputVal setDefaultValue:defaultFixedVal];
	return msInputVal;
}

- (MultiScenarioInputValue*)multiScenFixedDateWithDefaultToday
{
	MultiScenarioInputValue *msFixedEndDate = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
    FixedDate *fixedEndDate = (FixedDate*)[[
            DataModelController theDataModelController] insertObject:FIXED_DATE_ENTITY_NAME];
    fixedEndDate.date = [NSDate date];
	[msFixedEndDate setDefaultValue:fixedEndDate];
	return msFixedEndDate;

}

- (MultiScenarioInputValue*)multiScenBoolValWithDefault:(BOOL)theDefaultVal
{
	MultiScenarioInputValue *msBoolVal = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	BoolInputValue *boolVal = 
		[[DataModelController theDataModelController] 
		insertObject:BOOL_INPUT_VALUE_ENTITY_NAME];
	boolVal.isTrue = [NSNumber numberWithBool:theDefaultVal];
	[msBoolVal setDefaultValue:boolVal];
	return msBoolVal;

}

- (MultiScenarioInputValue*)multiScenarioRepeatFrequencyOnce
{
	EventRepeatFrequency *repeatOnce = [SharedAppValues singleton].repeatOnceFreq;
	assert(repeatOnce != nil);
	MultiScenarioInputValue *msRepeatFreq = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	[msRepeatFreq setDefaultValue:repeatOnce];
	return msRepeatFreq;

}

- (MultiScenarioInputValue*)multiScenRelEndDateWithImmediateDefault
{
	MultiScenarioInputValue *msFixedRelEndDate = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	RelativeEndDate *fixedRelEndDate = (RelativeEndDate*)[[DataModelController theDataModelController] insertObject:RELATIVE_END_DATE_ENTITY_NAME];
	fixedRelEndDate.years = [NSNumber numberWithInt:0];
	fixedRelEndDate.months = [NSNumber numberWithInt:0];
	fixedRelEndDate.weeks = [NSNumber numberWithInt:0];
	[msFixedRelEndDate setDefaultValue:fixedRelEndDate];
	return msFixedRelEndDate;
}

- (MultiScenarioInputValue*)multiScenNeverEndDate
{
	MultiScenarioInputValue *msNeverEndDate = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	[msNeverEndDate setDefaultValue:[SharedAppValues singleton].sharedNeverEndDate];
	return msNeverEndDate;
}

- (MultiScenarioAmount*)multiScenAmountWithDefault:(double)defaultVal
{
	MultiScenarioAmount *msAmount = 
		[[DataModelController theDataModelController] 
			insertObject:MULTI_SCEN_AMOUNT_ENTITY_NAME];
			
    msAmount.defaultFixedAmount = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	msAmount.amount = [self multiScenInputValueWithDefaultFixedVal:
		msAmount.defaultFixedAmount];

	return msAmount;
}

- (MultiScenarioGrowthRate*)multiScenGrowthRateWithDefault:(double)defaultVal
{
	MultiScenarioGrowthRate *msGrowthRate = 
		[[DataModelController theDataModelController] 
			insertObject:MULTI_SCEN_GROWTH_RATE_ENTITY_NAME];
			
    msGrowthRate.defaultFixedGrowthRate = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	msGrowthRate.growthRate = 
		[self multiScenInputValueWithDefaultFixedVal:msGrowthRate.defaultFixedGrowthRate];
	
			
	return msGrowthRate;
}


-(void)populateCashFlowInputProperties:(CashFlowInput*)newInput
{
    // The following fields are not initialized upon creation, since the user
    // must provide a value (one can't be defaulted).
    //      newInput.name
    //      newInput.amount
    //      newInput.amountGrowthRate
	
	newInput.multiScenarioCashFlowEnabled = [self multiScenBoolValWithDefault:TRUE];
    
    newInput.multiScenarioFixedGrowthRate = [InputCreationHelper multiScenFixedValWithDefault:0.0];

	newInput.multiScenarioFixedAmount = [InputCreationHelper multiScenFixedValWithDefault:0.0];

    newInput.multiScenarioFixedStartDate = [self multiScenFixedDateWithDefaultToday];
    
    newInput.multiScenarioFixedEndDate = [self multiScenFixedDateWithDefaultToday];
	
    newInput.multiScenarioFixedRelEndDate = [self multiScenRelEndDateWithImmediateDefault];

	newInput.multiScenarioEndDate = [self multiScenNeverEndDate];
    	
	newInput.multiScenarioEventRepeatFrequency = [self multiScenarioRepeatFrequencyOnce];
    
}

-(void)populateAccountInputProperties:(Account*)newInput
{
    // The following fields are not initialized upon creation, since the user
    // must provide a value (one can't be defaulted).
    //      newInput.name
    //      newInput.amount
    //      newInput.amountGrowthRate
	
	
	newInput.multiScenarioContribEnabled = [self multiScenBoolValWithDefault:TRUE];

    newInput.multiScenarioFixedContribGrowthRate = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioContribGrowthRate = [self multiScenInputValueWithDefaultFixedVal:newInput.multiScenarioFixedContribGrowthRate];

    newInput.multiScenarioFixedContribAmount = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioContribAmount = [self multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioFixedContribAmount];
	
    newInput.multiScenarioFixedContribStartDate = [self multiScenFixedDateWithDefaultToday];
	newInput.multiScenarioContribStartDate = [self multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioFixedContribStartDate];
	
    newInput.multiScenarioFixedContribEndDate = [self multiScenFixedDateWithDefaultToday];
	newInput.multiScenarioContribEndDate = [self multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioFixedContribEndDate];
	
   newInput.multiScenarioFixedContribRelEndDate = [self multiScenRelEndDateWithImmediateDefault];
	
	newInput.multiScenarioContribRepeatFrequency = [self multiScenarioRepeatFrequencyOnce];
	
	newInput.multiScenarioWithdrawalPriority = [InputCreationHelper multiScenFixedValWithDefault:1.0];
	
	newInput.multiScenarioDeferredWithdrawalsEnabled = [self multiScenBoolValWithDefault:FALSE];
	newInput.multiScenarioDeferredWithdrawalDateFixed = [self multiScenFixedDateWithDefaultToday];
	newInput.multiScenarioDeferredWithdrawalDate = [self multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioDeferredWithdrawalDateFixed];
    
}


@end

@implementation ExpenseInputTypeSelectionInfo


-(Input*)createInput
{
    ExpenseInput *newInput  = (ExpenseInput*)[[DataModelController theDataModelController]
		insertObject:EXPENSE_INPUT_ENTITY_NAME];;
  
    [self populateCashFlowInputProperties:newInput];
	newInput.taxDeductible = [NSNumber numberWithBool:FALSE];
    
    [[DataModelController theDataModelController] saveContext];
    
    return newInput;
}

@end

@implementation IncomeInputTypeSelectionInfo

-(Input*)createInput
{
    IncomeInput *newInput  = (IncomeInput*)[[DataModelController theDataModelController]
		insertObject:INCOME_INPUT_ENTITY_NAME];
	
    [self populateCashFlowInputProperties:newInput];
    
    [[DataModelController theDataModelController] saveContext];
    
    return newInput;
  
}

@end



@implementation SavingsAccountTypeSelectionInfo


-(Input*)createInput
{
	SavingsAccount *savingsAcct = (SavingsAccount*)[[DataModelController theDataModelController] insertObject:SAVINGS_ACCOUNT_ENTITY_NAME];	
	
	[self populateAccountInputProperties:savingsAcct];

	savingsAcct.startingBalance = [NSNumber numberWithDouble:0.0];
	savingsAcct.taxableContributions = [NSNumber numberWithBool:FALSE];
	savingsAcct.taxableWithdrawals = [NSNumber numberWithBool:TRUE];
	savingsAcct.taxableInterest = [NSNumber numberWithBool:FALSE];
	
    savingsAcct.multiScenarioFixedInterestRate = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	savingsAcct.multiScenarioInterestRate = [self multiScenInputValueWithDefaultFixedVal:
		savingsAcct.multiScenarioFixedInterestRate];

	
    [[DataModelController theDataModelController] saveContext];
    
    return savingsAcct;
  
}



@end


@implementation LoanInputTypeSelctionInfo

- (Input*)createInput
{
	LoanInput *newInput  = (LoanInput*)[[DataModelController theDataModelController]
			insertObject:LOAN_INPUT_ENTITY_NAME];
			
	newInput.startingBalance = [NSNumber numberWithDouble:0.0];
	
	newInput.multiScenarioLoanEnabled = [self multiScenBoolValWithDefault:TRUE];
	
	// Loan Cost
	
	newInput.multiScenarioLoanCostAmtFixed = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioLoanCostAmt = [self multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioLoanCostAmtFixed];
		
	newInput.multiScenarioLoanDuration = [InputCreationHelper multiScenFixedValWithDefault:DEFAULT_LOAN_DURATION_MONTHS];	
		
	newInput.multiScenarioLoanCostGrowthRateFixed = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioLoanCostGrowthRate = [self multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioLoanCostGrowthRateFixed];
		
	newInput.multiScenarioOrigDateFixed = [self multiScenFixedDateWithDefaultToday];
	newInput.multiScenarioOrigDate = [self 
		multiScenInputValueWithDefaultFixedVal:newInput.multiScenarioOrigDateFixed ];

	// Interest

	newInput.multiScenarioInterestRateFixed = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioInterestRate = [self 
		multiScenInputValueWithDefaultFixedVal:newInput.multiScenarioInterestRateFixed];

	newInput.taxableInterest = [NSNumber numberWithBool:TRUE];		
		
	// Down Payment	
		
	newInput.multiScenarioDownPmtEnabled = [self multiScenBoolValWithDefault:FALSE];
	
	newInput.multiScenarioDownPmtPercentFixed = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioDownPmtPercent = [self multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioDownPmtPercentFixed];


	// Extra Payments 
	
	newInput.multiScenarioExtraPmtEnabled = [self multiScenBoolValWithDefault:FALSE];
	
	newInput.multiScenarioExtraPmtAmtFixed = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioExtraPmtAmt = [self multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioExtraPmtAmtFixed];
		
	newInput.multiScenarioExtraPmtGrowthRateFixed = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioExtraPmtGrowthRate = [self multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioExtraPmtGrowthRateFixed];
	
	newInput.multiScenarioExtraPmtFrequency = [self multiScenarioRepeatFrequencyOnce];
	
	[[DataModelController theDataModelController] saveContext];
		
	return newInput;
}

@end


@implementation AssetInputTypeSelectionInfo

- (Input*)createInput
{
	AssetInput *newInput  = (AssetInput*)[[DataModelController theDataModelController]
			insertObject:ASSET_INPUT_ENTITY_NAME];
	
	newInput.multiScenarioAssetEnabled = [self multiScenBoolValWithDefault:TRUE];
	
	
	newInput.multiScenarioCostFixed = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioCost = [self multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioCostFixed];

	newInput.multiScenarioApprecRateFixed = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioApprecRate = [self multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioApprecRateFixed];

    newInput.multiScenarioPurchaseDateFixed = [self multiScenFixedDateWithDefaultToday];
	// Note newInput.multiScenarioPurchaseDate is left uninitialized so user can fill in
    newInput.multiScenarioSaleDateFixed = [self multiScenFixedDateWithDefaultToday];
	newInput.multiScenarioSaleDateRelativeFixed = [self multiScenRelEndDateWithImmediateDefault];
	newInput.multiScenarioSaleDate = [self multiScenNeverEndDate];
		
	newInput.startingValue = [NSNumber numberWithDouble:0.0];
	
	newInput.multiScenarioSaleProceedsTaxable = [self multiScenBoolValWithDefault:TRUE];

	return newInput;
}

@end


@implementation TaxInputTypeSelectionInfo


- (TaxBracket*)createTaxBracket
{
	TaxBracket *taxBracket = (TaxBracket*)[[DataModelController theDataModelController]
			insertObject:TAX_BRACKET_ENTITY_NAME];
	taxBracket.cutoffGrowthRate = [self multiScenGrowthRateWithDefault:0.0];
	return taxBracket;
}

- (Input*)createInput
{
	TaxInput *newInput  = (TaxInput*)[[DataModelController theDataModelController]
			insertObject:TAX_INPUT_ENTITY_NAME];
	
	newInput.multiScenarioTaxEnabled = [self multiScenBoolValWithDefault:TRUE];
	
	newInput.exemptionAmt = [self multiScenAmountWithDefault:0.0];
	newInput.stdDeductionAmt = [self multiScenAmountWithDefault:0.0];
	newInput.exemptionGrowthRate = [self multiScenGrowthRateWithDefault:0.0];
	newInput.stdDeductionGrowthRate = [self multiScenGrowthRateWithDefault:0.0];
	
	newInput.itemizedAdjustments = [[DataModelController theDataModelController] 
			insertObject:ITEMIZED_TAX_AMTS_ENTITY_NAME];
	newInput.itemizedDeductions = [[DataModelController theDataModelController] 
			insertObject:ITEMIZED_TAX_AMTS_ENTITY_NAME];
	newInput.itemizedIncomeSources = [[DataModelController theDataModelController] 
			insertObject:ITEMIZED_TAX_AMTS_ENTITY_NAME];
	newInput.itemizedCredits = [[DataModelController theDataModelController] 
			insertObject:ITEMIZED_TAX_AMTS_ENTITY_NAME];

	newInput.taxBracket = [self createTaxBracket];

	return newInput;
}


@end
