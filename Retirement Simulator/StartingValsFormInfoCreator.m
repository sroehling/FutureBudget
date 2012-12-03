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
#import "AssetInput.h"
#import "LoanInput.h"
#import "FormContext.h"

@implementation StartingValsFormInfoCreator

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] initForNewObject:FALSE
		andFormContext:parentContext] autorelease];
		
	SharedAppValues *sharedAppVals = [SharedAppValues getUsingDataModelController:parentContext.dataModelController];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"STARTUP_VALUES_VIEW_TITLE");
	
	SectionInfo *sectionInfo = [formPopulator 
		nextSectionWithTitle:LOCALIZED_STR(@"STARTUP_VALUES_START_DATE_SECTION_TITLE")
		andHelpFile:@"simTimeFrame"];
	
	DateFieldEditInfo *simStartDateInfo = 
		[DateFieldEditInfo createForObject:sharedAppVals 
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
			
			
	SimDateFieldEditInfo *endDateFieldEditInfo = [SimDateFieldEditInfo 
		createForDataModelController:parentContext.dataModelController 
		andObject:[SharedAppValues getUsingDataModelController:parentContext.dataModelController] 
			andKey:SHARED_APP_VALUES_SIM_END_DATE_KEY andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_END_FIELD_LABEL") 
		andDefaultFixedDate:sharedAppVals.defaultFixedSimEndDate andVarDateRuntimeInfo:endDateInfo
		andShowEndDates:TRUE andDefaultRelEndDateKey:SHARED_APP_VALUES_DEFAULT_RELATIVE_SIM_END_DATE_KEY];

	[sectionInfo addFieldEditInfo:endDateFieldEditInfo];

	
	sectionInfo = [formPopulator nextSectionWithTitle:LOCALIZED_STR(@"STARTUP_VALUES_STARTING_BALANCES_SECTION_TITLE")
		andHelpFile:@"currentBalances"];
	
	
	NSArray *accounts = [parentContext.dataModelController 
			fetchSortedObjectsWithEntityName:ACCOUNT_ENTITY_NAME 
			sortKey:INPUT_NAME_KEY];
	if([accounts count] > 0)
	{
		for (Account *account in accounts)
		{
			NumberFieldEditInfo *acctBalanceFieldEditInfo = 
				[NumberFieldEditInfo createForObject:account andKey:ACCOUNT_STARTING_BALANCE_KEY andLabel:account.name andPlaceholder:LOCALIZED_STR(@"INPUT_ACCOUNT_STARTING_BALANCE_PLACEHOLDER") andNumberFormatter:[NumberHelper theHelper].currencyFormatter andValidator:[[[PositiveAmountValidator alloc] init] autorelease]];
			[sectionInfo addFieldEditInfo:acctBalanceFieldEditInfo];
		}
	}
	
	NSArray *assets = [parentContext.dataModelController 
			fetchSortedObjectsWithEntityName:ASSET_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([assets count] > 0)
	{
		[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"STARTUP_VALUES_CURRENT_ASSET_VALUES")
			andHelpFile:@"currentAssetValues"];
		for(AssetInput *asset in assets)
		{
			[formPopulator populateCurrencyField:asset andValKey:INPUT_ASSET_STARTING_VALUE_KEY 
				andLabel:asset.name
				andPlaceholder:LOCALIZED_STR(@"INPUT_ASSET_STARTING_VALUE_PLACEHOLDER")];
		}

	}
	
	NSArray *loans = [parentContext.dataModelController  
			fetchSortedObjectsWithEntityName:LOAN_INPUT_ENTITY_NAME
			sortKey:INPUT_NAME_KEY];
	if([loans count]  > 0)
	{
		[formPopulator nextSectionWithTitle:
			LOCALIZED_STR(@"STARTUP_VALUES_OUTSTANDING_LOAN_BALANCES_SECTION_TITLE")
				andHelpFile:@"outstandingLoanBalances"];

		for(LoanInput *loan in loans)
		{
			[formPopulator populateCurrencyField:loan andValKey:INPUT_LOAN_STARTING_BALANCE_KEY 
				andLabel:loan.name
				andPlaceholder:LOCALIZED_STR(@"INPUT_LOAN_STARTING_BALANCE_PLACEHOLDER")];
		}
	}
	
	// TODO - Switch over to use populateCurrencyField from InputFormPopulator
	Cash *theCash = sharedAppVals.cash;
	
	NumberFieldValidator *amountValidator = [[[PositiveAmountValidator alloc] init] autorelease];
	NumberFieldEditInfo *cashBalanceFieldEditInfo = 
			[NumberFieldEditInfo createForObject:theCash andKey:CASH_STARTING_BALANCE_KEY 
			andLabel:LOCALIZED_STR(@"CASH_LABEL") 
			andPlaceholder:LOCALIZED_STR(@"INPUT_ACCOUNT_STARTING_BALANCE_PLACEHOLDER") 
			andNumberFormatter:[NumberHelper theHelper].currencyFormatter
			andValidator:amountValidator];
	[sectionInfo addFieldEditInfo:cashBalanceFieldEditInfo];

	sectionInfo = [formPopulator 
		nextSectionWithTitle:LOCALIZED_STR(@"STARTUP_VALUES_DEFICITS_SECTION_TITLE")
		andHelpFile:@"deficit"];

	// TODO - Switch to use populatePercentField from InputFormPopulator
	NumberFieldValidator *percentValidator = [[[PercentFieldValidator alloc] init] autorelease];
	NumberFieldEditInfo *deficitInterestFieldEditInfo = 
			[NumberFieldEditInfo createForObject:sharedAppVals.deficitInterestRate 
				andKey:FIXED_VALUE_VALUE_KEY 
			andLabel:LOCALIZED_STR(@"STARTUP_VALUE_DEFICIT_LABEL") 
			andPlaceholder:LOCALIZED_STR(@"STARTUP_VALUE_DEFICIT_PLACEHOLDER") 
			andNumberFormatter:[NumberHelper theHelper].percentFormatter andValidator:percentValidator];
	[sectionInfo addFieldEditInfo:deficitInterestFieldEditInfo];
	
	NumberFieldValidator *deficitBalValidator = [[[PositiveAmountValidator alloc] init] autorelease];
	NumberFieldEditInfo *deficitBalanceFieldEditInfo = 
			[NumberFieldEditInfo createForObject:sharedAppVals andKey:SHARED_APP_VALUES_STARTING_DEFICIT_BALANCE_KEY 
			andLabel:LOCALIZED_STR(@"STARTUP_VALUE_DEFICIT_BALANCE_LABEL") 
			andPlaceholder:LOCALIZED_STR(@"STARTUP_VALUE_DEFICIT_BALANCE_PLACEHOLDER") 
			andNumberFormatter:[NumberHelper theHelper].currencyFormatter
			andValidator:deficitBalValidator];
	[sectionInfo addFieldEditInfo:deficitBalanceFieldEditInfo];

	
	sectionInfo = [formPopulator 
		nextSectionWithTitle:LOCALIZED_STR(@"STARTUP_VALUES_INFLATION_ADJUSTMENT_SECTION_TITLE") 
		andHelpFile:@"inflationAdjustment"];
	
	ManagedObjectFieldInfo *adjustForInflationFieldInfo = [[[ManagedObjectFieldInfo alloc] 
			initWithManagedObject:sharedAppVals 
			andFieldKey:SHARED_APP_VALUES_ADJUST_RESULTS_FOR_INFLATION_KEY 
			andFieldLabel:LOCALIZED_STR(@"STARTUP_VALUE_ADJUST_FOR_INFLATION_FIELD_LABEL") 
			andFieldPlaceholder:@"N/A"] autorelease];
	BoolFieldEditInfo *adjustForInflationFieldEditInfo = 
		[[[BoolFieldEditInfo alloc] initWithFieldInfo:adjustForInflationFieldInfo
			andSubtitle:LOCALIZED_STR(@"STARTUP_VALUE_ADJUST_FOR_INFLATION_SUBTITLE")] autorelease];
	[sectionInfo addFieldEditInfo:adjustForInflationFieldEditInfo];


	[formPopulator populateSingleScenarioVariableValue:sharedAppVals.defaultInflationRate 
		withLabel:LOCALIZED_STR(@"DEFAULT_INFLATION_RATE_GROWTH_RATE_FIELD_LABEL") 
		andValueName:LOCALIZED_STR(@"DEFAULT_INFLATION_RATE_LABEL")];
	

	return formPopulator.formInfo;
	
}

@end
