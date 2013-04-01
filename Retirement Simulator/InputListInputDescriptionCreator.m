//
//  InputListInputDescriptionCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputListInputDescriptionCreator.h"
#import "Input.h"

#import "NumberHelper.h"
#import "DateHelper.h"
#import "ExpenseInput.h"
#import "IncomeInput.h"
#import "SimDate.h"
#import "EventRepeatFrequency.h"
#import "VariableValueRuntimeInfo.h"
#import "DateSensitiveValue.h"
#import "SharedEntityVariableValueListMgr.h"
#import "LoanInput.h"
#import "MultiScenarioInputValue.h"
#import "LocalizationHelper.h"
#import "AssetInput.h"
#import "NumberHelper.h"
#import "TaxInput.h"
#import "SavingsAccount.h"
#import "MultiScenarioGrowthRate.h"
#import "MultiScenarioAmount.h"
#import "MultiScenarioSimDate.h"
#import "MultiScenarioSimEndDate.h"
#import "MultiScenarioInputValue.h"
#import "DataModelController.h"
#import "TransferInput.h"
#import "AppHelper.h"
#import "TransferEndpoint.h"
#import "SharedAppValues.h"
#import "TaxBracket.h"
#import "ItemizedTaxAmts.h"
#import "ItemizedTaxAmtsInfo.h"
#import "ItemizedTaxAmtFieldPopulator.h"


@implementation InputListInputDescriptionCreator 

@synthesize generatedDesc;
@synthesize dataModelController;
@synthesize sharedAppVals;

-(id)initWithDataModelController:(DataModelController*)theDataModelController
{
	self = [super init];
	if(self)
	{
		assert(theDataModelController != nil);
		self.dataModelController = theDataModelController;
		
		self.sharedAppVals = [SharedAppValues getUsingDataModelController:self.dataModelController];
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}


-(NSString*)formattedCashFlowAmount:(CashFlowInput *)cashFlow
{
	VariableValueRuntimeInfo *varValRuntimeInfo = [VariableValueRuntimeInfo 
		createForDataModelController:self.dataModelController
		andMultiScenarioAmount:cashFlow.amount 
		withValueTitle:LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_AMOUNT_FIELD_LABEL")
		andValueName:cashFlow.name];

	DateSensitiveValue *amount = (DateSensitiveValue*)
			[cashFlow.amount.amount getValueForCurrentOrDefaultScenario];
	NSString *amountDisplay = [amount inlineDescription:varValRuntimeInfo];
	
	return amountDisplay;

}

-(NSString*)formattedMultiScenarioInputDate:(MultiScenarioSimDate*)cashFlowDate
{
	SimDate *theDate = (SimDate*)[cashFlowDate.simDate getValueForCurrentOrDefaultScenario]; 
	NSString *dateDisplay = [theDate
		inlineDescription:[DateHelper theHelper].mediumDateFormatter];
	return dateDisplay;
}

-(NSString*)formattedCashFlowGrowthRate:(CashFlowInput*)cashFlow
{
	DateSensitiveValue *amountGrowthRate = (DateSensitiveValue*)
			[cashFlow.amountGrowthRate.growthRate getValueForCurrentOrDefaultScenario];
	
	NSString *growthRateDesc = [amountGrowthRate
		inlineDescription:[VariableValueRuntimeInfo
		createForSharedInflationRateWithDataModelController:self.dataModelController andInput:cashFlow]];
		
	return growthRateDesc;
}


-(NSString*)formattedCashFlowRepeatFreq:(CashFlowInput*)cashFlow
{
	EventRepeatFrequency *repeatFreq = 
		(EventRepeatFrequency*)[cashFlow.eventRepeatFrequency getValueForCurrentOrDefaultScenario];
	NSString *repeatDesc = [repeatFreq inlineDescription];
	NSString *untilDesc = @"";
	if([repeatFreq eventRepeatsMoreThanOnce])
	{
		SimDate *endDate = (SimDate*)[cashFlow.endDate.simDate
			getValueForCurrentOrDefaultScenario];
	    NSString *endDateDisplay = [endDate 
				inlineDescription:[DateHelper theHelper].mediumDateFormatter];;
				
		untilDesc = [NSString stringWithFormat:@" %@ %@",endDate.endDatePrefix,endDateDisplay];
	}
	
	NSString *repeatFreqDesc = [NSString stringWithFormat:@"%@%@",
	 repeatDesc,untilDesc];
	
	return repeatFreqDesc;
}

-(NSString*)incomeOrExpenseDesc:(CashFlowInput *)cashFlow
{
	NSString *amountDisplay = [self formattedCashFlowAmount:cashFlow];
	
	NSString *startDateDisplay = [self formattedMultiScenarioInputDate:cashFlow.startDate];

	NSString *repeatFreqDesc = [self formattedCashFlowRepeatFreq:cashFlow];
	
	NSString *inflationDesc = [self formattedCashFlowGrowthRate:cashFlow];
		
	return [NSString stringWithFormat:LOCALIZED_STR(@"INPUT_LIST_INCOME_EXPENSE_DESCRIPTION_FORMAT"),
						  amountDisplay,startDateDisplay,repeatFreqDesc,inflationDesc];
}

- (void) visitCashFlow:(CashFlowInput *)cashFlow
{

}

- (void)visitExpense:(ExpenseInput*)expense
{
	self.generatedDesc = [self incomeOrExpenseDesc:expense];
}

- (void)visitIncome:(IncomeInput*)input
{
	self.generatedDesc = [self incomeOrExpenseDesc:input];
}

- (void)visitTransfer:(TransferInput *)transfer
{
	NSString *amountDisplay = [self formattedCashFlowAmount:transfer];
	
	NSString *startDateDisplay = [self formattedMultiScenarioInputDate:transfer.startDate];

	NSString *repeatFreqDesc = [self formattedCashFlowRepeatFreq:transfer];
	
	NSString *inflationDesc = [self formattedCashFlowGrowthRate:transfer];
		
	self.generatedDesc=  [NSString stringWithFormat:LOCALIZED_STR(@"INPUT_LIST_TRANSFER_DESCRIPTION_FORMAT"),
						  amountDisplay,transfer.fromEndpoint.endpointLabel,transfer.toEndpoint.endpointLabel,
						  startDateDisplay,repeatFreqDesc,inflationDesc];
}

- (void)visitAccount:(Account *)account
{
	DateSensitiveValue *interestRate = (DateSensitiveValue*)
		[account.interestRate.growthRate getValueForCurrentOrDefaultScenario];

	NSString *interestRateDisplay = [interestRate inlineDescription:
		[VariableValueRuntimeInfo createForSharedInterestRateWithDataModelController:
			self.dataModelController andInput:account]];

	NSString *startingBalanceStr = [[NumberHelper theHelper] displayStrFromStoredVal:account.startingBalance andFormatter:[NumberHelper theHelper].currencyFormatter];
	self.generatedDesc= [NSString 
		stringWithFormat:LOCALIZED_STR(@"INPUT_ACCOUNT_INPUT_LIST_DETAIL_FORMAT"),startingBalanceStr,interestRateDisplay];
}


- (void)visitSavingsAccount:(SavingsAccount*)savingsAcct
{
		
}

- (void)visitLoan:(LoanInput *)loan
{
	DateSensitiveValue *interestRate = (DateSensitiveValue*)
		[loan.interestRate.growthRate getValueForCurrentOrDefaultScenario];
	NSString *interestRateDisplay = [interestRate inlineDescription:
		[VariableValueRuntimeInfo createForLoanInterestRateWithDataModelController:
			self.dataModelController andInput:loan]];

	NSString *originationDateDisplay = [self formattedMultiScenarioInputDate:loan.origDate];


	VariableValueRuntimeInfo *varValRuntimeInfo = [VariableValueRuntimeInfo 
		createForDataModelController:self.dataModelController 
		andMultiScenarioAmount:loan.loanCost 
		withValueTitle:LOCALIZED_STR(@"INPUT_LOAN_LOAN_COST_AMT_FIELD_LABEL") andValueName:loan.name];
	DateSensitiveValue *amount = (DateSensitiveValue*)
			[loan.loanCost.amount getValueForCurrentOrDefaultScenario];
	NSString *amountDisplay = [amount inlineDescription:varValRuntimeInfo];
	
	NSString *loanDescWithoutStartingBal = [NSString 
		stringWithFormat:LOCALIZED_STR(@"INPUT_LOAN_INPUT_LIST_FORMAT"),
			amountDisplay,originationDateDisplay,interestRateDisplay];
	self.generatedDesc = loanDescWithoutStartingBal;
		
	if([loan originationDateDefinedAndInThePastForScenario:self.sharedAppVals.currentInputScenario] &&
		(loan.startingBalance != nil))
	{
		NSString *startingBalDisplay = 	[[NumberHelper theHelper]
			displayStrFromStoredVal:loan.startingBalance
			andFormatter:[NumberHelper theHelper].currencyFormatter];

		NSString *loanDescWithStartingBal = [NSString 
			stringWithFormat:LOCALIZED_STR(@"INPUT_LOAN_INPUT_LIST_FORMAT_WITH_STARTING_BAL"),
			amountDisplay,originationDateDisplay,interestRateDisplay,startingBalDisplay];

		self.generatedDesc = loanDescWithStartingBal;

	}

}


- (void)visitAsset:(AssetInput*)asset
{
	VariableValueRuntimeInfo *varValRuntimeInfo = 
		[VariableValueRuntimeInfo createForDataModelController:self.dataModelController 
		andMultiScenarioAmount:asset.cost 
		withValueTitle:LOCALIZED_STR(@"INPUT_ASSET_COST_FIELD_LABEL") andValueName:asset.name];
	DateSensitiveValue *amount = (DateSensitiveValue*)
			[asset.cost.amount getValueForCurrentOrDefaultScenario];
	NSString *amountDisplay = [amount inlineDescription:varValRuntimeInfo];

	self.generatedDesc = [NSString 
		stringWithFormat:LOCALIZED_STR(@"INPUT_ASSET_INPUT_LIST_FORMAT"),
			amountDisplay];
}

- (void)visitTax:(TaxInput *)tax
{
	ItemizedTaxAmtsInfo *itemizedTaxSrcInfo = [ItemizedTaxAmtsInfo taxSourceInfo:tax
						usingDataModelController:self.dataModelController];

	NSString *itemizationSubtitle;
	if(itemizedTaxSrcInfo.fieldPopulator.itemizationCount > 0)
	{
		itemizationSubtitle = [itemizedTaxSrcInfo itemizationSummary];
	}
	else
	{
		itemizationSubtitle = LOCALIZED_STR(@"INPUT_LIST_TAX_SUBTITLE_NO_SOURCE");
	}
				
	self.generatedDesc = [NSString stringWithFormat:LOCALIZED_STR(@"INPUT_LIST_TAX_SUBTITLE_FORMAT"),
		[tax.taxBracket taxBracketSummary],itemizationSubtitle];
}

- (NSString*)descripionForInput:(Input*)theInput
{
	self.generatedDesc = nil;
	assert(theInput != nil);
	[theInput acceptInputVisitor:self];
	assert(self.generatedDesc != nil);
	assert([self.generatedDesc length] > 0);
	return self.generatedDesc;
}

- (void)dealloc
{
	[generatedDesc release];
	[dataModelController release];
	[sharedAppVals release];
	[super dealloc];
}

@end
