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
#import "NumberHelper.h"
#import "CashFlowAmountVariableValueListMgr.h"
#import "SavingsAccount.h"
#import "LoanInputVariableValueListMgr.h"


@implementation InputListInputDescriptionCreator 

@synthesize generatedDesc;

- (void) visitCashFlow:(CashFlowInput *)cashFlow
{
	CashFlowAmountVariableValueListMgr *variableAmountMgr = 
		[[[CashFlowAmountVariableValueListMgr alloc] initWithCashFlow:cashFlow] autorelease];
	VariableValueRuntimeInfo *varValRuntimeInfo = [VariableValueRuntimeInfo 
		createForVariableAmount:cashFlow 
		andVariableValListMgr:variableAmountMgr];

	DateSensitiveValue *amount = (DateSensitiveValue*)
			[cashFlow.multiScenarioAmount getValueForCurrentOrDefaultScenario];
	NSString *amountDisplay = [amount inlineDescription:varValRuntimeInfo];

	SimDate *startDate = (SimDate*)[cashFlow.multiScenarioStartDate getValueForCurrentOrDefaultScenario]; 
	NSString *startDateDisplay = [startDate 
						inlineDescription:[DateHelper theHelper].mediumDateFormatter];
	EventRepeatFrequency *repeatFreq = 
		(EventRepeatFrequency*)[cashFlow.multiScenarioEventRepeatFrequency getValueForCurrentOrDefaultScenario];
	NSString *repeatDesc = [repeatFreq inlineDescription];
	NSString *untilDesc = @"";
	if([repeatFreq eventRepeatsMoreThanOnce])
	{
		SimDate *endDate = (SimDate*)[cashFlow.multiScenarioEndDate getValueForCurrentOrDefaultScenario];
	    NSString *endDateDisplay = [endDate 
									inlineDescription:[DateHelper theHelper].mediumDateFormatter];;
		untilDesc = [NSString stringWithFormat:@" until %@",endDateDisplay];
	}
	
	DateSensitiveValue *amountGrowthRate = (DateSensitiveValue*)
			[cashFlow.multiScenarioAmountGrowthRate getValueForCurrentOrDefaultScenario];
	
	NSString *inflationDesc = [amountGrowthRate 
		inlineDescription:[VariableValueRuntimeInfo createForSharedInflationRate:cashFlow]];
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
   // no-op: implementation in sub-classes
}


- (void)visitSavingsAccount:(SavingsAccount*)savingsAcct
{
	DateSensitiveValue *interestRate = (DateSensitiveValue*)
		[savingsAcct.multiScenarioInterestRate getValueForCurrentOrDefaultScenario];

	NSString *interestRateDisplay = [interestRate inlineDescription:
		[VariableValueRuntimeInfo createForSharedInterestRate:savingsAcct]];

	NSString *startingBalanceStr = [[NumberHelper theHelper] displayStrFromStoredVal:savingsAcct.startingBalance andFormatter:[NumberHelper theHelper].currencyFormatter];
	self.generatedDesc= [NSString 
		stringWithFormat:LOCALIZED_STR(@"INPUT_SAVINGS_ACCOUNT_INPUT_LIST_DETAIL_FORMAT"),startingBalanceStr,interestRateDisplay];
		
}

- (void)visitLoan:(LoanInput *)loan
{
	DateSensitiveValue *interestRate = (DateSensitiveValue*)
		[loan.multiScenarioInterestRate getValueForCurrentOrDefaultScenario];
	NSString *interestRateDisplay = [interestRate inlineDescription:
		[VariableValueRuntimeInfo createForSharedInterestRate:loan]];


	LoanCostAmtVariableValueListMgr *variableAmountMgr = 
		[[[LoanCostAmtVariableValueListMgr alloc] initWithLoan:loan] autorelease];
	VariableValueRuntimeInfo *varValRuntimeInfo = [VariableValueRuntimeInfo 
		createForVariableAmount:loan 
		andVariableValListMgr:variableAmountMgr];
	DateSensitiveValue *amount = (DateSensitiveValue*)
			[loan.multiScenarioLoanCostAmt getValueForCurrentOrDefaultScenario];
	NSString *amountDisplay = [amount inlineDescription:varValRuntimeInfo];


	self.generatedDesc= [NSString 
		stringWithFormat:LOCALIZED_STR(@"INPUT_LOAN_INPUT_LIST_FORMAT"),
			amountDisplay,interestRateDisplay];

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
	[super dealloc];
	[generatedDesc release];
}

@end
