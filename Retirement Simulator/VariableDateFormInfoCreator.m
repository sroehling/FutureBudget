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
    
	
    formPopulator.formInfo.title = [NSString stringWithFormat:@"%@ Date",self.fieldInfo.fieldLabel];
    
    assert(parentController != nil);
    SectionInfo *sectionInfo = [formPopulator nextSection];
    sectionInfo.title = @"Fixed Date";
	sectionInfo.subTitle = @"This date is for the current input only. If this date is selected, changing this date only impacts results for the current input.",
    [sectionInfo addFieldEditInfo:[DateFieldEditInfo createForObject:self.fixedDate 
                                    andKey:@"date" andLabel:@"Date"]];
    
    MilestoneDateSectionInfo *mdSectionInfo = [[[MilestoneDateSectionInfo alloc] init ] autorelease];
    mdSectionInfo.title =  @"Milestone Date";
	mdSectionInfo.subTitle = @"These dates can be shared by multiple inputs. Changes to a milestone date will impact the results for inputs which have also selected the same milestone date.";
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
