//
//  VariableValueFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableValueFormInfoCreator.h"
#import "FormPopulator.h"
#import "SectionInfo.h"
#import "NumberFieldEditInfo.h"
#import "DateSensitiveValueChange.h"
#import "VariableValueRuntimeInfo.h"
#import "DateSensitiveValueChangeFieldEditInfo.h"
#import "VariableValue.h"
#import "AddObjectSectionInfo.h"
#import "CollectionHelper.h"
#import "DateSensitiveValueChangeSectionInfo.h"
#import "LocalizationHelper.h"
#import "ManagedObjectFieldInfo.h"
#import "NameFieldEditInfo.h"
#import "StaticNameFieldEditInfo.h"


@implementation VariableValueFormInfoCreator

@synthesize variableValue;
@synthesize varValRuntimeInfo;


- (id)initWithVariableValue:(VariableValue*)theValue
	 andVarValueRuntimeInfo:(VariableValueRuntimeInfo*)theVarValRuntimeInfo
{
    self = [super init];
    if(self)
    {
        assert(theValue != nil);
        self.variableValue = theValue;
		
		assert(theVarValRuntimeInfo != nil);
		self.varValRuntimeInfo = theVarValRuntimeInfo;
        
    }
    return self;
}

- (id) init 
{
	assert(0); // must not call
	return nil;
}


- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
	FormPopulator *formPopulator = [[[FormPopulator alloc] initWithParentController:parentController] autorelease];
    
    formPopulator.formInfo.title = [NSString 
		stringWithFormat:LOCALIZED_STR(@"VARIABLE_VALUE_VIEW_TITLE_FORMAT"),
		LOCALIZED_STR(self.varValRuntimeInfo.valueTitleKey)];
		
    assert(parentController != nil);
    SectionInfo *sectionInfo = [formPopulator nextSection];
	
	NSString *varValueNamePlaceholder = [NSString stringWithFormat:LOCALIZED_STR(@"VARIABLE_VALUE_NAME_PLACEHOLDER_FORMAT"),
										 LOCALIZED_STR(self.varValRuntimeInfo.valueTitleKey)];

	// TODO - Need to display the name, but not editable when default is shown
	if([self.variableValue nameIsStaticLabel])
	{
		StaticNameFieldEditInfo *staticNameFieldInfo = 
			[[[StaticNameFieldEditInfo alloc] 
			initWithName:self.variableValue.label] autorelease];
		[sectionInfo addFieldEditInfo:staticNameFieldInfo];
	}
	else
	{
		ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc] initWithManagedObject:self.variableValue andFieldKey:@"name" andFieldLabel:LOCALIZED_STR(@"VARIABLE_VALUE_NAME_LABEL") andFieldPlaceholder:varValueNamePlaceholder] autorelease];
		NameFieldEditInfo *fieldEditInfo = [[[NameFieldEditInfo alloc] 
				initWithFieldInfo:fieldInfo] autorelease];
		[sectionInfo addFieldEditInfo:fieldEditInfo];
	}
	
	
	sectionInfo = [formPopulator nextSectionWithTitle:[NSString 
	  stringWithFormat:LOCALIZED_STR(@"VARIABLE_VALUE_START_DATE_SECTION_TITLE_FORMAT"),
	       LOCALIZED_STR(self.varValRuntimeInfo.valueTitleKey)]
		   andHelpFile:@"variableValueStartDate"];
							
	NSString *varValStartingValPlaceholder = 
	[NSString stringWithFormat:LOCALIZED_STR(@"VARIABLE_VALUE_START_VALUE_PLACEHOLDER_FORMAT"),
	 LOCALIZED_STR(self.varValRuntimeInfo.valueTitleKey)];
						
	[sectionInfo addFieldEditInfo:[NumberFieldEditInfo createForObject:self.variableValue
			andKey:@"startingValue" andLabel:LOCALIZED_STR(@"VARIABLE_VALUE_START_DATE_FIELD_LABEL") 
			andPlaceholder:varValStartingValPlaceholder    
			andNumberFormatter:self.varValRuntimeInfo.valueFormatter andValidator:self.varValRuntimeInfo.valueValidator]];
	
	
	NSArray *valueChanges = [CollectionHelper setToSortedArray:
						  self.variableValue.valueChanges withKey:@"startDate"];
	DateSensitiveValueChangeSectionInfo *vcSectionInfo = 
		[[[DateSensitiveValueChangeSectionInfo alloc] 
		  initWithVariableValRuntimeInfo:self.varValRuntimeInfo 
		  andParentVariableValue:self.variableValue andParentController:parentController] autorelease];
		  
	[formPopulator nextCustomSection:vcSectionInfo];		
    for (DateSensitiveValueChange *valueChange in valueChanges)
    {
        // Create the row information for the given milestone date.
		DateSensitiveValueChangeFieldEditInfo *fieldInfo = 
			[[[DateSensitiveValueChangeFieldEditInfo alloc]
			  initWithValueChange:valueChange andVariableValueRuntimeInfo:self.varValRuntimeInfo
			  andVariableValue:self.variableValue ] autorelease];
        [vcSectionInfo addFieldEditInfo:fieldInfo];
    }
    return formPopulator.formInfo;
}

- (void) dealloc
{
    [super dealloc];
    [varValRuntimeInfo release];
    [variableValue release];
}



@end
