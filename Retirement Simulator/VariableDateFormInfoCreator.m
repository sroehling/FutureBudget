//
//  VariableDateFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableDateFormInfoCreator.h"
#import "DataModelController.h"
#import "MilestoneDate.h"
#import "FormPopulator.h"
#import "DateFieldEditInfo.h"
#import "MilestoneDateFieldEditInfo.h"
#import "MilestoneDateSectionInfo.h"
#import "FixedDate.h"
#import "SectionInfo.h"


@implementation VariableDateFormInfoCreator

@synthesize fieldInfo;
@synthesize fixedDate;

- (FixedDate*)tmpFixedDate
{
    FixedDate *tmpDate = (FixedDate*)[[DataModelController theDataModelController] 
                                           insertObject:@"FixedDate"];
    tmpDate.date = [[NSDate alloc] init];
    return tmpDate;
}

- (id)initWithVariableDateFieldInfo:(ManagedObjectFieldInfo*)vdFieldInfo
    andDefaultValFieldInfo:(ManagedObjectFieldInfo*)theDefaultFieldInfo
{
    self = [super init];
    if(self)
    {
        assert(vdFieldInfo != nil);
        self.fieldInfo = vdFieldInfo;
        
        if([self.fieldInfo fieldIsInitializedInParentObject])
        {
            VariableDate *vdFromField = [self.fieldInfo getFieldValue];
            if([vdFromField isKindOfClass:[FixedDate class]])
            {
                self.fixedDate = (FixedDate*)vdFromField;
            }           
            else
            {
                self.fixedDate = (FixedDate*)[theDefaultFieldInfo getFieldValue];
            }
        }
                
        else
        {
            self.fixedDate = (FixedDate*)[theDefaultFieldInfo getFieldValue];
        }

    }
    return self;
}

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
   FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
    
    formPopulator.formInfo.title = @"Variable Date";
    
    assert(parentController != nil);
    SectionInfo *sectionInfo = [formPopulator nextSection];
    sectionInfo.title = @"Fixed Date";
    [sectionInfo addFieldEditInfo:[DateFieldEditInfo createForObject:self.fixedDate 
                                    andKey:@"date" andLabel:@"Date"]];
    
    MilestoneDateSectionInfo *mdSectionInfo = [[[MilestoneDateSectionInfo alloc] init ] autorelease];
    mdSectionInfo.title =  @"Milestone Date";
    mdSectionInfo.parentViewController = parentController;
    sectionInfo = mdSectionInfo;
    [formPopulator nextCustomSection:sectionInfo];
    
    NSArray *milestoneDates = [[DataModelController theDataModelController]
          fetchSortedObjectsWithEntityName:@"MilestoneDate" sortKey:@"name"];
    for (MilestoneDate *milestoneDate in milestoneDates)
    {
        // Create the row information for the given milestone date.
        [sectionInfo addFieldEditInfo:[MilestoneDateFieldEditInfo createForMilestoneDate:milestoneDate]];
    }
    return formPopulator.formInfo;
}

- (void) dealloc
{
    [super dealloc];
    [fieldInfo release];
    [fixedDate release];
}

@end
