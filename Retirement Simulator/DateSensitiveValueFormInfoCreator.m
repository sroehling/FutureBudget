//
//  DateSensitiveValueFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValueFormInfoCreator.h"
#import "FormInfo.h"
#import "FormPopulator.h"
#import "SectionInfo.h"
#import "VariableValue.h"
#import "FixedValue.h"
#import "ManagedObjectFieldInfo.h"
#import "VariableValueSectionInfo.h"
#import "DataModelController.h"
#import "NumberFieldEditInfo.h"
#import "StringValidation.h"
#import "VariableValueFieldEditInfo.h"
#import "LocalizationHelper.h"
#import "VariableHeightTableHeader.h"

@implementation DateSensitiveValueFormInfoCreator

@synthesize defaultFixedVal;
@synthesize fieldInfo;
@synthesize varValRuntimeInfo;

- (id)initWithVariableValueFieldInfo:(ManagedObjectFieldInfo*)vvFieldInfo
                  andDefaultFixedVal:(FixedValue*)theDefaultFixedVal
				andVarValRuntimeInfo:(VariableValueRuntimeInfo *) theVarValRuntimeInfo
{
    self = [super init];
    if(self)
    {
        assert(vvFieldInfo != nil);
        self.fieldInfo = vvFieldInfo;
        
        assert(theDefaultFixedVal != nil);
        self.defaultFixedVal = theDefaultFixedVal;
        
		assert(theVarValRuntimeInfo != nil);
		self.varValRuntimeInfo = theVarValRuntimeInfo;
    }
    return self;
}


- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
    
    formPopulator.formInfo.title = self.varValRuntimeInfo.valueTitle;
	
	
	VariableHeightTableHeader *tableHeader = 
		[[[VariableHeightTableHeader alloc] initWithFrame:CGRectZero] autorelease];

	if(self.varValRuntimeInfo.valueName != nil)
	{
		tableHeader.header.text = [NSString 
								   stringWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_TABLE_TITLE_FORMAT"),
								   self.varValRuntimeInfo.valueTypeTitle,self.varValRuntimeInfo.valueTitle,
								   self.varValRuntimeInfo.valueName];
		
	}
	else
	{
		tableHeader.header.text = [NSString 
								   stringWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_TABLE_TITLE_FORMAT_UNDEFINED_NAME"),
								   self.varValRuntimeInfo.valueTypeTitle,self.varValRuntimeInfo.valueTitle];
	}

	tableHeader.subHeader.text = self.varValRuntimeInfo.tableSubtitle;
			
	[tableHeader resizeForChildren];
	formPopulator.formInfo.headerView = tableHeader;

    assert(parentController != nil);
    SectionInfo *sectionInfo = [formPopulator nextSection];
	
	
	
    sectionInfo.title = [[[NSString alloc]
			initWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_SINGLE_VALUE_TITLE_FORMAT"),
			self.varValRuntimeInfo.valueTitle] autorelease];
	sectionInfo.subTitle = LOCALIZED_STR(self.varValRuntimeInfo.singleValSubtitleKey);
    
    [sectionInfo addFieldEditInfo:[NumberFieldEditInfo 
            createForObject:self.defaultFixedVal andKey:@"value" andLabel:self.varValRuntimeInfo.valueTitle
			andNumberFormatter:self.varValRuntimeInfo.valueFormatter]];
    
    VariableValueSectionInfo *vvSectionInfo = [[[VariableValueSectionInfo alloc]
					initWithVariableValueRuntimeInfo:self.varValRuntimeInfo ] autorelease];
    vvSectionInfo.title =  [[[NSString alloc]
							 initWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_VARIABLE_TITLE_FORMAT"),
			self.varValRuntimeInfo.valueTitle] autorelease];
	vvSectionInfo.subTitle =LOCALIZED_STR(self.varValRuntimeInfo.variableValSubtitleKey);
    vvSectionInfo.parentViewController = parentController;
    sectionInfo = vvSectionInfo;
    [formPopulator nextCustomSection:sectionInfo];
    
	
    NSArray *variableValues = [self.varValRuntimeInfo.listMgr variableValues];
    for (VariableValue *varValue in variableValues)
    {
        VariableValueFieldEditInfo *vvFieldInfo = [[[VariableValueFieldEditInfo alloc]initWithVariableValue:varValue
				andVarValRuntimeInfo:self.varValRuntimeInfo] autorelease];
        // Create the row information for the given milestone date.
        [sectionInfo addFieldEditInfo:vvFieldInfo];
    }
    return formPopulator.formInfo;
}

- (void) dealloc
{
    [super dealloc];
    [defaultFixedVal release];
    [fieldInfo release];
	[varValRuntimeInfo release];
}

@end
