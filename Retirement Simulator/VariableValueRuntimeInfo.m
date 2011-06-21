//
//  VariableValueRuntimeInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableValueRuntimeInfo.h"
#import "SharedEntityVariableValueListMgr.h"
#import "CashFlowAmountVariableValueListMgr.h"
#import "LocalizationHelper.h"
#import "NumberHelper.h"
#import "CashFlowInput.h"


@implementation VariableValueRuntimeInfo

@synthesize valueFormatter;
@synthesize valueTitleKey;
@synthesize valueVerb;
@synthesize periodDesc;
@synthesize listMgr;
@synthesize singleValSubtitleKey;
@synthesize inlineValueTitleKey;
@synthesize variableValSubtitleKey;
@synthesize valuePromptKey;
@synthesize valueTypeTitle;
@synthesize valueTypeInline;
@synthesize valueName;
@synthesize tableSubtitle;

- (id) initWithFormatter:(NSNumberFormatter*)valFormatter
		   andValueTitle:(NSString*)title 
		andInlineValueTitleKey:(NSString*)theInlineValueTitleKey
			andValueVerb:(NSString*)verb
		   andPeriodDesc:(NSString*)thePeriodDesc 
			  andListMgr:(id<VariableValueListMgr>)theListMgr
		andSingleValueSubtitleKey:(NSString*)theSingleValSubtitleKey 
		andVariableValueSubtitleKey:(NSString*)theVarValSubtitleKey
	   andValuePromptKey:(NSString*)theValPromptKey
	   andValueTypeInline:(NSString*)theValueTypeInline
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
		self.valueTitleKey = title;
		self.valueVerb = verb;
		self.periodDesc = thePeriodDesc;
		self.listMgr = theListMgr;
		self.singleValSubtitleKey = theSingleValSubtitleKey;
		self.inlineValueTitleKey = theInlineValueTitleKey;
		self.variableValSubtitleKey = theVarValSubtitleKey;
		self.valuePromptKey = theValPromptKey;
		self.valueTypeTitle = theValueTypeTitle;
		self.valueTypeInline = theValueTypeInline;
		self.valueName = theValueName;
		self.tableSubtitle = theTableSubtitle;
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
	[valueFormatter release];
	[valueTitleKey release];
	[valueVerb release];
	[periodDesc release];
	[listMgr release];
	[singleValSubtitleKey release];
	[inlineValueTitleKey release];
	[variableValSubtitleKey release];
	[valuePromptKey release];
	[valueTypeTitle release];
	[valueTypeInline release];
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


+ (VariableValueRuntimeInfo*)createForCashflowAmount:(CashFlowInput*)cashFlow
{
	CashFlowAmountVariableValueListMgr *variableAmountMgr = 
		[[[CashFlowAmountVariableValueListMgr alloc] initWithCashFlow:cashFlow] autorelease];
		
	NSString *tableSubtitle = [NSString 
	 stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_AMOUNT_TABLE_SUBTITLE_FORMAT"),
	 LOCALIZED_STR(@"INPUT_CASH_FLOW_AMOUNT_INLINE_VALUE_TITLE"),
	 [cashFlow inlineInputType],
	 LOCALIZED_STR(@"INPUT_CASH_FLOW_AMOUNT_INLINE_VALUE_TITLE")];
						
	VariableValueRuntimeInfo *amountRuntimeInfo = 
		[[[VariableValueRuntimeInfo alloc]
		initWithFormatter:[NumberHelper theHelper].currencyFormatter 
		andValueTitle:@"INPUT_CASH_FLOW_AMOUNT_VALUE_TITLE" 
		andInlineValueTitleKey:@"INPUT_CASH_FLOW_AMOUNT_INLINE_VALUE_TITLE"
		andValueVerb:@"" andPeriodDesc:@"" andListMgr:variableAmountMgr
		andSingleValueSubtitleKey:@"INPUT_CASH_FLOW_AMOUNT_SINGLE_VALUE_SECTION_SUBTITLE"
		andVariableValueSubtitleKey:@"INPUT_CASH_FLOW_AMOUNT_DATE_SENSITIVE_VALUE_VARIABLE_SUBTITLE_FORMAT"
		andValuePromptKey:@"INPUT_CASH_FLOW_AMOUNT_VALUE_PROMPT"
		  andValueTypeInline:[cashFlow inlineInputType]
		  andValueTypeTitle:[cashFlow inputTypeTitle]
		  andValueName:cashFlow.name
		  andTableSubtitle:tableSubtitle]
		 autorelease];
	return amountRuntimeInfo;
}

+ (VariableValueRuntimeInfo*)createForInflationRate:(CashFlowInput*)cashFlow;
{
	SharedEntityVariableValueListMgr *sharedInflationRatesMgr = 
	[[[SharedEntityVariableValueListMgr alloc] initWithEntity:@"InflationRate"] autorelease];
	
	
	NSString *tableSubtitle = [NSString 
			stringWithFormat:LOCALIZED_STR(@"INPUT_INFLATION_RATE__TABLE_SUBTITLE_FORMAT"),
			LOCALIZED_STR(@"INPUT_INFLATION_RATE_INLINE_VALUE_TITLE"),
			LOCALIZED_STR(@"INPUT_INFLATION_RATE_INLINE_VALUE_TITLE")];

	
	VariableValueRuntimeInfo *inflationRuntimeInfo = [[[VariableValueRuntimeInfo alloc] 
		initWithFormatter:[NumberHelper theHelper].percentFormatter 
		andValueTitle:@"INPUT_INFLATION_RATE_VALUE_TITLE"
		andInlineValueTitleKey:@"INPUT_INFLATION_RATE_INLINE_VALUE_TITLE"
		andValueVerb:LOCALIZED_STR(@"INPUT_INFLATION_RATE_ACTION_VERB")
		andPeriodDesc:LOCALIZED_STR(@"INPUT_INFLATION_RATE_PERIOD") 
		andListMgr:sharedInflationRatesMgr
		andSingleValueSubtitleKey:@"INPUT_INFLATION_RATE_SINGLE_VALUE_SECTION_SUBTITLE"
		andVariableValueSubtitleKey:@"INPUT_INFLATION_RATE_DATE_SENSITIVE_VALUE_VARIABLE_SUBTITLE_FORMAT"
		andValuePromptKey:@"INPUT_INFLATION_RATE_VALUE_PROMPT"
		andValueTypeInline:[cashFlow inlineInputType]
		andValueTypeTitle:[cashFlow inputTypeTitle]
		andValueName:cashFlow.name
		andTableSubtitle:tableSubtitle] autorelease];
	return inflationRuntimeInfo;
}

@end
