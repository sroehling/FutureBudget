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
#import "TextFieldEditInfo.h"
#import "NumberFieldEditInfo.h"
#import "DateSensitiveValueChange.h"
#import "VariableValueRuntimeInfo.h"
#import "DateSensitiveValueChangeFieldEditInfo.h"
#import "VariableValue.h"
#import "AddObjectSectionInfo.h"
#import "CollectionHelper.h"
#import "DateSensitiveValueChangeSectionInfo.h"


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
	FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
    
    formPopulator.formInfo.title = @"Variable Date";
    
    assert(parentController != nil);
    SectionInfo *sectionInfo = [formPopulator nextSection];
	[sectionInfo addFieldEditInfo:[TextFieldEditInfo createForObject:self.variableValue 
															 andKey:@"name" andLabel:@"Name"]];
	
	sectionInfo = [formPopulator nextSection];
    sectionInfo.title = [NSString stringWithFormat:@"Starting %@",self.varValRuntimeInfo.valueTitle];
	sectionInfo.subTitle = @"This value is used from the start of the simulation until"
		" either the end of your plan or the date upon which a value change occurs.",
	[sectionInfo addFieldEditInfo:[NumberFieldEditInfo createForObject:self.variableValue
			andKey:@"startingValue" andLabel:@"Starting" 
			andNumberFormatter:self.varValRuntimeInfo.valueFormatter]];
	
	
	NSArray *valueChanges = [CollectionHelper setToSortedArray:
						  self.variableValue.valueChanges withKey:@"startDate"];
	DateSensitiveValueChangeSectionInfo *vcSectionInfo = 
		[[[DateSensitiveValueChangeSectionInfo alloc] 
		  initWithVariableValRuntimeInfo:self.varValRuntimeInfo andParentVariableValue:self.variableValue] autorelease];
    vcSectionInfo.title =  [NSString stringWithFormat:@"%@ Changes",self.varValRuntimeInfo.valueTitle];
	vcSectionInfo.subTitle = @"These are changes to the value, which occur after the starting value.";
    vcSectionInfo.parentViewController = parentController;
	[formPopulator nextCustomSection:vcSectionInfo];		
    for (DateSensitiveValueChange *valueChange in valueChanges)
    {
        // Create the row information for the given milestone date.
		DateSensitiveValueChangeFieldEditInfo *fieldInfo = 
			[[[DateSensitiveValueChangeFieldEditInfo alloc]
			  initWithValueChange:valueChange andVariableValueRuntimeInfo:self.varValRuntimeInfo ] autorelease];
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
