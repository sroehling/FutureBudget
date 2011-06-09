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

@implementation DateSensitiveValueFormInfoCreator

@synthesize defaultFixedVal;
@synthesize fieldInfo;
@synthesize varValRuntimeInfo;

- (id)initWithVariableValueFieldInfo:(ManagedObjectFieldInfo*)vvFieldInfo
                  andDefaultFixedVal:(FixedValue*)theDefaultFixedVal
				andVarValRuntimeInfo:(VariableValueRuntimeInfo *) theVarValRuntimeInfo
{
    self = [super init];
    if(self)
    {
        assert(vvFieldInfo != nil);
        self.fieldInfo = vvFieldInfo;
        
        assert(theDefaultFixedVal != nil);
        self.defaultFixedVal = theDefaultFixedVal;
        
		assert(theVarValRuntimeInfo != nil);
		self.varValRuntimeInfo = theVarValRuntimeInfo;
    }
    return self;
}


- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
    
    formPopulator.formInfo.title = @"Variable Value";
    
    assert(parentController != nil);
    SectionInfo *sectionInfo = [formPopulator nextSection];
    sectionInfo.title = @"Fixed Value";
    
    [sectionInfo addFieldEditInfo:[NumberFieldEditInfo 
            createForObject:self.defaultFixedVal andKey:@"value" andLabel:@"Value"
			andNumberFormatter:self.varValRuntimeInfo.valueFormatter]];
    
    VariableValueSectionInfo *vvSectionInfo = [[[VariableValueSectionInfo alloc]
						initWithVariableValueRuntimeInfo:self.varValRuntimeInfo ] autorelease];
    vvSectionInfo.title =  @"Variable Values";
    vvSectionInfo.parentViewController = parentController;
    sectionInfo = vvSectionInfo;
    [formPopulator nextCustomSection:sectionInfo];
    
    NSArray *variableValues = [[DataModelController theDataModelController]
     fetchSortedObjectsWithEntityName:self.varValRuntimeInfo.entityName sortKey:@"name"];
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
    [defaultFixedVal release];
    [fieldInfo release];
	[varValRuntimeInfo release];
}

@end