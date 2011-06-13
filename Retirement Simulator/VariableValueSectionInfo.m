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
	
    formPopulator.formInfo.title = [[[NSString alloc] initWithFormat:@"Variable %@",
									 self.varValRuntimeInfo.valueTitle] autorelease];
    
    VariableValue *newVariableValue = (VariableValue*)[[DataModelController theDataModelController]
					insertObject:self.varValRuntimeInfo.entityName];
    // The following properties must be filled in before the new objectwill be created.
    //    newVariableValue.name
    //    newVariableValue.startingValue
    [[DataModelController theDataModelController] saveContext];

    
    SectionInfo *sectionInfo = [formPopulator nextSection];
    [sectionInfo addFieldEditInfo:[TextFieldEditInfo createForObject:newVariableValue 
             andKey:@"name" andLabel:@"Name"]];
    [sectionInfo addFieldEditInfo:[NumberFieldEditInfo createForObject:newVariableValue 
             andKey:@"startingValue" andLabel:@"Starting Value"
			 andNumberFormatter:self.varValRuntimeInfo.valueFormatter]];
    
    GenericFieldBasedTableAddViewController *controller = 
        [[[GenericFieldBasedTableAddViewController alloc]
          initWithFormInfoCreator:[StaticFormInfoCreator createWithFormInfo:formPopulator.formInfo]
          andNewObject:newVariableValue] autorelease];
    controller.popDepth =1;

    
    [self.parentViewController.navigationController pushViewController:controller animated:YES];
    
}

- (void)dealloc
{
    [super dealloc];
    [varValRuntimeInfo release];
}

@end
