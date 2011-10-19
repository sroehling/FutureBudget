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
	newInput.multiScenarioCashFlowEnabled = [InputCreationHelper 
		multiScenBoolValWithDefault:TRUE];
	
	newInput.amountGrowthRate = [InputCreationHelper multiScenGrowthRateWithDefault:0.0];
	newInput.amount = [InputCreationHelper multiScenAmountWithDefault:0.0];
    
	newInput.startDate = [InputCreationHelper multiScenSimDateWithDefaultToday];
    newInput.endDate = [InputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];
   	
	newInput.multiScenarioEventRepeatFrequency = [InputCreationHelper multiScenarioRepeatFrequencyOnce];
    
}

-(void)populateAccountInputProperties:(Account*)newInput
{
	newInput.multiScenarioContribEnabled = [InputCreationHelper multiScenBoolValWithDefault:TRUE];

	newInput.contribGrowthRate = [InputCreationHelper multiScenGrowthRateWithDefault:0.0];

	newInput.contribAmount = [InputCreationHelper multiScenAmountWithDefault:0.0];
	
	newInput.contribStartDate = [InputCreationHelper multiScenSimDateWithDefaultToday];
	newInput.contribEndDate = [InputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];
		
	newInput.multiScenarioContribRepeatFrequency = [InputCreationHelper multiScenarioRepeatFrequencyOnce];
	
	newInput.multiScenarioWithdrawalPriority = [InputCreationHelper 
		multiScenFixedValWithDefault:1.0];
	
	newInput.multiScenarioDeferredWithdrawalsEnabled = [InputCreationHelper multiScenBoolValWithDefault:FALSE];
	newInput.deferredWithdrawalDate = [InputCreationHelper multiScenSimDateWithDefaultToday];
    
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
	
	savingsAcct.interestRate = [InputCreationHelper multiScenGrowthRateWithDefault:0.0];

	
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
	newInput.loanCost = [InputCreationHelper multiScenAmountWithDefault:0.0];
	
		
	newInput.multiScenarioLoanDuration = [InputCreationHelper multiScenFixedValWithDefault:DEFAULT_LOAN_DURATION_MONTHS];	
	
	newInput.loanCostGrowthRate = [InputCreationHelper multiScenGrowthRateWithDefault:0.0];
		
	newInput.origDate = [InputCreationHelper multiScenSimDateWithDefaultToday];

	// Interest
	newInput.interestRate = [InputCreationHelper multiScenGrowthRateWithDefault:0.0];

	newInput.taxableInterest = [NSNumber numberWithBool:TRUE];		
		
	// Down Payment	
		
	newInput.multiScenarioDownPmtEnabled = [InputCreationHelper multiScenBoolValWithDefault:FALSE];
	
	newInput.multiScenarioDownPmtPercentFixed = [InputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioDownPmtPercent = [InputCreationHelper multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioDownPmtPercentFixed];


	// Extra Payments 
	
	newInput.multiScenarioExtraPmtEnabled = [InputCreationHelper multiScenBoolValWithDefault:FALSE];
	
	newInput.extraPmtAmt = [InputCreationHelper multiScenAmountWithDefault:0.0];
	newInput.extraPmtGrowthRate = [InputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
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
	
	newInput.cost = [InputCreationHelper multiScenAmountWithDefault:0.0];

	newInput.apprecRate = [InputCreationHelper multiScenGrowthRateWithDefault:0.0];

	newInput.purchaseDate = [InputCreationHelper multiScenSimDateWithDefaultToday];
	
	newInput.saleDate = [InputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];
		
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
