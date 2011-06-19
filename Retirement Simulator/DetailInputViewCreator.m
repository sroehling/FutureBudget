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
#import "VariableDateFieldEditInfo.h"
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
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_NAME_FIELD_LABEL")]];
    
    // Amount section
    
    sectionInfo = [formPopulator nextSection];
	
	
    sectionInfo.title = 
		LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_SECTION_TITLE");
	
    [sectionInfo addFieldEditInfo:
	 [DateSensitiveValueFieldEditInfo 
	  createForObject:cashFlow andKey:@"amount" 
	  andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_AMOUNT_FIELD_LABEL") 
	  andValRuntimeInfo:[VariableValueRuntimeInfo createForCashflowAmount:cashFlow]
	  andDefaultFixedValKey:@"defaultFixedAmount"]];

    [sectionInfo addFieldEditInfo:
        [DateSensitiveValueFieldEditInfo 
         createForObject:cashFlow andKey:@"amountGrowthRate" andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_GROWTH_RATE_FIELD_LABEL") 
		 andValRuntimeInfo:[VariableValueRuntimeInfo createForInflationRate:cashFlow] 
		 andDefaultFixedValKey:@"defaultFixedGrowthRate"]];

    // Occurences section

    sectionInfo = [formPopulator nextSection];
    sectionInfo.title = LOCALIZED_STR(@"INPUT_CASHFLOW_OCCURRENCES_SECTION_TITLE");
    
    [sectionInfo addFieldEditInfo:[VariableDateFieldEditInfo createForObject:cashFlow andKey:@"startDate" 
	andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_START_FIELD_LABEL") 
	andDefaultValueKey:@"fixedStartDate"]];


    RepeatFrequencyFieldEditInfo *repeatFrequencyInfo = [RepeatFrequencyFieldEditInfo createForObject:cashFlow andKey:@"repeatFrequency" 
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
            [sectionInfo addFieldEditInfo:[VariableDateFieldEditInfo createForObject:cashFlow andKey:@"endDate" 
			     andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_END_FIELD_LABEL") 
				 andDefaultValueKey:@"fixedEndDate"]];           
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
