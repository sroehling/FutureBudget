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
#import "SharedAppValues.h"
#import "SavingsAccount.h"
#import "Account.h"
#import "LoanInput.h"
#import "AssetInput.h"
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



-(void)populateCashFlowInputProperties:(CashFlowInput*)newInput
{
    // The following fields are not initialized upon creation, since the user
    // must provide a value (one can't be defaulted).
    //      newInput.name
    //      newInput.amount
    //      newInput.amountGrowthRate
	
	newInput.multiScenarioCashFlowEnabled = [InputCreationHelper multiScenBoolValWithDefault:TRUE];
    
    newInput.multiScenarioFixedGrowthRate = [InputCreationHelper multiScenFixedValWithDefault:0.0];

	newInput.multiScenarioFixedAmount = [InputCreationHelper multiScenFixedValWithDefault:0.0];

    newInput.multiScenarioFixedStartDate = [InputCreationHelper multiScenFixedDateWithDefaultToday];
    
    newInput.multiScenarioFixedEndDate = [InputCreationHelper multiScenFixedDateWithDefaultToday];
	
    newInput.multiScenarioFixedRelEndDate = [InputCreationHelper multiScenRelEndDateWithImmediateDefault];

	newInput.multiScenarioEndDate = [InputCreationHelper multiScenNeverEndDate];
    	
	newInput.multiScenarioEventRepeatFrequency = [InputCreationHelper multiScenarioRepeatFrequencyOnce];
    
}

-(void)populateAccountInputProperties:(Account*)newInput
{
    // The following fields are not initialized upon creation, since the user
    // must provide a value (one can't be defaulted).
    //      newInput.name
    //      newInput.amount
    //      newInput.amountGrowthRate
	
	
	newInput.multiScenarioContribEnabled = [InputCreationHelper multiScenBoolValWithDefault:TRUE];

    newInput.multiScenarioFixedContribGrowthRate = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioContribGrowthRate = [InputCreationHelper multiScenInputValueWithDefaultFixedVal:newInput.multiScenarioFixedContribGrowthRate];

    newInput.multiScenarioFixedContribAmount = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioContribAmount = [InputCreationHelper multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioFixedContribAmount];
	
    newInput.multiScenarioFixedContribStartDate = [InputCreationHelper multiScenFixedDateWithDefaultToday];
	newInput.multiScenarioContribStartDate = [InputCreationHelper multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioFixedContribStartDate];
	
    newInput.multiScenarioFixedContribEndDate = [InputCreationHelper multiScenFixedDateWithDefaultToday];
	newInput.multiScenarioContribEndDate = [InputCreationHelper multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioFixedContribEndDate];
	
   newInput.multiScenarioFixedContribRelEndDate = [InputCreationHelper multiScenRelEndDateWithImmediateDefault];
	
	newInput.multiScenarioContribRepeatFrequency = [InputCreationHelper multiScenarioRepeatFrequencyOnce];
	
	newInput.multiScenarioWithdrawalPriority = [InputCreationHelper multiScenFixedValWithDefault:1.0];
	
	newInput.multiScenarioDeferredWithdrawalsEnabled = [InputCreationHelper multiScenBoolValWithDefault:FALSE];
	newInput.multiScenarioDeferredWithdrawalDateFixed = [InputCreationHelper multiScenFixedDateWithDefaultToday];
	newInput.multiScenarioDeferredWithdrawalDate = [InputCreationHelper multiScenInputValueWithDefaultFixedVal:
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
	savingsAcct.multiScenarioInterestRate = [InputCreationHelper multiScenInputValueWithDefaultFixedVal:
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
	
	newInput.multiScenarioLoanEnabled = [InputCreationHelper multiScenBoolValWithDefault:TRUE];
	
	// Loan Cost
	
	newInput.multiScenarioLoanCostAmtFixed = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioLoanCostAmt = [InputCreationHelper multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioLoanCostAmtFixed];
		
	newInput.multiScenarioLoanDuration = [InputCreationHelper multiScenFixedValWithDefault:DEFAULT_LOAN_DURATION_MONTHS];	
		
	newInput.multiScenarioLoanCostGrowthRateFixed = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioLoanCostGrowthRate = [InputCreationHelper multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioLoanCostGrowthRateFixed];
		
	newInput.multiScenarioOrigDateFixed = [InputCreationHelper multiScenFixedDateWithDefaultToday];
	newInput.multiScenarioOrigDate = [InputCreationHelper 
		multiScenInputValueWithDefaultFixedVal:newInput.multiScenarioOrigDateFixed ];

	// Interest

	newInput.multiScenarioInterestRateFixed = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioInterestRate = [InputCreationHelper 
		multiScenInputValueWithDefaultFixedVal:newInput.multiScenarioInterestRateFixed];

	newInput.taxableInterest = [NSNumber numberWithBool:TRUE];		
		
	// Down Payment	
		
	newInput.multiScenarioDownPmtEnabled = [InputCreationHelper multiScenBoolValWithDefault:FALSE];
	
	newInput.multiScenarioDownPmtPercentFixed = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioDownPmtPercent = [InputCreationHelper multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioDownPmtPercentFixed];


	// Extra Payments 
	
	newInput.multiScenarioExtraPmtEnabled = [InputCreationHelper multiScenBoolValWithDefault:FALSE];
	
	newInput.multiScenarioExtraPmtAmtFixed = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioExtraPmtAmt = [InputCreationHelper multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioExtraPmtAmtFixed];
		
	newInput.multiScenarioExtraPmtGrowthRateFixed = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioExtraPmtGrowthRate = [InputCreationHelper multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioExtraPmtGrowthRateFixed];
	
	newInput.multiScenarioExtraPmtFrequency = [InputCreationHelper multiScenarioRepeatFrequencyOnce];
	
	[[DataModelController theDataModelController] saveContext];
		
	return newInput;
}

@end


@implementation AssetInputTypeSelectionInfo

- (Input*)createInput
{
	AssetInput *newInput  = (AssetInput*)[[DataModelController theDataModelController]
			insertObject:ASSET_INPUT_ENTITY_NAME];
	
	newInput.multiScenarioAssetEnabled = [InputCreationHelper multiScenBoolValWithDefault:TRUE];
	
	
	newInput.multiScenarioCostFixed = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioCost = [InputCreationHelper multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioCostFixed];

	newInput.multiScenarioApprecRateFixed = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioApprecRate = [InputCreationHelper multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioApprecRateFixed];

    newInput.multiScenarioPurchaseDateFixed = [InputCreationHelper multiScenFixedDateWithDefaultToday];
	// Note newInput.multiScenarioPurchaseDate is left uninitialized so user can fill in
    newInput.multiScenarioSaleDateFixed = [InputCreationHelper multiScenFixedDateWithDefaultToday];
	newInput.multiScenarioSaleDateRelativeFixed = [InputCreationHelper multiScenRelEndDateWithImmediateDefault];
	newInput.multiScenarioSaleDate = [InputCreationHelper multiScenNeverEndDate];
		
	newInput.startingValue = [NSNumber numberWithDouble:0.0];
	
	newInput.multiScenarioSaleProceedsTaxable = [InputCreationHelper multiScenBoolValWithDefault:TRUE];

	return newInput;
}

@end


@implementation TaxInputTypeSelectionInfo


- (TaxBracket*)createTaxBracket
{
	TaxBracket *taxBracket = (TaxBracket*)[[DataModelController theDataModelController]
			insertObject:TAX_BRACKET_ENTITY_NAME];
	taxBracket.cutoffGrowthRate = [InputCreationHelper multiScenGrowthRateWithDefault:0.0];
	return taxBracket;
}

- (Input*)createInput
{
	TaxInput *newInput  = (TaxInput*)[[DataModelController theDataModelController]
			insertObject:TAX_INPUT_ENTITY_NAME];
	
	newInput.multiScenarioTaxEnabled = [InputCreationHelper multiScenBoolValWithDefault:TRUE];
	
	newInput.exemptionAmt = [InputCreationHelper multiScenAmountWithDefault:0.0];
	newInput.stdDeductionAmt = [InputCreationHelper multiScenAmountWithDefault:0.0];
	newInput.exemptionGrowthRate = [InputCreationHelper multiScenGrowthRateWithDefault:0.0];
	newInput.stdDeductionGrowthRate = [InputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
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
