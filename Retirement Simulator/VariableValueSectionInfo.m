//
//  VariableValueSectionInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableValueSectionInfo.h"
#import "NumberFieldEditInfo.h"
#import "DataModelController.h"
#import "GenericFieldBasedTableAddViewController.h"
#import "FormPopulator.h"
#import "FormInfo.h"
#import "SectionInfo.h"
#import "VariableValue.h"
#import "DataModelController.h"
#import "StaticFormInfoCreator.h"
#import "FinishedAddingObjectListener.h"
#import "DateSensitiveValueChangeAddedListener.h"
#import "LocalizationHelper.h"
#import "NameFieldEditInfo.h"
#import "ManagedObjectFieldInfo.h"
#import "VariableValueRuntimeInfo.h"
#import "SectionHeaderWithSubtitle.h"
#import "FormContext.h"


@implementation VariableValueSectionInfo

@synthesize varValRuntimeInfo;

- (id) initWithVariableValueRuntimeInfo:(VariableValueRuntimeInfo*)theVarValRuntimeInfo
	andFormContext:(FormContext*)theFormContext
{
	self = [super initWithHelpInfo:theVarValRuntimeInfo.variableValHelpInfoFile
	 andFormContext:theFormContext];
	if(self)
	{
		assert(theVarValRuntimeInfo != nil);
		self.varValRuntimeInfo = theVarValRuntimeInfo;

		self.title =  [[[NSString alloc] initWithFormat:
			LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_VARIABLE_TITLE_FORMAT"),
			LOCALIZED_STR(self.varValRuntimeInfo.valueTitleKey)] autorelease];

	}
	return self;
}

- (id) init
{
	assert(0); // shouldn't call
	return nil;
}

-(void)addButtonPressedInSectionHeader:(FormContext*)parentContext
{
    NSLog(@"Add Variable Value");
    
    FormPopulator *formPopulator = [[[FormPopulator alloc] initWithFormContext:parentContext] autorelease];
	
    formPopulator.formInfo.title = [[[NSString alloc] initWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_VARIABLE_TITLE_FORMAT"),
									 LOCALIZED_STR(self.varValRuntimeInfo.valueTitleKey)] autorelease];
    
    VariableValue *newVariableValue = [self.varValRuntimeInfo.listMgr createNewValue];
    [parentContext.dataModelController saveContextAndIgnoreErrors];

    
    SectionInfo *sectionInfo = [formPopulator nextSection];
	
	NSString *varValueNamePlaceholder = [NSString stringWithFormat:LOCALIZED_STR(@"VARIABLE_VALUE_NAME_PLACEHOLDER_FORMAT"),
			LOCALIZED_STR(self.varValRuntimeInfo.valueTitleKey)];
	
	ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc] initWithManagedObject:newVariableValue andFieldKey:@"name"  andFieldLabel:LOCALIZED_STR(@"VARIABLE_VALUE_NAME_LABEL") 
		andFieldPlaceholder:varValueNamePlaceholder] autorelease];
	NameFieldEditInfo *fieldEditInfo = [[[NameFieldEditInfo alloc] initWithFieldInfo:fieldInfo] autorelease];
    [sectionInfo addFieldEditInfo:fieldEditInfo];
			 
	NSString *varValStartingValPlaceholder = 
		[NSString stringWithFormat:LOCALIZED_STR(@"VARIABLE_VALUE_START_VALUE_PLACEHOLDER_FORMAT"),
		LOCALIZED_STR(self.varValRuntimeInfo.valueTitleKey)];
			 
    [sectionInfo addFieldEditInfo:[NumberFieldEditInfo createForObject:newVariableValue 
             andKey:@"startingValue" andLabel:LOCALIZED_STR(@"VARIABLE_VALUE_START_DATE_FIELD_LABEL")
			 andPlaceholder:varValStartingValPlaceholder
			 andNumberFormatter:self.varValRuntimeInfo.valueFormatter andValidator:varValRuntimeInfo.valueValidator]];
    
    GenericFieldBasedTableAddViewController *controller = 
        [[[GenericFieldBasedTableAddViewController alloc]
          initWithFormInfoCreator:[StaticFormInfoCreator createWithFormInfo:formPopulator.formInfo]
          andNewObject:newVariableValue andDataModelController:parentContext.dataModelController] autorelease];
    controller.popDepth =1;
	controller.finshedAddingListener = varValRuntimeInfo.listMgr;

    
    [parentContext.parentController.navigationController pushViewController:controller animated:YES];
    
}

- (void)dealloc
{
    [varValRuntimeInfo release];
    [super dealloc];
}

@end
