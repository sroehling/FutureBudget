//
//  DetailInputViewCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailInputViewCreator.h"
#import "ExpenseInput.h"
#import "IncomeInput.h"
#import "NumberHelper.h"
#import "ManagedObjectFieldInfo.h"
#import "TextFieldEditInfo.h"
#import "NumberFieldEditInfo.h"
#import "DateFieldEditInfo.h"
#import "SimDateFieldEditInfo.h"
#import "RepeatFrequencyFieldEditInfo.h"
#import "DateSensitiveValueFieldEditInfo.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "GenericFieldBasedTableAddViewController.h"
#import "EventRepeatFrequency.h"
#import "VariableValueRuntimeInfo.h"
#import "SectionInfo.h"
#import "FormInfo.h"
#import "FormPopulator.h"
#import "SharedEntityVariableValueListMgr.h"
#import "LocalizationHelper.h"
#import "SimDateRuntimeInfo.h"
#import "SharedAppValues.h"
#import "Account.h"
#import "DataModelController.h"
#import "SharedAppValues.h"
#import "SavingsAccount.h"
#import "BoolFieldEditInfo.h"

@implementation DetailInputViewCreator

@synthesize input;

-(id) initWithInput:(Input*)theInput
{
    self = [super init];
    if(self)
    {
        assert(theInput!=nil);
        self.input = theInput;
    }
    return self;
}

-(id) init
{
    assert(0); // should not be called
}


- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    [formPopulator release];
    formPopulator = [[FormPopulator alloc] init];
    
    [self.input acceptInputVisitor:self];
    
    return formPopulator.formInfo;

}

- (void)populateInputNameField:(Input*)theInput
{
   SectionInfo *sectionInfo = [formPopulator nextSection];
	
    [sectionInfo addFieldEditInfo:[TextFieldEditInfo createForObject:theInput andKey:INPUT_NAME_KEY 
		andLabel:LOCALIZED_STR(@"INPUT_NAME_FIELD_LABEL")
		andPlaceholder:LOCALIZED_STR(@"INPUT_NAME_PLACEHOLDER")]];

}

- (void) visitCashFlow:(CashFlowInput *)cashFlow
{

	[self populateInputNameField:cashFlow];
	
 	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].defaultScenario;

	
	      
    // Amount section
    
    SectionInfo *sectionInfo  = [formPopulator nextSection];
	
	
    sectionInfo.title = 
		LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_SECTION_TITLE");
	
    [sectionInfo addFieldEditInfo:
	 [DateSensitiveValueFieldEditInfo 
	  createForScenario:currentScenario andObject:cashFlow 
		andKey:CASH_FLOW_INPUT_MULTI_SCENARIO_AMOUNT_KEY 
	  andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_AMOUNT_FIELD_LABEL") 
	  andValRuntimeInfo:[VariableValueRuntimeInfo createForCashflowAmount:cashFlow]
	  andDefaultFixedVal:cashFlow.multiScenarioFixedAmount]];

    [sectionInfo addFieldEditInfo:
        [DateSensitiveValueFieldEditInfo 
         createForScenario:currentScenario andObject:cashFlow 
			andKey:CASH_FLOW_INPUT_MULTI_SCENARIO_AMOUNT_GROWTH_RATE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_GROWTH_RATE_FIELD_LABEL") 
		 andValRuntimeInfo:[VariableValueRuntimeInfo createForInflationRate:cashFlow] 
		 andDefaultFixedVal:cashFlow.multiScenarioFixedGrowthRate]];

    // Occurences section

    sectionInfo = [formPopulator nextSection];
    sectionInfo.title = LOCALIZED_STR(@"INPUT_CASHFLOW_OCCURRENCES_SECTION_TITLE");

	
    
	SimDateRuntimeInfo *startDateInfo = 
		[SimDateRuntimeInfo createForInput:cashFlow andFieldTitleKey:@"INPUT_CASH_FLOW_START_DATE_TITLE" andSubHeaderFormatKey:@"INPUT_CASH_FLOW_START_DATE_SUBHEADER_FORMAT" andSubHeaderFormatKeyNoName:@"INPUT_CASH_FLOW_START_DATE_SUBHEADER_FORMAT_NO_NAME"];
    [sectionInfo addFieldEditInfo:[SimDateFieldEditInfo createForMultiScenarioVal:currentScenario 
			andObject:cashFlow andKey:CASH_FLOW_INPUT_MULTI_SCENARIO_START_DATE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_START_FIELD_LABEL") 
			andDefaultValue:cashFlow.multiScenarioFixedStartDate 
			andVarDateRuntimeInfo:startDateInfo andShowEndDates:FALSE
			
			andDefaultRelEndDate:nil]];
	


    RepeatFrequencyFieldEditInfo *repeatFrequencyInfo = [RepeatFrequencyFieldEditInfo 
		createForScenario:currentScenario andObject:cashFlow 
		andKey:CASH_FLOW_INPUT_MULTI_SCENARIO_EVENT_REPEAT_FREQUENCY_KEY
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_REPEAT_FIELD_LABEL")];
    [sectionInfo addFieldEditInfo:repeatFrequencyInfo];
    
    // Only display (and prompt for) and end date when/if the repeat frequency is set to something other
    // than "Once", such that an end date is needed. TBD - Should the end date in this case default to 
    // "Plan end date".
     if([repeatFrequencyInfo.fieldInfo fieldIsInitializedInParentObject])
    {
        EventRepeatFrequency *repeatFreq = (EventRepeatFrequency*)[repeatFrequencyInfo.fieldInfo getFieldValue];
        assert(repeatFreq != nil);
        if([repeatFreq  eventRepeatsMoreThanOnce])
        {
			SimDateRuntimeInfo *endDateInfo = 
			[SimDateRuntimeInfo createForInput:cashFlow andFieldTitleKey:@"INPUT_CASH_FLOW_END_DATE_TITLE" andSubHeaderFormatKey:@"INPUT_CASH_FLOW_END_DATE_SUBHEADER_FORMAT" andSubHeaderFormatKeyNoName:@"INPUT_CASH_FLOW_END_DATE_SUBHEADER_FORMAT_NO_NAME"];

			[sectionInfo addFieldEditInfo:[SimDateFieldEditInfo createForMultiScenarioVal:currentScenario 
				andObject:cashFlow andKey:CASH_FLOW_INPUT_MULTI_SCENARIO_END_DATE_KEY 
				andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_END_FIELD_LABEL") 
				andDefaultValue:cashFlow.multiScenarioFixedEndDate 
				andVarDateRuntimeInfo:endDateInfo andShowEndDates:TRUE
				andDefaultRelEndDate:cashFlow.multiScenarioFixedRelEndDate]];
			
        }
        
    }
    
}

- (void)visitExpense:(ExpenseInput*)expense
{    
    formPopulator.formInfo.title = 
	       LOCALIZED_STR(@"INPUT_EXPENSE_VIEW_TITLE");
		   
	SectionInfo *sectionInfo = [formPopulator nextSection];
    sectionInfo.title = LOCALIZED_STR(@"INPUT_EXPENSE_TAXES_SECTION_TITLE");
	sectionInfo.subTitle = LOCALIZED_STR(@"INPUT_EXPENSE_TAXES_SECTION_SUBTITLE");
	[sectionInfo addFieldEditInfo:
        [BoolFieldEditInfo createForObject:expense 
			andKey:EXPENSE_INPUT_TAX_DEDUCTIBLE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_EXPENSE_TAXES_TAX_DEDUCTIBLE_LABEL")]];
	
	   
}

- (void)visitIncome:(IncomeInput*)input
{
    formPopulator.formInfo.title = 
		LOCALIZED_STR(@"INPUT_INCOME_VIEW_TITLE");
}

- (void) visitAccount:(Account*)account
{
    formPopulator.formInfo.title = 
		LOCALIZED_STR(@"INPUT_ACCOUNT_TITLE");
	[self populateInputNameField:account];

	
	SectionInfo *sectionInfo = [formPopulator nextSection];

	[sectionInfo addFieldEditInfo:[NumberFieldEditInfo createForObject:account 
             andKey:ACCOUNT_STARTING_BALANCE_KEY 
			 andLabel:LOCALIZED_STR(@"INPUT_SAVINGS_ACCOUNT_STARTING_BALANCE_LABEL")
			 andPlaceholder:LOCALIZED_STR(@"INPUT_ACCOUNT_STARTING_BALANCE_PLACEHOLDER")
			 andNumberFormatter:[NumberHelper theHelper].currencyFormatter]];

	sectionInfo = [formPopulator nextSection];
    sectionInfo.title = 
		LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_AMOUNT_SECTION_TITLE");
		
	

	
 	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].defaultScenario;
	
    [sectionInfo addFieldEditInfo:
	 [DateSensitiveValueFieldEditInfo 
	  createForScenario:currentScenario andObject:account 
		andKey:ACCOUNT_MULTI_SCEN_CONTRIB_AMOUNT_KEY 
	  andLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_AMOUNT_FIELD_LABEL") 
	  andValRuntimeInfo:[VariableValueRuntimeInfo createForAccountContribAmount:account]
	  andDefaultFixedVal:account.multiScenarioFixedContribAmount]];
	  
    [sectionInfo addFieldEditInfo:
        [DateSensitiveValueFieldEditInfo 
         createForScenario:currentScenario andObject:account 
			andKey:ACCOUNT_MULTI_SCEN_CONTRIB_GROWTH_RATE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_GROWTH_RATE_FIELD_LABEL") 
		 andValRuntimeInfo:[VariableValueRuntimeInfo createForAccountAmountGrowthRate:account] 
		 andDefaultFixedVal:account.multiScenarioFixedContribGrowthRate]];

	SimDateRuntimeInfo *startDateInfo = 
		[SimDateRuntimeInfo createForInput:account andFieldTitleKey:@"INPUT_CASH_FLOW_START_DATE_TITLE" andSubHeaderFormatKey:@"INPUT_CASH_FLOW_START_DATE_SUBHEADER_FORMAT" andSubHeaderFormatKeyNoName:@"INPUT_CASH_FLOW_START_DATE_SUBHEADER_FORMAT_NO_NAME"];
    [sectionInfo addFieldEditInfo:[SimDateFieldEditInfo createForMultiScenarioVal:currentScenario 
			andObject:account andKey:ACCOUNT_MULTI_SCEN_CONTRIB_START_DATE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_START_FIELD_LABEL") 
			andDefaultValue:account.multiScenarioFixedContribStartDate 
			andVarDateRuntimeInfo:startDateInfo andShowEndDates:FALSE
			andDefaultRelEndDate:nil]];
			
   RepeatFrequencyFieldEditInfo *repeatFrequencyInfo = [RepeatFrequencyFieldEditInfo 
		createForScenario:currentScenario andObject:account 
		andKey:ACCOUNT_MULTI_SCEN_CONTRIB_REPEAT_FREQUENCY_KEY
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_REPEAT_FIELD_LABEL")];
    [sectionInfo addFieldEditInfo:repeatFrequencyInfo];
    {
        EventRepeatFrequency *repeatFreq = (EventRepeatFrequency*)[repeatFrequencyInfo.fieldInfo getFieldValue];
        assert(repeatFreq != nil);
        if([repeatFreq  eventRepeatsMoreThanOnce])
        {
			SimDateRuntimeInfo *endDateInfo = 
			[SimDateRuntimeInfo createForInput:account andFieldTitleKey:@"INPUT_CASH_FLOW_END_DATE_TITLE" andSubHeaderFormatKey:@"INPUT_CASH_FLOW_END_DATE_SUBHEADER_FORMAT" andSubHeaderFormatKeyNoName:@"INPUT_CASH_FLOW_END_DATE_SUBHEADER_FORMAT_NO_NAME"];

			// TODO - Add fixed relative end date
			[sectionInfo addFieldEditInfo:[SimDateFieldEditInfo createForMultiScenarioVal:currentScenario 
				andObject:account andKey:ACCOUNT_MULTI_SCEN_CONTRIB_END_DATE_KEY 
				andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_END_FIELD_LABEL") 
				andDefaultValue:account.multiScenarioFixedContribEndDate 
				andVarDateRuntimeInfo:endDateInfo andShowEndDates:TRUE
				andDefaultRelEndDate:account.multiScenarioFixedContribRelEndDate]];
			
        }
        
    }

	

}

- (void) visitSavingsAccount:(SavingsAccount *)savingsAcct
{
		
	 Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].currentInputScenario;

	SectionInfo *sectionInfo = [formPopulator nextSection];
	
    [sectionInfo addFieldEditInfo:
	 [DateSensitiveValueFieldEditInfo 
	  createForScenario:currentScenario andObject:savingsAcct 
		andKey:SAVINGS_ACCOUNT_INTEREST_RATE_KEY 
	  andLabel:LOCALIZED_STR(@"INPUT_SAVINGS_ACCOUNT_INTEREST_RATE_FIELD_LABEL") 
	  andValRuntimeInfo:[VariableValueRuntimeInfo createForSavingsAccountInterestRate:savingsAcct]
	  andDefaultFixedVal:savingsAcct.multiScenarioFixedInterestRate]];

	
	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = 
		LOCALIZED_STR(@"INPUT_SAVINGS_ACCOUNT_TAXES_SECTION_TITLE");
	
	[sectionInfo addFieldEditInfo:
        [BoolFieldEditInfo createForObject:savingsAcct 
			andKey:SAVINGS_ACCOUNT_TAXABLE_CONTRIBUTIONS_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_SAVINGS_ACCOUNT_TAXABLE_CONTRIBUTION_LABEL")]];


	[sectionInfo addFieldEditInfo:
        [BoolFieldEditInfo createForObject:savingsAcct 
			andKey:SAVINGS_ACCOUNT_TAXABLE_WITHDRAWALS_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_SAVINGS_ACCOUNT_TAXABLE_WITHDRAWAL_LABEL")]];
	
	[sectionInfo addFieldEditInfo:
        [BoolFieldEditInfo createForObject:savingsAcct 
			andKey:SAVINGS_ACCOUNT_TAXABLE_INTEREST_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_SAVINGS_ACCOUNT_TAXABLE_INTEREST_LABEL")]];
				
			


}


- (void)dealloc
{
    [formPopulator release];
    [super dealloc];
}


@end
