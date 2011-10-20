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
@synthesize inputCreationHelper;

-(id)init
{
	self = [super init];
	if(self)
	{
		self.inputCreationHelper = [[[InputCreationHelper alloc] initWithDataModelInterface:[DataModelController theDataModelController]] autorelease];
	}
	return self;
}

-(void)dealloc
{
	[super dealloc];
	[inputCreationHelper release];
}

-(Input*)createInput
{
    assert(0); // must be overridden
    return nil;
}



-(void)populateCashFlowInputProperties:(CashFlowInput*)newInput
{
	newInput.cashFlowEnabled = [inputCreationHelper 
		multiScenBoolValWithDefault:TRUE];
	
	newInput.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	newInput.amount = [inputCreationHelper multiScenAmountWithDefault:0.0];
    
	newInput.startDate = [inputCreationHelper multiScenSimDateWithDefaultToday];
    newInput.endDate = [inputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];
   	
	newInput.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyOnce];
    
}

-(void)populateAccountInputProperties:(Account*)newInput
{
	newInput.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];

	newInput.contribGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	newInput.contribAmount = [inputCreationHelper multiScenAmountWithDefault:0.0];
	
	newInput.contribStartDate = [inputCreationHelper multiScenSimDateWithDefaultToday];
	newInput.contribEndDate = [inputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];
		
	newInput.contribRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyOnce];
	
	newInput.withdrawalPriority = [inputCreationHelper 
		multiScenFixedValWithDefault:1.0];
	
	newInput.deferredWithdrawalsEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	newInput.deferredWithdrawalDate = [inputCreationHelper multiScenSimDateWithDefaultToday];
    
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
	
	savingsAcct.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	
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
	
	newInput.loanEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	
	// Loan Cost
	newInput.loanCost = [inputCreationHelper multiScenAmountWithDefault:0.0];
	
		
	newInput.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:DEFAULT_LOAN_DURATION_MONTHS];	
	
	newInput.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
		
	newInput.origDate = [inputCreationHelper multiScenSimDateWithDefaultToday];

	// Interest
	newInput.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	newInput.taxableInterest = [NSNumber numberWithBool:TRUE];		
		
	// Down Payment	
		
	newInput.downPmtEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	
	newInput.multiScenarioDownPmtPercentFixed = [inputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioDownPmtPercent = [inputCreationHelper multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioDownPmtPercentFixed];


	// Extra Payments 
	
	newInput.extraPmtEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	
	newInput.extraPmtAmt = [inputCreationHelper multiScenAmountWithDefault:0.0];
	newInput.extraPmtGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	newInput.extraPmtFrequency = [inputCreationHelper multiScenarioRepeatFrequencyOnce];
	
	[[DataModelController theDataModelController] saveContext];
		
	return newInput;
}

@end


@implementation AssetInputTypeSelectionInfo

- (Input*)createInput
{
	AssetInput *newInput  = (AssetInput*)[[DataModelController theDataModelController]
			insertObject:ASSET_INPUT_ENTITY_NAME];
	
	newInput.assetEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	
	newInput.cost = [inputCreationHelper multiScenAmountWithDefault:0.0];

	newInput.apprecRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	newInput.purchaseDate = [inputCreationHelper multiScenSimDateWithDefaultToday];
	
	newInput.saleDate = [inputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];
		
	newInput.startingValue = [NSNumber numberWithDouble:0.0];
	
	newInput.multiScenarioSaleProceedsTaxable = [inputCreationHelper multiScenBoolValWithDefault:TRUE];

	return newInput;
}

@end


@implementation TaxInputTypeSelectionInfo


- (TaxBracket*)createTaxBracket
{
	TaxBracket *taxBracket = (TaxBracket*)[[DataModelController theDataModelController]
			insertObject:TAX_BRACKET_ENTITY_NAME];
	taxBracket.cutoffGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	return taxBracket;
}

- (Input*)createInput
{
	TaxInput *newInput  = (TaxInput*)[[DataModelController theDataModelController]
			insertObject:TAX_INPUT_ENTITY_NAME];
	
	newInput.taxEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	
	newInput.exemptionAmt = [inputCreationHelper multiScenAmountWithDefault:0.0];
	newInput.stdDeductionAmt = [inputCreationHelper multiScenAmountWithDefault:0.0];
	newInput.exemptionGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	newInput.stdDeductionGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
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
