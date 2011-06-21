//
//  VariableValueSectionInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableValueSectionInfo.h"
#import "NumberFieldEditInfo.h"
#import "TextFieldEditInfo.h"
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


@implementation VariableValueSectionInfo

@synthesize varValRuntimeInfo;

- (id) initWithVariableValueRuntimeInfo:(VariableValueRuntimeInfo*)theVarValRuntimeInfo;
{
	self = [super init];
	if(self)
	{
		assert(theVarValRuntimeInfo != nil);
		self.varValRuntimeInfo = theVarValRuntimeInfo;
	}
	return self;
}

- (id) init
{
	assert(0); // shouldn't call
	return nil;
}

- (void)addObjectButtonPressed
{
    assert(self.parentViewController != nil);
    NSLog(@"Add Variable Value");
    
    FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
	
    formPopulator.formInfo.title = [[[NSString alloc] initWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_VARIABLE_TITLE_FORMAT"),
									 LOCALIZED_STR(self.varValRuntimeInfo.valueTitleKey)] autorelease];
    
    VariableValue *newVariableValue = [self.varValRuntimeInfo.listMgr createNewValue];
    [[DataModelController theDataModelController] saveContext];

    
    SectionInfo *sectionInfo = [formPopulator nextSection];
    [sectionInfo addFieldEditInfo:[TextFieldEditInfo createForObject:newVariableValue 
             andKey:@"name" andLabel:LOCALIZED_STR(@"VARIABLE_VALUE_NAME_LABEL")]];
    [sectionInfo addFieldEditInfo:[NumberFieldEditInfo createForObject:newVariableValue 
             andKey:@"startingValue" andLabel:LOCALIZED_STR(@"VARIABLE_VALUE_START_DATE_FIELD_LABEL")
			 andNumberFormatter:self.varValRuntimeInfo.valueFormatter]];
    
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
