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

@synthesize defaultValFieldInfo;
@synthesize fieldInfo;
@synthesize varValRuntimeInfo;

- (id)initWithVariableValueFieldInfo:(FieldInfo*)vvFieldInfo
                  andDefaultValFieldInfo:(FieldInfo*)theDefaultValFieldInfo
               andVarValRuntimeInfo:(VariableValueRuntimeInfo *) theVarValRuntimeInfo
{
    self = [super init];
    if(self)
    {
        assert(vvFieldInfo != nil);
        self.fieldInfo = vvFieldInfo;
        
        assert(theDefaultValFieldInfo != nil);
        self.defaultValFieldInfo = theDefaultValFieldInfo;
        
		assert(theVarValRuntimeInfo != nil);
		self.varValRuntimeInfo = theVarValRuntimeInfo;
    }
    return self;
}


- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] initWithParentController:parentController] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(self.varValRuntimeInfo.valueTitleKey);
	
	
	VariableHeightTableHeader *tableHeader = 
		[[[VariableHeightTableHeader alloc] initWithFrame:CGRectZero] autorelease];

	if(self.varValRuntimeInfo.valueName != nil)
	{
		tableHeader.header.text = [NSString 
								   stringWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_TABLE_TITLE_FORMAT"),
								   LOCALIZED_STR(self.varValRuntimeInfo.valueTitleKey),
								   self.varValRuntimeInfo.valueName];
		
	}
	else
	{
		tableHeader.header.text = [NSString 
								   stringWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_TABLE_TITLE_FORMAT_UNDEFINED_NAME"),
								   LOCALIZED_STR(self.varValRuntimeInfo.valueTitleKey)];
	}

	tableHeader.subHeader.text = self.varValRuntimeInfo.tableSubtitle;
			
	[tableHeader resizeForChildren];
	formPopulator.formInfo.headerView = tableHeader;

    assert(parentController != nil);
    SectionInfo *sectionInfo = [formPopulator nextSection];
	
    sectionInfo.title = [[[NSString alloc]
			initWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_SINGLE_VALUE_TITLE_FORMAT"),
			LOCALIZED_STR(self.varValRuntimeInfo.valueTitleKey)] autorelease];
	sectionInfo.subTitle = LOCALIZED_STR(self.varValRuntimeInfo.singleValSubtitleKey);
    
	NumberFieldEditInfo *valueFieldEditInfo = 
		[[[NumberFieldEditInfo alloc]initWithFieldInfo:self.defaultValFieldInfo
		 andNumberFormatter:self.varValRuntimeInfo.valueFormatter andValidator:self.varValRuntimeInfo.valueValidator] autorelease];
	[sectionInfo addFieldEditInfo:valueFieldEditInfo];
    
    VariableValueSectionInfo *vvSectionInfo = [[[VariableValueSectionInfo alloc]
					initWithVariableValueRuntimeInfo:self.varValRuntimeInfo ] autorelease];
    vvSectionInfo.title =  [[[NSString alloc]
							 initWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_VARIABLE_TITLE_FORMAT"),
			LOCALIZED_STR(self.varValRuntimeInfo.valueTitleKey)] autorelease];
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
    [defaultValFieldInfo release];
    [fieldInfo release];
	[varValRuntimeInfo release];
}

@end
