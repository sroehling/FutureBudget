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


@implementation InputListInputDescriptionCreator 

@synthesize generatedDesc;
@synthesize dataModelController;

-(id)initWithDataModelController:(DataModelController*)theDataModelController
{
	self = [super init];
	if(self)
	{
		assert(theDataModelController != nil);
		self.dataModelController = theDataModelController;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

- (void) visitCashFlow:(CashFlowInput *)cashFlow
{
	VariableValueRuntimeInfo *varValRuntimeInfo = [VariableValueRuntimeInfo 
		createForDataModelController:self.dataModelController
		andMultiScenarioAmount:cashFlow.amount 
		withValueTitle:LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_AMOUNT_FIELD_LABEL")
		andValueName:cashFlow.name];
	

	DateSensitiveValue *amount = (DateSensitiveValue*)
			[cashFlow.amount.amount getValueForCurrentOrDefaultScenario];
	NSString *amountDisplay = [amount inlineDescription:varValRuntimeInfo];

	SimDate *startDate = (SimDate*)[cashFlow.startDate.simDate
	 getValueForCurrentOrDefaultScenario]; 
	NSString *startDateDisplay = [startDate 
						inlineDescription:[DateHelper theHelper].mediumDateFormatter];

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
		untilDesc = [NSString stringWithFormat:@" until %@",endDateDisplay];
	}
	
	DateSensitiveValue *amountGrowthRate = (DateSensitiveValue*)
			[cashFlow.amountGrowthRate.growthRate getValueForCurrentOrDefaultScenario];
	
	NSString *inflationDesc = [amountGrowthRate 
		inlineDescription:[VariableValueRuntimeInfo createForSharedInflationRateWithDataModelController:self.dataModelController andInput:cashFlow]];
	self.generatedDesc = [NSString stringWithFormat:@"%@ starting on %@, repeating %@%@, %@",
						  amountDisplay,startDateDisplay,repeatDesc,untilDesc,inflationDesc];

}

- (void)visitExpense:(ExpenseInput*)expense
{ 
}

- (void)visitIncome:(IncomeInput*)input
{
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
		[VariableValueRuntimeInfo createForSharedInterestRateWithDataModelController:
			self.dataModelController andInput:loan]];

	

	VariableValueRuntimeInfo *varValRuntimeInfo = [VariableValueRuntimeInfo 
		createForDataModelController:self.dataModelController 
		andMultiScenarioAmount:loan.loanCost 
		withValueTitle:LOCALIZED_STR(@"INPUT_LOAN_LOAN_COST_AMT_FIELD_LABEL") andValueName:loan.name];
	DateSensitiveValue *amount = (DateSensitiveValue*)
			[loan.loanCost.amount getValueForCurrentOrDefaultScenario];
	NSString *amountDisplay = [amount inlineDescription:varValRuntimeInfo];


	self.generatedDesc= [NSString 
		stringWithFormat:LOCALIZED_STR(@"INPUT_LOAN_INPUT_LIST_FORMAT"),
			amountDisplay,interestRateDisplay];

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
	self.generatedDesc = tax.name;
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
	[super dealloc];
}

@end
