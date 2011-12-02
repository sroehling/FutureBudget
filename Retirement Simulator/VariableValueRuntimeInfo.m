//
//  VariableValueRuntimeInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableValueRuntimeInfo.h"
#import "SharedEntityVariableValueListMgr.h"
#import "LocalizationHelper.h"
#import "NumberHelper.h"
#import "CashFlowInput.h"
#import "InflationRate.h"
#import "LoanInput.h"
#import "InterestRate.h"
#import "VariableValueListMgr.h"
#import "MultiScenarioAmountVariableValueListMgr.h"
#import "NumberFieldValidator.h"
#import "StringValidation.h"

#import "PercentFieldValidator.h"
#import "PositiveAmountValidator.h"
#import "GrowthRateFieldValidator.h"

@implementation VariableValueRuntimeInfo

@synthesize valueFormatter;
@synthesize valueValidator;
@synthesize valueTitleKey;
@synthesize valueVerb;
@synthesize periodDesc;
@synthesize listMgr;
@synthesize singleValSubtitleKey;
@synthesize inlineValueTitleKey;
@synthesize variableValSubtitleKey;
@synthesize valuePromptKey;
@synthesize valueTypeTitle;
@synthesize valueName;
@synthesize tableSubtitle;

- (id) initWithFormatter:(NSNumberFormatter*)valFormatter
			andValueValidator:(NumberFieldValidator*)valValidator
		   andValueTitle:(NSString*)title 
		andInlineValueTitleKey:(NSString*)theInlineValueTitleKey
			andValueVerb:(NSString*)verb
		   andPeriodDesc:(NSString*)thePeriodDesc 
			  andListMgr:(id<VariableValueListMgr>)theListMgr
		andSingleValueSubtitleKey:(NSString*)theSingleValSubtitleKey 
		andVariableValueSubtitleKey:(NSString*)theVarValSubtitleKey
	   andValuePromptKey:(NSString*)theValPromptKey
	   andValueTypeTitle:(NSString*)theValueTypeTitle
	   andValueName:(NSString*)theValueName
	   andTableSubtitle:(NSString*)theTableSubtitle
{
	self = [super init];
	if(self)
	{
		assert(valFormatter != nil);
		assert(title != nil);
		assert([title length] > 0);
		self.valueFormatter = valFormatter;
		self.valueValidator = valValidator;
		self.valueTitleKey = title;
		self.valueVerb = verb;
		self.periodDesc = thePeriodDesc;
		self.listMgr = theListMgr;
		self.singleValSubtitleKey = theSingleValSubtitleKey;
		self.inlineValueTitleKey = theInlineValueTitleKey;
		self.variableValSubtitleKey = theVarValSubtitleKey;
		self.valuePromptKey = theValPromptKey;
		self.valueTypeTitle = theValueTypeTitle;
		self.valueName = theValueName;
		self.tableSubtitle = theTableSubtitle;
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
	[valueFormatter release];
	[valueValidator release];
	[valueTitleKey release];
	[valueVerb release];
	[periodDesc release];
	[listMgr release];
	[singleValSubtitleKey release];
	[inlineValueTitleKey release];
	[variableValSubtitleKey release];
	[valuePromptKey release];
	[valueTypeTitle release];
	[valueName release];
	[tableSubtitle release];
}

- (NSString *)inlinePeriodDesc;
{
	NSString *periodDescStr = @"";
	if([self.periodDesc length] > 0)
	{
		periodDescStr = [NSString stringWithFormat:@" %@",
					  self.periodDesc];		  
	}
	return periodDescStr;

}


+ (VariableValueRuntimeInfo*)createForSharedInterestRate:(Input*)theInput
{
	SharedEntityVariableValueListMgr *sharedInterestRatesMgr = 
	[[[SharedEntityVariableValueListMgr alloc] 
		initWithEntity:INTEREST_RATE_ENTITY_NAME] autorelease];
	
	
	NSString *tableSubtitle = [NSString 
			stringWithFormat:LOCALIZED_STR(@"SHARED_INTEREST_RATE_TABLE_SUBTITLE_FORMAT"),
			LOCALIZED_STR(@"SHARED_INTEREST_RATE_INLINE_VALUE_TITLE"),
			LOCALIZED_STR(@"SHARED_INTEREST_RATE_INLINE_VALUE_TITLE")];

	
	VariableValueRuntimeInfo *interestRuntimeInfo = [[[VariableValueRuntimeInfo alloc] 
		initWithFormatter:[NumberHelper theHelper].percentFormatter 
		andValueValidator:[[[PercentFieldValidator alloc] init] autorelease]
		andValueTitle:@"SHARED_INTEREST_RATE_VALUE_TITLE"
		andInlineValueTitleKey:@"SHARED_INTEREST_RATE_INLINE_VALUE_TITLE"
		andValueVerb:LOCALIZED_STR(@"SHARED_INTEREST_RATE_ACTION_VERB")
		andPeriodDesc:LOCALIZED_STR(@"SHARED_INTEREST_RATE_PERIOD") 
		andListMgr:sharedInterestRatesMgr
		andSingleValueSubtitleKey:@"SHARED_INTEREST_RATE_SINGLE_VALUE_SECTION_SUBTITLE"
		andVariableValueSubtitleKey:@"SHARED_INTEREST_RATE_DATE_SENSITIVE_VALUE_VARIABLE_SUBTITLE"
		andValuePromptKey:@"SHARED_INTEREST_RATE_VALUE_PROMPT"
		andValueTypeTitle:[theInput inputTypeTitle]
		andValueName:theInput.name
		andTableSubtitle:tableSubtitle] autorelease];
	return interestRuntimeInfo;

}


+ (VariableValueRuntimeInfo*)createForSharedInflationRate:(Input*)theInput
{

	// TODO - Review this and the other "create For" methods for duplication with the 
	// code that creates VariableRuntimeInfo's in the input creation helper code.
	// Either call these "createFor..." methods from there or delete these methods.

	assert(theInput != nil);
	SharedEntityVariableValueListMgr *sharedInflationRatesMgr = 
	[[[SharedEntityVariableValueListMgr alloc] initWithEntity:INFLATION_RATE_ENTITY_NAME] autorelease];
	
	NSString *tableSubtitle = [NSString 
			stringWithFormat:LOCALIZED_STR(@"INPUT_INFLATION_RATE__TABLE_SUBTITLE_FORMAT"),
			LOCALIZED_STR(@"INPUT_INFLATION_RATE_INLINE_VALUE_TITLE"),
			LOCALIZED_STR(@"INPUT_INFLATION_RATE_INLINE_VALUE_TITLE")];

	
	VariableValueRuntimeInfo *inflationRuntimeInfo = [[[VariableValueRuntimeInfo alloc] 
		initWithFormatter:[NumberHelper theHelper].percentFormatter 
		andValueValidator:[[[GrowthRateFieldValidator alloc] init] autorelease]
		andValueTitle:@"INPUT_INFLATION_RATE_VALUE_TITLE"
		andInlineValueTitleKey:@"INPUT_INFLATION_RATE_INLINE_VALUE_TITLE"
		andValueVerb:LOCALIZED_STR(@"INPUT_INFLATION_RATE_ACTION_VERB")
		andPeriodDesc:LOCALIZED_STR(@"INPUT_INFLATION_RATE_PERIOD") 
		andListMgr:sharedInflationRatesMgr
		andSingleValueSubtitleKey:@"INPUT_INFLATION_RATE_SINGLE_VALUE_SECTION_SUBTITLE"
		andVariableValueSubtitleKey:@"SHARED_INTEREST_RATE_DATE_SENSITIVE_VALUE_VARIABLE_SUBTITLE"
		andValuePromptKey:@"INPUT_INFLATION_RATE_VALUE_PROMPT"
		andValueTypeTitle:[theInput inputTypeTitle]
		andValueName:theInput.name
		andTableSubtitle:tableSubtitle] autorelease];
	return inflationRuntimeInfo;

}

+ (VariableValueRuntimeInfo*)createForVariableAmount:(Input*)theInput 
	andVariableValListMgr:(id<VariableValueListMgr>)listMgr
{
	NSString *tableSubtitle = [NSString 
	 stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_AMOUNT_TABLE_SUBTITLE_FORMAT"),
	 LOCALIZED_STR(@"INPUT_CASH_FLOW_AMOUNT_INLINE_VALUE_TITLE"),
	 [theInput inlineInputType],
	 LOCALIZED_STR(@"INPUT_CASH_FLOW_AMOUNT_INLINE_VALUE_TITLE")];
						
	VariableValueRuntimeInfo *amountRuntimeInfo = 
		[[[VariableValueRuntimeInfo alloc]
		initWithFormatter:[NumberHelper theHelper].currencyFormatter 
		andValueValidator: [[[PositiveAmountValidator alloc] init] autorelease]
		andValueTitle:@"INPUT_CASH_FLOW_AMOUNT_VALUE_TITLE" 
		andInlineValueTitleKey:@"INPUT_CASH_FLOW_AMOUNT_INLINE_VALUE_TITLE"
		andValueVerb:@"" andPeriodDesc:@"" andListMgr:listMgr
		andSingleValueSubtitleKey:@"INPUT_CASH_FLOW_AMOUNT_SINGLE_VALUE_SECTION_SUBTITLE"
		andVariableValueSubtitleKey:@"INPUT_CASH_FLOW_AMOUNT_DATE_SENSITIVE_VALUE_VARIABLE_SUBTITLE_FORMAT"
		andValuePromptKey:@"INPUT_CASH_FLOW_AMOUNT_VALUE_PROMPT"
		  andValueTypeTitle:[theInput inputTypeTitle]
		  andValueName:theInput.name
		  andTableSubtitle:tableSubtitle]
		 autorelease];
		 
	return amountRuntimeInfo;

}



+(VariableValueRuntimeInfo*)createForMultiScenarioAmount:(MultiScenarioAmount*)theAmount 
	withValueTitle:(NSString*)valueTitle andValueName:(NSString*)valueName
{
	assert(theAmount != nil);
	assert([StringValidation nonEmptyString:valueTitle]);

	MultiScenarioAmountVariableValueListMgr *variableValueMgr = 
		[[[MultiScenarioAmountVariableValueListMgr alloc] initWithMultiScenarioAmount:theAmount] autorelease];
		
		
	NSString *theTableSubtitle = [NSString 
	 stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_AMOUNT_TABLE_SUBTITLE_FORMAT"),
	 LOCALIZED_STR(@"INPUT_CASH_FLOW_AMOUNT_INLINE_VALUE_TITLE"),
	 @"",
	 LOCALIZED_STR(@"INPUT_CASH_FLOW_AMOUNT_INLINE_VALUE_TITLE")];
						
	VariableValueRuntimeInfo *amountRuntimeInfo = 
		[[[VariableValueRuntimeInfo alloc]
		initWithFormatter:[NumberHelper theHelper].currencyFormatter 
		andValueValidator: [[[PositiveAmountValidator alloc] init] autorelease]
		andValueTitle:@"INPUT_CASH_FLOW_AMOUNT_VALUE_TITLE" 
		andInlineValueTitleKey:@"INPUT_CASH_FLOW_AMOUNT_INLINE_VALUE_TITLE"
		andValueVerb:@"" andPeriodDesc:@"" andListMgr:variableValueMgr
		andSingleValueSubtitleKey:@"INPUT_CASH_FLOW_AMOUNT_SINGLE_VALUE_SECTION_SUBTITLE"
		andVariableValueSubtitleKey:@"INPUT_CASH_FLOW_AMOUNT_DATE_SENSITIVE_VALUE_VARIABLE_SUBTITLE_FORMAT"
		andValuePromptKey:@"INPUT_CASH_FLOW_AMOUNT_VALUE_PROMPT"
		  andValueTypeTitle:valueTitle
		  andValueName:valueName
		  andTableSubtitle:theTableSubtitle]
		 autorelease];
		 
	return amountRuntimeInfo;
}



@end
