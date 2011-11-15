//
//  InputFormHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputFormPopulator.h"
#import "NumberFieldEditInfo.h"
#import "MultiScenarioFixedValueFieldInfo.h"
#import "NumberHelper.h"
#import "MultiScenarioInputValue.h"
#import "LocalizationHelper.h"
#import "SectionInfo.h"
#import "SharedAppValues.h"

#import "ManagedObjectFieldInfo.h"
#import "NameFieldEditInfo.h"
#import "Input.h"

#import "Scenario.h"
#import "DefaultScenario.h"

#import "MultiScenarioBoolInputValueFieldInfo.h"
#import "BoolFieldEditInfo.h"

#import "MultiScenarioAmount.h"
#import "MultiScenarioAmountVariableValueListMgr.h"
#import "VariableValueRuntimeInfo.h"
#import "DateSensitiveValueFieldEditInfo.h"

#import "SharedEntityVariableValueListMgr.h"
#import "MultiScenarioGrowthRate.h"
#import "InflationRate.h"

#import "RepeatFrequencyFieldEditInfo.h"
#import "StringValidation.h"

#import "DurationFieldEditInfo.h"

#import "SimDateFieldEditInfo.h"
#import "SimDateRuntimeInfo.h"

#import "MultiScenarioSimDate.h"
#import "MultiScenarioSimEndDate.h"

@implementation InputFormPopulator

@synthesize inputScenario;

-(id)initWithScenario:(Scenario*)theInputScenario
{
	self = [super init];
	if(self)
	{
		assert(theInputScenario != nil);
		self.inputScenario = theInputScenario;
	}
	return self;
}

-(id)initForNewObject:(BOOL)isNewObject
{
	Scenario *theInputScenario;
	if(isNewObject)
	{
		theInputScenario = [SharedAppValues singleton].defaultScenario;
	}
	else
	{
		theInputScenario = [SharedAppValues singleton].currentInputScenario;
	}
	return [self initWithScenario:theInputScenario];
}

- (void)populateInputNameField:(Input*)theInput
{
   [self nextSection];
   assert(theInput!=nil);
	
	ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc] initWithManagedObject:theInput andFieldKey:INPUT_NAME_KEY andFieldLabel:LOCALIZED_STR(@"INPUT_NAME_FIELD_LABEL")
	 andFieldPlaceholder:LOCALIZED_STR(@"INPUT_NAME_PLACEHOLDER")] autorelease];
	 NameFieldEditInfo *fieldEditInfo = [[[NameFieldEditInfo alloc] initWithFieldInfo:fieldInfo] autorelease];
	
    [self.currentSection addFieldEditInfo:fieldEditInfo];

}


-(void)populateMultiScenBoolField:(MultiScenarioInputValue*)boolVal withLabel:(NSString*)label
{
	assert(boolVal != nil);
	assert([StringValidation nonEmptyString:label]);
	
	MultiScenarioBoolInputValueFieldInfo *boolFieldInfo =
		[[[MultiScenarioBoolInputValueFieldInfo alloc] 
			initWithFieldLabel:label 
			andFieldPlaceholder:@"n/a" andScenario:self.inputScenario 
		andInputVal:boolVal] autorelease];
	BoolFieldEditInfo *boolFieldEditInfo = 
		[[[BoolFieldEditInfo alloc] initWithFieldInfo:boolFieldInfo] autorelease];
		
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:boolFieldEditInfo];

}


-(void)populateMultiScenFixedValField:(MultiScenarioInputValue*)inputVal
	andValLabel:(NSString*)label andPrompt:(NSString*)prompt 
		andObjectForDelete:(NSManagedObject*)objForDelete
{
	assert(inputVal != nil);
	assert([StringValidation nonEmptyString:label]);
	assert([StringValidation nonEmptyString:prompt]);
	
	MultiScenarioFixedValueFieldInfo *fieldInfo =
		[[[MultiScenarioFixedValueFieldInfo alloc] 
			initWithFieldLabel:label 
			andFieldPlaceholder:prompt
			andScenario:self.inputScenario  andInputVal:inputVal] autorelease];
   NumberFieldEditInfo *fieldEditInfo = 
		[[[NumberFieldEditInfo alloc] initWithFieldInfo:fieldInfo
			andNumberFormatter:[NumberHelper theHelper].decimalFormatter] autorelease];
	fieldEditInfo.objectForDelete = objForDelete;
	assert(self.currentSection != nil);
	
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:fieldEditInfo];

}

-(void)populateMultiScenFixedValField:(MultiScenarioInputValue*)inputVal
	andValLabel:(NSString*)label andPrompt:(NSString*)prompt
{
	[self populateMultiScenFixedValField:inputVal andValLabel:label
	 andPrompt:prompt andObjectForDelete:nil];
}





-(void)populateCurrencyField:(NSManagedObject*)parentObj andValKey:(NSString*)valKey
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder
{
	assert(parentObj != nil);
	assert([StringValidation nonEmptyString:valKey]);
	assert([StringValidation nonEmptyString:label]);
	assert([StringValidation nonEmptyString:placeholder]);
	
	NumberFieldEditInfo *currencyFieldEditInfo = 
			[NumberFieldEditInfo createForObject:parentObj andKey:valKey 
			andLabel:label
			andPlaceholder:placeholder
			andNumberFormatter:[NumberHelper theHelper].currencyFormatter];
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:currencyFieldEditInfo];
	
}

-(void)populatePercentField:(NSManagedObject*)parentObj andValKey:(NSString*)valKey
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder
{
	assert(parentObj != nil);
	assert([StringValidation nonEmptyString:valKey]);
	assert([StringValidation nonEmptyString:label]);
	assert([StringValidation nonEmptyString:placeholder]);
	
	NumberFieldEditInfo *percentFieldEditInfo = 
			[NumberFieldEditInfo createForObject:parentObj 
				andKey:valKey andLabel:label andPlaceholder:placeholder
			andNumberFormatter:[NumberHelper theHelper].percentFormatter];

	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:percentFieldEditInfo];
}

-(void)populateMultiScenarioAmount:(MultiScenarioAmount*)theAmount 
	withValueTitle:(NSString*)valueTitle
{
	assert(theAmount != nil);
	
	
	VariableValueRuntimeInfo *amountRuntimeInfo = [VariableValueRuntimeInfo 
		createForMultiScenarioAmount:theAmount withValueTitle:valueTitle];
		
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:
	 [DateSensitiveValueFieldEditInfo 
	  createForScenario:self.inputScenario andObject:theAmount 
		andKey:MULTI_SCEN_AMOUNT_AMOUNT_KEY 
	  andLabel:valueTitle
	  andValRuntimeInfo:amountRuntimeInfo
	  andDefaultFixedVal:theAmount.defaultFixedAmount]];
}


-(void)populateMultiScenarioGrowthRate:(MultiScenarioGrowthRate*)growthRate
	withLabel:(NSString*)valueLabel
{

	assert([StringValidation nonEmptyString:valueLabel]);
	assert(growthRate != nil);
	
	SharedEntityVariableValueListMgr *sharedInflationRatesMgr = 
	[[[SharedEntityVariableValueListMgr alloc] initWithEntity:INFLATION_RATE_ENTITY_NAME] autorelease];
	
	NSString *tableSubtitle = [NSString 
			stringWithFormat:LOCALIZED_STR(@"INPUT_INFLATION_RATE__TABLE_SUBTITLE_FORMAT"),
			LOCALIZED_STR(@"INPUT_INFLATION_RATE_INLINE_VALUE_TITLE"),
			LOCALIZED_STR(@"INPUT_INFLATION_RATE_INLINE_VALUE_TITLE")];
	
	VariableValueRuntimeInfo *grRuntimeInfo = [[[VariableValueRuntimeInfo alloc] 
		initWithFormatter:[NumberHelper theHelper].percentFormatter 
		andValueTitle:@"INPUT_INFLATION_RATE_VALUE_TITLE"
		andInlineValueTitleKey:@"INPUT_INFLATION_RATE_INLINE_VALUE_TITLE"
		andValueVerb:LOCALIZED_STR(@"INPUT_INFLATION_RATE_ACTION_VERB")
		andPeriodDesc:LOCALIZED_STR(@"INPUT_INFLATION_RATE_PERIOD") 
		andListMgr:sharedInflationRatesMgr
		andSingleValueSubtitleKey:@"INPUT_INFLATION_RATE_SINGLE_VALUE_SECTION_SUBTITLE"
		andVariableValueSubtitleKey:@"SHARED_INTEREST_RATE_DATE_SENSITIVE_VALUE_VARIABLE_SUBTITLE"
		andValuePromptKey:@"INPUT_INFLATION_RATE_VALUE_PROMPT"
		andValueTypeInline:@"inline type TBD"
		andValueTypeTitle:valueLabel
		andValueName:@"Name TBD"
		andTableSubtitle:tableSubtitle] autorelease];


	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:
        [DateSensitiveValueFieldEditInfo 
         createForScenario:self.inputScenario andObject:growthRate 
			andKey:MULTI_SCEN_GROWTH_RATE_GROWTH_RATE_KEY 
			andLabel:valueLabel 
		 andValRuntimeInfo:grRuntimeInfo 
		 andDefaultFixedVal:growthRate.defaultFixedGrowthRate]];
 
}

-(RepeatFrequencyFieldEditInfo*)populateRepeatFrequency:(NSManagedObject*)parentObj andFreqKey:(NSString*)freqKey
	andLabel:(NSString*)label
{
	assert(parentObj != nil);
	assert([StringValidation nonEmptyString:freqKey]);
	assert([StringValidation nonEmptyString:label]);
	
    RepeatFrequencyFieldEditInfo *repeatFrequencyInfo = [RepeatFrequencyFieldEditInfo 
		createForScenario:self.inputScenario andObject:parentObj 
		andKey:freqKey andLabel:label];
		
	assert(self.currentSection != nil);
    [self.currentSection addFieldEditInfo:repeatFrequencyInfo];

	return repeatFrequencyInfo;
}


-(void)populateMultiScenarioDuration:(MultiScenarioInputValue*)duration 
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder
{
	assert([StringValidation nonEmptyString:label]);
	assert([StringValidation nonEmptyString:placeholder]);
	assert(duration != nil);

	MultiScenarioFixedValueFieldInfo *durationFieldInfo =
		[[[MultiScenarioFixedValueFieldInfo alloc] 
			initWithFieldLabel:label
			andFieldPlaceholder:placeholder
			andScenario:self.inputScenario 
		andInputVal:duration] autorelease];
	DurationFieldEditInfo *durationFieldEditInfo = 
		[[[DurationFieldEditInfo alloc] initWithFieldInfo:durationFieldInfo] autorelease];

	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:durationFieldEditInfo];
}

-(void)populateMultiScenSimDate:(MultiScenarioSimDate*)multiScenSimDate 
	andLabel:(NSString*)label andTitle:(NSString*)title
{
	assert(multiScenSimDate != nil);
	assert([StringValidation nonEmptyString:label]);
	assert([StringValidation nonEmptyString:title]);
	
	NSString *tableHeader= @"Table Header TBD";
	NSString *tableSubHeader = @"Table sub header TBD";
	BOOL supportEndDates = FALSE;

 	SimDateRuntimeInfo *simDateInfo = 
		[[[SimDateRuntimeInfo alloc] initWithTableTitle:title 
			andHeader:tableHeader andSubHeader:tableSubHeader 
			andSupportsNeverEndDate:supportEndDates] autorelease];
			
	SimDateFieldEditInfo *simDateFieldEditInfo = 
		[SimDateFieldEditInfo createForMultiScenarioVal:self.inputScenario 
			andObject:multiScenSimDate andKey:MULTI_SCEN_SIM_DATE_SIM_DATE_KEY 
			andLabel:label 
			andDefaultValue:multiScenSimDate.defaultFixedSimDate 
			andVarDateRuntimeInfo:simDateInfo andShowEndDates:supportEndDates
			andDefaultRelEndDate:nil];
		
    [self.currentSection addFieldEditInfo:simDateFieldEditInfo];

}

-(void)populateMultiScenSimEndDate:(MultiScenarioSimEndDate*)multiScenSimEndDate 
	andLabel:(NSString*)label andTitle:(NSString*)title
{
	assert(multiScenSimEndDate != nil);
	assert([StringValidation nonEmptyString:label]);
	assert([StringValidation nonEmptyString:title]);
	
	NSString *tableHeader= @"Table Header TBD";
	NSString *tableSubHeader = @"Table sub header TBD";
	BOOL doSupportNeverEndDates = TRUE;

 	SimDateRuntimeInfo *simDateInfo = 
		[[[SimDateRuntimeInfo alloc] initWithTableTitle:title 
			andHeader:tableHeader andSubHeader:tableSubHeader 
			andSupportsNeverEndDate:doSupportNeverEndDates] autorelease];
			
	SimDateFieldEditInfo *simDateFieldEditInfo = 
		[SimDateFieldEditInfo createForMultiScenarioVal:self.inputScenario 
			andObject:multiScenSimEndDate andKey:MULTI_SCEN_SIM_END_DATE_SIM_DATE_KEY 
			andLabel:label 
			andDefaultValue:multiScenSimEndDate.defaultFixedSimDate 
			andVarDateRuntimeInfo:simDateInfo andShowEndDates:doSupportNeverEndDates
			andDefaultRelEndDate:multiScenSimEndDate.defaultFixedRelativeEndDate];

    [self.currentSection addFieldEditInfo:simDateFieldEditInfo];

}


-(void)dealloc
{
	[super dealloc];
	[inputScenario release];
}	

@end
