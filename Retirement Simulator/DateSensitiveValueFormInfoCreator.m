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
@synthesize varValueEntityName;

- (id)initWithVariableValueFieldInfo:(ManagedObjectFieldInfo*)vvFieldInfo
             andDefaultFixedVal:(FixedValue*)theDefaultFixedVal
               andVarValueEntityName:(NSString*)entityName
{
    self = [super init];
    if(self)
    {
        assert(vvFieldInfo != nil);
        self.fieldInfo = vvFieldInfo;
        
        assert(theDefaultFixedVal != nil);
        self.defaultFixedVal = theDefaultFixedVal;
        
        assert([StringValidation nonEmptyString:entityName]);
        self.varValueEntityName = entityName;
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
    
    [sectionInfo addFieldEditInfo:[NumberFieldEditInfo createForObject:self.defaultFixedVal andKey:@"value" andLabel:@"Value"]];
    
    VariableValueSectionInfo *vvSectionInfo = [[[VariableValueSectionInfo alloc] init ] autorelease];
    vvSectionInfo.title =  @"Variable Values";
    vvSectionInfo.parentViewController = parentController;
    vvSectionInfo.varValueEntityName = self.varValueEntityName;
    sectionInfo = vvSectionInfo;
    [formPopulator nextCustomSection:sectionInfo];
    
    NSArray *variableValues = [[DataModelController theDataModelController]
     fetchSortedObjectsWithEntityName:self.varValueEntityName sortKey:@"name"];
    for (VariableValue *varValue in variableValues)
    {
        VariableValueFieldEditInfo *vvFieldInfo = [[[VariableValueFieldEditInfo alloc]initWithVariableValue:varValue] autorelease];
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
}

@end
