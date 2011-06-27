//
//  DateSensitiveValueChangeSectionInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValueChangeSectionInfo.h"
#import "DateSensitiveValueChange.h"
#import "DataModelController.h"
#import "DateSensitiveValueChangeFormPopulator.h"
#import "FixedDate.h"

@implementation DateSensitiveValueChangeSectionInfo

@synthesize variableValRuntimeInfo;
@synthesize variableVal;

- (id) initWithVariableValRuntimeInfo:(VariableValueRuntimeInfo*)valRuntimeInfo
	andParentVariableValue:(VariableValue*)varValue
{
	self = [super init];
	if(self)
	{
		assert(valRuntimeInfo != nil);
		self.variableValRuntimeInfo = valRuntimeInfo;
		
		assert(varValue != nil);
		self.variableVal = varValue;
	}
	return self;
}

- (id) init
{
	assert(0); // should not be called
	return nil;
}

- (void) dealloc
{
	[super dealloc];
	[variableValRuntimeInfo release];
	[variableVal release];
}

- (void)addObjectButtonPressed
{
    assert(self.parentViewController != nil);
    NSLog(@"Add value change");
    
	DateSensitiveValueChange *valueChange = (DateSensitiveValueChange*)
		[[DataModelController theDataModelController]insertObject:DATE_SENSITIVE_VALUE_CHANGE_ENTITY_NAME];
	FixedDate *fixedStartDate = (FixedDate*)[[
		DataModelController theDataModelController] insertObject:FIXED_DATE_ENTITY_NAME];
    fixedStartDate.date = [NSDate date];
    valueChange.defaultFixedStartDate = fixedStartDate;

	
    DateSensitiveValueChangeFormPopulator *formPopulator = [[[DateSensitiveValueChangeFormPopulator alloc] init] autorelease];
	
	
    UIViewController *controller =  [formPopulator addViewControllerForValueChange:valueChange andVariableValRuntimeInfo:self.variableValRuntimeInfo andParentVariableValue:self.variableVal];
    
    [self.parentViewController.navigationController pushViewController:controller animated:YES];
}

@end
