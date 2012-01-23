//
//  StartingValsFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StartingValsFormInfoCreator.h"
#import "FormPopulator.h"
#import "SharedAppValues.h"
#import "Input.h"
#import "Account.h"
#import "FixedValue.h"
#import "DataModelController.h"
#import "LocalizationHelper.h"
#import "NumberFieldEditInfo.h"
#import "NumberHelper.h"
#import "SectionInfo.h"
#import "LocalizationHelper.h"
#import "DateFieldEditInfo.h"
#import "SimDateRuntimeInfo.h"
#import "SimDateFieldEditInfo.h"
#import "Cash.h"
#import "PercentFieldValidator.h"
#import "PositiveAmountValidator.h"
#import "BoolFieldEditInfo.h"
#import "ManagedObjectFieldInfo.h"
#import "VariableValueFieldEditInfo.h"
#import "InputFormPopulator.h"
#import "InflationRate.h"

@implementation StartingValsFormInfoCreator

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] initForNewObject:FALSE
		andParentController:parentController] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"STARTUP_VALUES_VIEW_TITLE");
	
	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"STARTUP_VALUES_START_DATE_SECTION_TITLE");
	sectionInfo.subTitle = LOCALIZED_STR(@"STARTUP_VALUES_START_DATE_SECTION_SUBTITLE");
	
	DateFieldEditInfo *simStartDateInfo = 
		[DateFieldEditInfo createForObject:[SharedAppValues singleton] 
            andKey:SHARED_APP_VALUES_SIM_START_DATE_KEY 
			andLabel:LOCALIZED_STR(@"STARTUP_VALS_START_DATE_LABEL")
			andPlaceholder:LOCALIZED_STR(@"STARTUP_VALS_START_DATE_PLACEHOLDER")];	
	[sectionInfo addFieldEditInfo:simStartDateInfo];
	
	
	// TODO - Add support to edit end date.
	SimDateRuntimeInfo *endDateInfo = 
			[[[SimDateRuntimeInfo alloc] 
				initWithTableTitle:LOCALIZED_STR(@"SIM_END_DATE_TABLE_TITLE")
				andHeader:LOCALIZED_STR(@"SIM_END_DATE_TABLE_HEADER")
				andSubHeader:LOCALIZED_STR(@"SIM_END_DATE_TABLE_SUBTITLE") 
				andSupportsNeverEndDate:FALSE] autorelease];
			
			
	SimDateFieldEditInfo *endDateFieldEditInfo = [SimDateFieldEditInfo createForObject:[SharedAppValues singleton] andKey:SHARED_APP_VALUES_SIM_END_DATE_KEY andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_END_FIELD_LABEL") 
		andDefaultFixedDate:[SharedAppValues singleton].defaultFixedSimEndDate andVarDateRuntimeInfo:endDateInfo
		andShowEndDates:TRUE andDefaultRelEndDateKey:SHARED_APP_VALUES_DEFAULT_RELATIVE_SIM_END_DATE_KEY];

	[sectionInfo addFieldEditInfo:endDateFieldEditInfo];

	
	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"STARTUP_VALUES_STARTING_BALANCES_SECTION_TITLE");
	sectionInfo.subTitle = LOCALIZED_STR(@"STARTUP_VALUES_STARTING_BALANCES_SECTION_SUBTITLE");
	
	NSArray *accounts = [[DataModelController theDataModelController]
			fetchSortedObjectsWithEntityName:ACCOUNT_ENTITY_NAME 
			sortKey:INPUT_NAME_KEY];
	for (Account *account in accounts)
	{
		NumberFieldEditInfo *acctBalanceFieldEditInfo = 
			[NumberFieldEditInfo createForObject:account andKey:ACCOUNT_STARTING_BALANCE_KEY andLabel:account.name andPlaceholder:LOCALIZED_STR(@"INPUT_ACCOUNT_STARTING_BALANCE_PLACEHOLDER") andNumberFormatter:[NumberHelper theHelper].currencyFormatter andValidator:[[[PositiveAmountValidator alloc] init] autorelease]];
		[sectionInfo addFieldEditInfo:acctBalanceFieldEditInfo];
	}
	
	// TODO - Switch over to use populateCurrencyField from InputFormPopulator
	Cash *theCash = [SharedAppValues singleton].cash;
	
	NumberFieldValidator *amountValidator = [[[PositiveAmountValidator alloc] init] autorelease];
	NumberFieldEditInfo *cashBalanceFieldEditInfo = 
			[NumberFieldEditInfo createForObject:theCash andKey:CASH_STARTING_BALANCE_KEY 
			andLabel:LOCALIZED_STR(@"CASH_LABEL") 
			andPlaceholder:LOCALIZED_STR(@"INPUT_ACCOUNT_STARTING_BALANCE_PLACEHOLDER") 
			andNumberFormatter:[NumberHelper theHelper].currencyFormatter
			andValidator:amountValidator];
	[sectionInfo addFieldEditInfo:cashBalanceFieldEditInfo];

	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"STARTUP_VALUES_DEFICITS_SECTION_TITLE");
	sectionInfo.subTitle = LOCALIZED_STR(@"STARTUP_VALUES_DEFICITS_SECTION_SUBTITLE");

	// TODO - Switch to use populatePercentField from InputFormPopulator
	NumberFieldValidator *percentValidator = [[[PercentFieldValidator alloc] init] autorelease];
	NumberFieldEditInfo *deficitInterestFieldEditInfo = 
			[NumberFieldEditInfo createForObject:[SharedAppValues singleton].deficitInterestRate 
				andKey:FIXED_VALUE_VALUE_KEY 
			andLabel:LOCALIZED_STR(@"STARTUP_VALUE_DEFICIT_LABEL") 
			andPlaceholder:LOCALIZED_STR(@"STARTUP_VALUE_DEFICIT_PLACEHOLDER") 
			andNumberFormatter:[NumberHelper theHelper].percentFormatter andValidator:percentValidator];
	[sectionInfo addFieldEditInfo:deficitInterestFieldEditInfo];
	
	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"STARTUP_VALUES_INFLATION_ADJUSTMENT_SECTION_TITLE");
	sectionInfo.subTitle = LOCALIZED_STR(@"STARTUP_VALUES_INFLATION_ADJUSTMENT_SECTION_SUBTITLE");
	
	ManagedObjectFieldInfo *adjustForInflationFieldInfo = [[[ManagedObjectFieldInfo alloc] 
			initWithManagedObject:[SharedAppValues singleton] 
			andFieldKey:SHARED_APP_VALUES_ADJUST_RESULTS_FOR_INFLATION_KEY 
			andFieldLabel:LOCALIZED_STR(@"STARTUP_VALUE_ADJUST_FOR_INFLATION_FIELD_LABEL") 
			andFieldPlaceholder:@"N/A"] autorelease];
	BoolFieldEditInfo *adjustForInflationFieldEditInfo = 
		[[[BoolFieldEditInfo alloc] initWithFieldInfo:adjustForInflationFieldInfo
			andSubtitle:LOCALIZED_STR(@"STARTUP_VALUE_ADJUST_FOR_INFLATION_SUBTITLE")] autorelease];
	[sectionInfo addFieldEditInfo:adjustForInflationFieldEditInfo];


	[formPopulator populateSingleScenarioVariableValue:[SharedAppValues singleton].defaultInflationRate 
		withLabel:LOCALIZED_STR(@"DEFAULT_INFLATION_RATE_GROWTH_RATE_FIELD_LABEL") 
		andValueName:LOCALIZED_STR(@"DEFAULT_INFLATION_RATE_LABEL")];
	

	return formPopulator.formInfo;
	
}

@end
