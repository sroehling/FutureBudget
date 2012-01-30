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
    SectionInfo *sectionInfo = [formPopulator nextSectionWithTitle:[[[NSString alloc]
			initWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_SINGLE_VALUE_TITLE_FORMAT"),
			LOCALIZED_STR(self.varValRuntimeInfo.valueTitleKey)] autorelease]
			andHelpFile:self.varValRuntimeInfo.singleValHelpInfoFile];
	    
	
	/*
		The comments below pertain to the use of defaultValFieldInfo and editing/selecting of values in 
		in conjunction with SelectableObjectTableEditViewController. This stems from a
		defect that was found in SelectableObjectTableEditViewController where the default
		value was updated using the valueFieldEditInfo, but not the assigned value:
		
		In the table view for selecting and editing date sensitive values, there is a 
		fixed value field/row and other fields to select shared values. 

		There is a FieldInfo object (MultiScenarioInputValueFieldInfo) for the actual 
		assignment. This object requires an InputValue as its value. This "assigned value" 
		is the value actually used in the application.

		The fixed value field is initialized with a MultiScenarioFixedValFieldInfo. 
		This field info is initialized with a default value, and the NumberFieldEditInfo 
		object is initialized with this object. When changes are made to the object,
		they are immediately written to the default value, but not directly to the assigned value.

		A SelectableObjectTableEditViewController is used to display the date
		sensitive value form information. This class maintains both a currentValueIndex 
		and currentValue property, representing the currently selected item. 
		The assignedField property holds the value for the assigned value (see above). 
		Code like the following is used to initialize and update the currentValue 
		and currentValueIndex.

			self.currentValue = [self.assignedField getFieldValue]
			self.currentValueIndex = [self.formInfo pathForObject:self.currentValue];        

		The pathForObject selector in turn uses the managedObject selector on the 
		associated NumberFieldEditInfo to retrieve the current value. For the 
		scenario described above, the default value is updated, but the 
		currentValue is not necessarily kept in sync. In the case of a 
		default scenario, the assigned value happens to be set to the same 
		object as the default value, so no update is needed. However, when 
		a new value is created for a different scenario, the assigned field 
		is not automatically updated; to rectify this, when the 
		SelectableObjectTableEditViewController comes out of edit mode, 
		and using the currentIndex which hasn't changed and the (newly changed)
		 managedObject returned from the  default value FieldInfo, the assignedField is updated.

		TBD - A possibly more robust solution would be to have a type of proxy 
		FieldInfo object which is initialized with both the default value and 
		assigned value. Getting the value does so from the default. Setting the 
		value sets the default and then the assigned.
	*/
	
	NumberFieldEditInfo *valueFieldEditInfo = 
		[[[NumberFieldEditInfo alloc]initWithFieldInfo:self.defaultValFieldInfo
		 andNumberFormatter:self.varValRuntimeInfo.valueFormatter andValidator:self.varValRuntimeInfo.valueValidator] autorelease];
	[sectionInfo addFieldEditInfo:valueFieldEditInfo];
    
    VariableValueSectionInfo *vvSectionInfo = [[[VariableValueSectionInfo alloc]
					initWithVariableValueRuntimeInfo:self.varValRuntimeInfo andParentViewController:parentController] autorelease];
    [formPopulator nextCustomSection:vvSectionInfo];
    
	
    NSArray *variableValues = [self.varValRuntimeInfo.listMgr variableValues];
    for (VariableValue *varValue in variableValues)
    {
        VariableValueFieldEditInfo *vvFieldInfo = [[[VariableValueFieldEditInfo alloc]initWithVariableValue:varValue
				andVarValRuntimeInfo:self.varValRuntimeInfo] autorelease];
        // Create the row information for the given milestone date.
        [vvSectionInfo addFieldEditInfo:vvFieldInfo];
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
