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


@implementation VariableValueRuntimeInfo

@synthesize valueFormatter;
@synthesize valueTitle;
@synthesize valueVerb;
@synthesize periodDesc;
@synthesize listMgr;
@synthesize singleValSubtitleKey;
@synthesize inlineValueTitleKey;
@synthesize variableValSubtitleKey;

- (id) initWithFormatter:(NSNumberFormatter*)valFormatter
		   andValueTitle:(NSString*)title 
		   andInlineValueTitleKey:(NSString*)theInlineValueTitleKey
		   andValueVerb:(NSString*)verb
		   andPeriodDesc:(NSString*)thePeriodDesc 
		   andListMgr:(id<VariableValueListMgr>)theListMgr
		   andSingleValueSubtitleKey:(NSString*)theSingleValSubtitleKey
		   andVariableValueSubtitleKey:(NSString*)theVarValSubtitleKey
{
	self = [super init];
	if(self)
	{
		assert(valFormatter != nil);
		assert(title != nil);
		assert([title length] > 0);
		self.valueFormatter = valFormatter;
		self.valueTitle = title;
		self.valueVerb = verb;
		self.periodDesc = thePeriodDesc;
		self.listMgr = theListMgr;
		self.singleValSubtitleKey = theSingleValSubtitleKey;
		self.inlineValueTitleKey = theInlineValueTitleKey;
		self.variableValSubtitleKey = theVarValSubtitleKey;
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
	[valueFormatter release];
	[valueTitle release];
	[valueVerb release];
	[periodDesc release];
	[listMgr release];
	[singleValSubtitleKey release];
	[inlineValueTitleKey release];
	[variableValSubtitleKey release];
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
	VariableValueRuntimeInfo *amountRuntimeInfo = 
		[[[VariableValueRuntimeInfo alloc]
		initWithFormatter:[NumberHelper theHelper].currencyFormatter 
		andValueTitle:LOCALIZED_STR(@"INPUT_CASH_FLOW_AMOUNT_VALUE_TITLE") 
		andInlineValueTitleKey:@"INPUT_CASH_FLOW_AMOUNT_INLINE_VALUE_TITLE"
		andValueVerb:@"" andPeriodDesc:@"" andListMgr:variableAmountMgr
		andSingleValueSubtitleKey:@"INPUT_CASH_FLOW_AMOUNT_SINGLE_VALUE_SECTION_SUBTITLE"
		andVariableValueSubtitleKey:@"INPUT_CASH_FLOW_AMOUNT_DATE_SENSITIVE_VALUE_VARIABLE_SUBTITLE_FORMAT"] autorelease];
	return amountRuntimeInfo;
}

+ (VariableValueRuntimeInfo*)createForInflationRate
{
	SharedEntityVariableValueListMgr *sharedInflationRatesMgr = 
	[[[SharedEntityVariableValueListMgr alloc] initWithEntity:@"InflationRate"] autorelease];
	
	VariableValueRuntimeInfo *inflationRuntimeInfo = [[[VariableValueRuntimeInfo alloc] 
		initWithFormatter:[NumberHelper theHelper].percentFormatter 
		andValueTitle:LOCALIZED_STR(@"INPUT_INFLATION_RATE_VALUE_TITLE")
		andInlineValueTitleKey:@"INPUT_INFLATION_RATE_INLINE_VALUE_TITLE"
		andValueVerb:LOCALIZED_STR(@"INPUT_INFLATION_RATE_ACTION_VERB")
		andPeriodDesc:LOCALIZED_STR(@"INPUT_INFLATION_RATE_PERIOD") 
		andListMgr:sharedInflationRatesMgr
		andSingleValueSubtitleKey:@"INPUT_INFLATION_RATE_SINGLE_VALUE_SECTION_SUBTITLE"
		andVariableValueSubtitleKey:@"INPUT_INFLATION_RATE_DATE_SENSITIVE_VALUE_VARIABLE_SUBTITLE_FORMAT"] autorelease];
	return inflationRuntimeInfo;
}

@end
