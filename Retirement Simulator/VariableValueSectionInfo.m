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


@implementation VariableValueSectionInfo

@synthesize varValRuntimeInfo;

- (id) initWithVariableValueRuntimeInfo:(VariableValueRuntimeInfo*)theVarValRuntimeInfo
	andParentViewController:(UIViewController*)theParentController
{
	self = [super init];
	if(self)
	{
		assert(theVarValRuntimeInfo != nil);
		self.varValRuntimeInfo = theVarValRuntimeInfo;
		
		assert(theVarValRuntimeInfo.variableValHelpInfoFile != nil);
		self.helpInfoHTMLFile = theVarValRuntimeInfo.variableValHelpInfoFile;
		
		
		assert(theParentController != nil);
		self.parentViewController = theParentController;
		self.sectionHeader.parentController = theParentController;
		
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

-(void)addButtonPressedInSectionHeader:(UIViewController*)parentView
{
    assert(self.parentViewController != nil);
    NSLog(@"Add Variable Value");
    
    FormPopulator *formPopulator = [[[FormPopulator alloc] initWithParentController:self.parentViewController] autorelease];
	
    formPopulator.formInfo.title = [[[NSString alloc] initWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_VARIABLE_TITLE_FORMAT"),
									 LOCALIZED_STR(self.varValRuntimeInfo.valueTitleKey)] autorelease];
    
    VariableValue *newVariableValue = [self.varValRuntimeInfo.listMgr createNewValue];
    [[DataModelController theDataModelController] saveContextAndIgnoreErrors];

    
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
          andNewObject:newVariableValue] autorelease];
    controller.popDepth =1;
	controller.finshedAddingListener = varValRuntimeInfo.listMgr;

    
    [self.parentViewController.navigationController pushViewController:controller animated:YES];
    
}

- (void)dealloc
{
    [super dealloc];
    [varValRuntimeInfo release];
}

@end
