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
#import "DataModelController.h"
#import "SharedAppValues.h"

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

- (void) visitCashFlow:(CashFlowInput *)cashFlow
{
    SectionInfo *sectionInfo = [formPopulator nextSection];
    [sectionInfo addFieldEditInfo:[TextFieldEditInfo createForObject:cashFlow andKey:@"name" 
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_NAME_FIELD_LABEL")
		andPlaceholder:LOCALIZED_STR(@"INPUT_NAME_PLACEHOLDER")]];

 	Scenario *currentScenario = (Scenario*)[DataModelController theDataModelController].sharedAppVals.defaultScenario;

	
	      
    // Amount section
    
    sectionInfo = [formPopulator nextSection];
	
	
    sectionInfo.title = 
		LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_SECTION_TITLE");
	
    [sectionInfo addFieldEditInfo:
	 [DateSensitiveValueFieldEditInfo 
	  createForScenario:currentScenario andObject:cashFlow 
		andKey:CASH_FLOW_INPUT_MULTI_SCENARIO_AMOUNT_KEY 
	  andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_AMOUNT_FIELD_LABEL") 
	  andValRuntimeInfo:[VariableValueRuntimeInfo createForCashflowAmount:cashFlow]
	  andDefaultFixedValKey:@"defaultFixedAmount"]];

    [sectionInfo addFieldEditInfo:
        [DateSensitiveValueFieldEditInfo 
         createForScenario:currentScenario andObject:cashFlow 
			andKey:CASH_FLOW_INPUT_MULTI_SCENARIO_AMOUNT_GROWTH_RATE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_GROWTH_RATE_FIELD_LABEL") 
		 andValRuntimeInfo:[VariableValueRuntimeInfo createForInflationRate:cashFlow] 
		 andDefaultFixedValKey:@"defaultFixedGrowthRate"]];

    // Occurences section

    sectionInfo = [formPopulator nextSection];
    sectionInfo.title = LOCALIZED_STR(@"INPUT_CASHFLOW_OCCURRENCES_SECTION_TITLE");

	
    
	SimDateRuntimeInfo *startDateInfo = 
		[SimDateRuntimeInfo createForCashFlow:cashFlow andFieldTitleKey:@"INPUT_CASH_FLOW_START_DATE_TITLE" andSubHeaderFormatKey:@"INPUT_CASH_FLOW_START_DATE_SUBHEADER_FORMAT" andSubHeaderFormatKeyNoName:@"INPUT_CASH_FLOW_START_DATE_SUBHEADER_FORMAT_NO_NAME"];
    [sectionInfo addFieldEditInfo:[SimDateFieldEditInfo createForMultiScenarioVal:currentScenario 
			andObject:cashFlow andKey:CASH_FLOW_INPUT_MULTI_SCENARIO_START_DATE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_START_FIELD_LABEL") 
			andDefaultValueKey:@"fixedStartDate" 
			andVarDateRuntimeInfo:startDateInfo andShowNeverEnding:FALSE]];
	


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
			[SimDateRuntimeInfo createForCashFlow:cashFlow andFieldTitleKey:@"INPUT_CASH_FLOW_END_DATE_TITLE" andSubHeaderFormatKey:@"INPUT_CASH_FLOW_END_DATE_SUBHEADER_FORMAT" andSubHeaderFormatKeyNoName:@"INPUT_CASH_FLOW_END_DATE_SUBHEADER_FORMAT_NO_NAME"];

			[sectionInfo addFieldEditInfo:[SimDateFieldEditInfo createForMultiScenarioVal:currentScenario 
				andObject:cashFlow andKey:CASH_FLOW_INPUT_MULTI_SCENARIO_END_DATE_KEY 
				andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_END_FIELD_LABEL") 
				andDefaultValueKey:@"fixedEndDate" 
				andVarDateRuntimeInfo:endDateInfo andShowNeverEnding:FALSE]];
			
        }
        
    }
    
}

- (void)visitExpense:(ExpenseInput*)expense
{    
    formPopulator.formInfo.title = 
	       LOCALIZED_STR(@"INPUT_EXPENSE_VIEW_TITLE");
}

- (void)visitIncome:(IncomeInput*)input
{
    formPopulator.formInfo.title = 
		LOCALIZED_STR(@"INPUT_INCOME_VIEW_TITLE");
}


- (void)dealloc
{
    [formPopulator release];
    [super dealloc];
}


@end
