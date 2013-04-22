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
#import "VariableValueFormInfoCreator.h"


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
    
    
    VariableValue *newVariableValue = [self.varValRuntimeInfo.listMgr createNewValue];
    [parentContext.dataModelController saveContextAndIgnoreErrors];

	VariableValueFormInfoCreator *vvFormInfoCreator = 
		[[[VariableValueFormInfoCreator alloc] initWithVariableValue:newVariableValue
		andVarValueRuntimeInfo:self.varValRuntimeInfo] autorelease];
		 
    GenericFieldBasedTableAddViewController *controller =
		[[[GenericFieldBasedTableAddViewController alloc]
			initWithFormInfoCreator:vvFormInfoCreator
			andNewObject:newVariableValue 
			andDataModelController:parentContext.dataModelController] autorelease];
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
