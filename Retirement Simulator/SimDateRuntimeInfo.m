//
//  VariableDateRuntimeInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimDateRuntimeInfo.h"

//#import "CashFlowInput.h"
#import "Input.h"
#import "VariableValueRuntimeInfo.h"
#import "StringLookupTable.h"
#import "LocalizationHelper.h"
#import "VariableValue.h"

@implementation SimDateRuntimeInfo

@synthesize tableTitle;
@synthesize tableHeader;
@synthesize tableSubHeader;
@synthesize supportsNeverEndDate;
@synthesize neverEndDateSectionTitle;
@synthesize neverEndDateHelpFile;
@synthesize neverEndDateFieldCaption;
@synthesize neverEndDateFieldSubtitle;
@synthesize relEndDateSectionTitle;
@synthesize relEndDateHelpFile;
@synthesize relEndDateFieldLabel;

- (id)initWithTableTitle:(NSString*)theTitle andHeader:(NSString*)theHeader
			andSubHeader:(NSString*)theSubHeader andSupportsNeverEndDate:(bool)doesSupportNeverEndDate
{
	self = [super init];
	if(self)
	{
		self.tableHeader = theHeader;
		self.tableTitle = theTitle;
		self.tableSubHeader = theSubHeader;
		self.supportsNeverEndDate = doesSupportNeverEndDate;
		
		self.neverEndDateSectionTitle = LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_SECTION_TITLE");
		self.neverEndDateHelpFile = @"neverEndDate";
		self.neverEndDateFieldCaption = LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_LABEL");
		self.neverEndDateFieldSubtitle = LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_SUBTITLE");
		self.relEndDateSectionTitle = LOCALIZED_STR(@"SIM_DATE_RELATIVE_ENDING_DATE_SECTION_TITLE");
		self.relEndDateHelpFile = @"relEndDate";
		self.relEndDateFieldLabel = LOCALIZED_STR(@"RELATIVE_END_DATE_FIELD_LABEL");
	}
	return self;
}

- (id) init
{
	assert(0);
	return nil;
}

- (void) dealloc
{
	[tableTitle  release];
	[tableHeader release];
	[tableSubHeader release];
	[neverEndDateSectionTitle release];
	[neverEndDateHelpFile release];
	[neverEndDateFieldCaption release];
	[neverEndDateFieldSubtitle release];
	[relEndDateSectionTitle release];
	[relEndDateHelpFile release];
	[relEndDateFieldLabel release];
	[super dealloc];
}


+ (SimDateRuntimeInfo*)createForInput:(Input*)theInput
	andFieldTitleKey:(NSString*)fieldTitleStringFileKey 
	andSubHeaderFormatKey:(NSString*)subHeaderFormatKey
	andSubHeaderFormatKeyNoName:(NSString*)subHeaderFormatKeyNoName
{
	NSString *parentName = theInput.name;
	NSString *tableHeader;
	NSString *tableSubHeader;
	if(parentName == nil)
	{
		tableHeader = [NSString stringWithFormat:
				LOCALIZED_STR(@"VARIABLE_DATE_TABLE_TITLE_FORMAT_NO_NAME"),
				[theInput inputTypeTitle],LOCALIZED_STR(fieldTitleStringFileKey)];
		tableSubHeader = [NSString stringWithFormat:
						 LOCALIZED_STR(subHeaderFormatKeyNoName),
						 [theInput inlineInputType]];
		
	}
	else
	{
		tableHeader = [NSString stringWithFormat:
					  LOCALIZED_STR(@"VARIABLE_DATE_TABLE_TITLE_FORMAT"),
					  [theInput inputTypeTitle],LOCALIZED_STR(fieldTitleStringFileKey),
					  parentName];
		tableSubHeader = [NSString stringWithFormat:
						 LOCALIZED_STR(subHeaderFormatKey),
						 [theInput inlineInputType],parentName];
	}

	NSString *tableTitle = LOCALIZED_STR(fieldTitleStringFileKey);

	return [[[SimDateRuntimeInfo alloc] initWithTableTitle:tableTitle andHeader:tableHeader andSubHeader:tableSubHeader andSupportsNeverEndDate:TRUE] autorelease];
}

+ (SimDateRuntimeInfo*)createForDateSensitiveValue:(VariableValueRuntimeInfo*)valRuntimeInfo
	andVariableValue:(VariableValue*)varValue
{

	NSString *tableHeader = [NSString stringWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_VALUE_CHANGE_TABLE_HEADER_FORMAT"),
					LOCALIZED_STR(valRuntimeInfo.valueTitleKey)		];

	NSString *tableSubheader = 
		[NSString stringWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_VALUE_CHANGE_TABLE_SUBHEADER_FORMAT"),
		 LOCALIZED_STR(valRuntimeInfo.inlineValueTitleKey),varValue.name];
		 
	NSString *tableTitle = LOCALIZED_STR(valRuntimeInfo.valueTitleKey);

	return [[[SimDateRuntimeInfo alloc] initWithTableTitle:tableTitle andHeader:tableHeader andSubHeader:tableSubheader andSupportsNeverEndDate:TRUE] autorelease];
}

@end
