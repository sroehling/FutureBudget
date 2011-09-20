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


@implementation InputTypeSelectionInfo

@synthesize description;

-(Input*)createInput
{
    assert(0); // must be overridden
    return nil;
}

- (MultiScenarioInputValue*)multiScenFixedValWithDefault:(double)defaultVal
{
	MultiScenarioInputValue *msFixedVal = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
    FixedValue *fixedVal = 
		(FixedValue*)[[DataModelController theDataModelController]insertObject:FIXED_VALUE_ENTITY_NAME];
    fixedVal.value = [NSNumber numberWithDouble:defaultVal];
	[msFixedVal setDefaultValue:fixedVal];
	return msFixedVal;
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


-(void)populateCashFlowInputProperties:(CashFlowInput*)newInput
{
    // The following fields are not initialized upon creation, since the user
    // must provide a value (one can't be defaulted).
    //      newInput.name
    //      newInput.amount
    //      newInput.amountGrowthRate
	
	newInput.multiScenarioCashFlowEnabled = [self multiScenBoolValWithDefault:TRUE];
    
    newInput.multiScenarioFixedGrowthRate = [self multiScenFixedValWithDefault:0.0];

	newInput.multiScenarioFixedAmount = [self multiScenFixedValWithDefault:0.0];

    newInput.multiScenarioFixedStartDate = [self multiScenFixedDateWithDefaultToday];
    
    newInput.multiScenarioFixedEndDate = [self multiScenFixedDateWithDefaultToday];
	
    newInput.multiScenarioFixedRelEndDate = [self multiScenRelEndDateWithImmediateDefault];

	MultiScenarioInputValue *msEndDate = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	[msEndDate setDefaultValue:[SharedAppValues singleton].sharedNeverEndDate];
	newInput.multiScenarioEndDate = msEndDate;
    	
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

    newInput.multiScenarioFixedContribGrowthRate = [self multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioContribGrowthRate = [self multiScenInputValueWithDefaultFixedVal:newInput.multiScenarioFixedContribGrowthRate];

    newInput.multiScenarioFixedContribAmount = [self multiScenFixedValWithDefault:0.0];
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
	
    savingsAcct.multiScenarioFixedInterestRate = [self multiScenFixedValWithDefault:0.0];
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
	
	newInput.multiScenarioLoanCostAmtFixed = [self multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioLoanCostAmt = [self multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioLoanCostAmtFixed];
		
	newInput.multiScenarioLoanDuration = [self multiScenFixedValWithDefault:DEFAULT_LOAN_DURATION_MONTHS];	
		
	newInput.multiScenarioLoanCostGrowthRateFixed = [self multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioLoanCostGrowthRate = [self multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioLoanCostGrowthRateFixed];
		
	newInput.multiScenarioOrigDateFixed = [self multiScenFixedDateWithDefaultToday];
	newInput.multiScenarioOrigDate = [self 
		multiScenInputValueWithDefaultFixedVal:newInput.multiScenarioOrigDateFixed ];

	// Interest

	newInput.multiScenarioInterestRateFixed = [self multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioInterestRate = [self 
		multiScenInputValueWithDefaultFixedVal:newInput.multiScenarioInterestRateFixed];

	newInput.taxableInterest = [NSNumber numberWithBool:TRUE];		
		
	// Down Payment	
		
	newInput.multiScenarioDownPmtEnabled = [self multiScenBoolValWithDefault:FALSE];
	
	newInput.multiScenarioDownPmtPercentFixed = [self multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioDownPmtPercent = [self multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioDownPmtPercentFixed];


	// Extra Payments 
	
	newInput.multiScenarioExtraPmtEnabled = [self multiScenBoolValWithDefault:FALSE];
	
	newInput.multiScenarioExtraPmtAmtFixed = [self multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioExtraPmtAmt = [self multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioExtraPmtAmtFixed];
		
	newInput.multiScenarioExtraPmtGrowthRateFixed = [self multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioExtraPmtGrowthRate = [self multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioExtraPmtGrowthRateFixed];
	
	newInput.multiScenarioExtraPmtFrequency = [self multiScenarioRepeatFrequencyOnce];
	
	[[DataModelController theDataModelController] saveContext];
		
	return newInput;
}

@end