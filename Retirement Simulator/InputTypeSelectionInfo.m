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
#import "TransferInput.h"
#import "TransferEndpointAcct.h"


@implementation InputTypeSelectionInfo

@synthesize description;
@synthesize inputCreationHelper;
@synthesize dataModelInterface;

-(id)initWithInputCreationHelper:(InputCreationHelper*)theHelper 
	andDataModelInterface:(id<DataModelInterface>)theDataModelInterface
{
	self = [super init];
	if(self)
	{
		assert(theHelper != nil);
		self.inputCreationHelper = theHelper;
		
		assert(theDataModelInterface != nil);
		self.dataModelInterface = theDataModelInterface;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}



-(void)dealloc
{
	[inputCreationHelper release];
	[dataModelInterface release];
	[super dealloc];
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
	
	newInput.amountGrowthRate = [inputCreationHelper multiScenDefaultGrowthRate];
	
	newInput.amount = [inputCreationHelper multiScenAmountWithWithDefaultButNoInitialVal:0.0];
	    
	newInput.startDate = [inputCreationHelper multiScenSimDateWithDefaultToday];
    newInput.endDate = [inputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];
   	
	newInput.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyMonthly];
    
}

-(void)populateAccountInputProperties:(Account*)newInput
{
	
	newInput.iconImageName = ACCOUNT_INPUT_DEFAULT_ICON_NAME;

	newInput.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];

	newInput.contribGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	newInput.contribAmount = [inputCreationHelper multiScenAmountWithDefault:0.0];
	
	newInput.contribStartDate = [inputCreationHelper multiScenSimDateWithDefaultToday];
	newInput.contribEndDate = [inputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];
		
	newInput.contribRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyOnce];
	
	newInput.withdrawalPriority = [inputCreationHelper 
		multiScenFixedValWithDefault:1.0];
	
	newInput.deferredWithdrawalsEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	newInput.deferredWithdrawalDate = [inputCreationHelper multiScenSimDateWithDefaultToday];
    
	newInput.interestRate = [inputCreationHelper multiScenGrowthRateWithDefaultButNoInitialVal:0.0];
	
	TransferEndpointAcct *acctTransferEndpoint = 
		(TransferEndpointAcct *)[self.dataModelInterface createDataModelObject:TRANSFER_ENDPOINT_ACCT_ENTITY_NAME];
	acctTransferEndpoint.account = newInput;

}


@end

@implementation ExpenseInputTypeSelectionInfo


-(Input*)createInput
{
	
    ExpenseInput *newInput  = (ExpenseInput*)[self.dataModelInterface 
		createDataModelObject:EXPENSE_INPUT_ENTITY_NAME];;
  
	newInput.iconImageName = EXPENSE_INPUT_DEFAULT_ICON_NAME;
  
    [self populateCashFlowInputProperties:newInput];  
	    
    return newInput;
}

@end

@implementation IncomeInputTypeSelectionInfo

-(Input*)createInput
{
    IncomeInput *newInput  = (IncomeInput*)[self.dataModelInterface 
		createDataModelObject:INCOME_INPUT_ENTITY_NAME];
		
	newInput.iconImageName = INCOME_INPUT_DEFAULT_ICON_NAME;
	
    [self populateCashFlowInputProperties:newInput];
        
    return newInput;
  
}

@end


@implementation TransferInputTypeSelectionInfo

-(Input*)createInput
{
    TransferInput *newInput  = (TransferInput*)[self.dataModelInterface 
		createDataModelObject:TRANSFER_INPUT_ENTITY_NAME];
		
	newInput.iconImageName = TRANSFER_INPUT_DEFAULT_ICON_NAME;
	
    [self populateCashFlowInputProperties:newInput];
        
    return newInput;
  
}

@end



@implementation SavingsAccountTypeSelectionInfo


-(Input*)createInput
{
	SavingsAccount *savingsAcct = (SavingsAccount*)[self.dataModelInterface 
		createDataModelObject:SAVINGS_ACCOUNT_ENTITY_NAME];
		
	savingsAcct.iconImageName = ACCOUNT_INPUT_DEFAULT_ICON_NAME;
	
	[self populateAccountInputProperties:savingsAcct];
	    
    return savingsAcct;
  
}



@end


@implementation LoanInputTypeSelctionInfo

- (Input*)createInput
{
	LoanInput *newInput  = (LoanInput*)[self.dataModelInterface 
		createDataModelObject:LOAN_INPUT_ENTITY_NAME];
		
	newInput.iconImageName = LOAN_INPUT_DEFAULT_ICON_NAME;
				
	newInput.loanEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	
	// Loan Cost
	newInput.loanCost = [inputCreationHelper multiScenAmountWithWithDefaultButNoInitialVal:0.0];
	
		
	newInput.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:DEFAULT_LOAN_DURATION_MONTHS];	
	
	newInput.loanCostGrowthRate = [inputCreationHelper multiScenDefaultGrowthRate];
		
	newInput.origDate = [inputCreationHelper multiScenSimDateWithDefaultTodayButNoInitialVal];

	// Interest
	newInput.interestRate = [inputCreationHelper multiScenGrowthRateWithDefaultButNoInitialVal:0.0];
		
	// Down Payment	
		
	newInput.downPmtEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	
	newInput.multiScenarioDownPmtPercentFixed = [inputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioDownPmtPercent = [inputCreationHelper multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioDownPmtPercentFixed];


	// Extra Payments 
	
	newInput.extraPmtEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	
	newInput.extraPmtAmt = [inputCreationHelper multiScenAmountWithDefault:0.0];
	newInput.extraPmtGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	// TBD - extraPmtFrequency doesn't 
	// have any UI input - Should this change
	newInput.extraPmtFrequency = [inputCreationHelper multiScenarioRepeatFrequencyMonthly];
	
	
	newInput.earlyPayoffDate = [inputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];
			
	return newInput;
}

@end


@implementation AssetInputTypeSelectionInfo

- (Input*)createInput
{
	AssetInput *newInput  = (AssetInput*)[self.dataModelInterface 
		createDataModelObject:ASSET_INPUT_ENTITY_NAME];
		
	newInput.iconImageName = ASSET_INPUT_DEFAULT_ICON_NAME;
	
	newInput.assetEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	
	newInput.cost = [inputCreationHelper multiScenAmountWithWithDefaultButNoInitialVal:0.0];

	newInput.apprecRate = [inputCreationHelper multiScenGrowthRateWithDefaultButNoInitialVal:0.0];

	newInput.purchaseDate = [inputCreationHelper multiScenSimDateWithDefaultTodayButNoInitialVal];
	
	newInput.saleDate = [inputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];
			
	return newInput;
}

@end


@implementation TaxInputTypeSelectionInfo


- (TaxBracket*)createTaxBracket
{
	TaxBracket *taxBracket = (TaxBracket*)[self.dataModelInterface 
		createDataModelObject:TAX_BRACKET_ENTITY_NAME];
	taxBracket.cutoffGrowthRate = [inputCreationHelper multiScenDefaultGrowthRate];
	return taxBracket;
}

- (Input*)createInput
{
	TaxInput *newInput  = (TaxInput*)[self.dataModelInterface 
		createDataModelObject:TAX_INPUT_ENTITY_NAME];
		
	newInput.iconImageName = TAX_INPUT_DEFAULT_ICON_NAME;
	
	newInput.taxEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	
	newInput.exemptionAmt = [inputCreationHelper multiScenAmountWithDefault:0.0];
	newInput.stdDeductionAmt = [inputCreationHelper multiScenAmountWithDefault:0.0];
	newInput.exemptionGrowthRate = [inputCreationHelper multiScenDefaultGrowthRate];
	newInput.stdDeductionGrowthRate = [inputCreationHelper multiScenDefaultGrowthRate];
	
	newInput.itemizedAdjustments = [self.dataModelInterface 
		createDataModelObject:ITEMIZED_TAX_AMTS_ENTITY_NAME];
	newInput.itemizedDeductions = [self.dataModelInterface 
		createDataModelObject:ITEMIZED_TAX_AMTS_ENTITY_NAME];
	newInput.itemizedIncomeSources = [self.dataModelInterface 
		createDataModelObject:ITEMIZED_TAX_AMTS_ENTITY_NAME];
	newInput.itemizedCredits = [self.dataModelInterface 
		createDataModelObject:ITEMIZED_TAX_AMTS_ENTITY_NAME];

	newInput.taxBracket = [self createTaxBracket];

	return newInput;
}


@end
