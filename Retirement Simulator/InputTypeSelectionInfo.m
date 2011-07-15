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
#import "MultiScenarioInputValue.h"


@implementation InputTypeSelectionInfo

@synthesize description;

-(Input*)createInput
{
    assert(0); // must be overridden
    return nil;
}

-(void)populateCashFlowInputProperties:(CashFlowInput*)newInput
{
    // The following fields are not initialized upon creation, since the user
    // must provide a value (one can't be defaulted).
    //      newInput.name
    //      newInput.amount
    //      newInput.amountGrowthRate
	
    
	MultiScenarioInputValue *msFixedGrowthRate = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
    FixedValue *fixedGrowthRate = 
    (FixedValue*)[[DataModelController theDataModelController]insertObject:FIXED_VALUE_ENTITY_NAME];
    fixedGrowthRate.value = [NSNumber numberWithDouble:0.0];
	[msFixedGrowthRate setDefaultValue:fixedGrowthRate];
    newInput.multiScenarioFixedGrowthRate = msFixedGrowthRate;

	MultiScenarioInputValue *msFixedAmount = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
    FixedValue *fixedAmount = 
    (FixedValue*)[[DataModelController theDataModelController]insertObject:FIXED_VALUE_ENTITY_NAME];
    fixedAmount.value = [NSNumber numberWithDouble:0.0];
	[msFixedAmount setDefaultValue:fixedAmount];
    newInput.multiScenarioFixedAmount = msFixedAmount;

	MultiScenarioInputValue *msFixedStartDate = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
    FixedDate *fixedStartDate = (FixedDate*)[[
                DataModelController theDataModelController] insertObject:FIXED_DATE_ENTITY_NAME];
    fixedStartDate.date = [NSDate date];
	[msFixedStartDate setDefaultValue:fixedStartDate];
    newInput.multiScenarioFixedStartDate = msFixedStartDate;
    
	
	MultiScenarioInputValue *msFixedEndDate = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
    FixedDate *fixedEndDate = (FixedDate*)[[
            DataModelController theDataModelController] insertObject:FIXED_DATE_ENTITY_NAME];
    fixedEndDate.date = [NSDate date];
	[msFixedEndDate setDefaultValue:fixedEndDate];
    newInput.multiScenarioFixedEndDate = msFixedEndDate;
	
	
	MultiScenarioInputValue *msEndDate = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	[msEndDate setDefaultValue:[SharedAppValues singleton].sharedNeverEndDate];
	newInput.multiScenarioEndDate = msEndDate;
    
    NSArray *repeatFrequencies = [[DataModelController theDataModelController] fetchSortedObjectsWithEntityName:EVENT_REPEAT_FREQUENCY_ENTITY_NAME sortKey:@"period"];
    assert([repeatFrequencies count] >0);
	
	EventRepeatFrequency *repeatOnce = [SharedAppValues singleton].repeatOnceFreq;
	assert(repeatOnce != nil);
	MultiScenarioInputValue *msRepeatFreq = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	[msRepeatFreq setDefaultValue:repeatOnce];
	newInput.multiScenarioEventRepeatFrequency = msRepeatFreq;
    
}


@end

@implementation ExpenseInputTypeSelectionInfo


-(Input*)createInput
{
    ExpenseInput *newInput  = (ExpenseInput*)[[DataModelController theDataModelController]
		insertObject:EXPENSE_INPUT_ENTITY_NAME];;
  
    [self populateCashFlowInputProperties:newInput];
    
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
	savingsAcct.startingBalance = [NSNumber numberWithDouble:0.0];
	savingsAcct.taxableContributions = [NSNumber numberWithBool:FALSE];
	savingsAcct.taxableWithdrawals = [NSNumber numberWithBool:TRUE];
	
	MultiScenarioInputValue *msFixedInterestRate = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
    FixedValue *fixedInterestRate = 
    (FixedValue*)[[DataModelController theDataModelController]insertObject:FIXED_VALUE_ENTITY_NAME];
    fixedInterestRate.value = [NSNumber numberWithDouble:0.0];
	[msFixedInterestRate setDefaultValue:fixedInterestRate];
    savingsAcct.multiScenarioFixedInterestRate = msFixedInterestRate;

	MultiScenarioInputValue *msInterestRate = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	[msInterestRate setDefaultValue:fixedInterestRate];
	savingsAcct.multiScenarioInterestRate = msInterestRate;

	
    [[DataModelController theDataModelController] saveContext];
    
    return savingsAcct;
  
}

@end