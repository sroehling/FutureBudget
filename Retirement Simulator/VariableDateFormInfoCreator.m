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
#import "VariableDateRuntimeInfo.h"
#import "FixedDate.h"
#import "SectionInfo.h"
#import "StringLookupTable.h"
#import "VariableHeightTableHeader.h"
#import "LocalizationHelper.h"


@implementation VariableDateFormInfoCreator

@synthesize fieldInfo;
@synthesize fixedDate;
@synthesize varDateRuntimeInfo;

- (id)initWithVariableDateFieldInfo:(ManagedObjectFieldInfo*)vdFieldInfo
			 andDefaultValFieldInfo:(ManagedObjectFieldInfo*)theDefaultFieldInfo
			  andVarDateRuntimeInfo:(VariableDateRuntimeInfo*)theVarDateRuntimeInfo;
{
    self = [super init];
    if(self)
    {
        assert(vdFieldInfo != nil);
        self.fieldInfo = vdFieldInfo;
		
		self.varDateRuntimeInfo = theVarDateRuntimeInfo;
        
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
    
	VariableHeightTableHeader *tableHeader = 
	[[[VariableHeightTableHeader alloc] initWithFrame:CGRectZero] autorelease];

	tableHeader.header.text = self.varDateRuntimeInfo.tableHeader;
	tableHeader.subHeader.text = self.varDateRuntimeInfo.tableSubHeader;
	[tableHeader resizeForChildren];
	formPopulator.formInfo.headerView = tableHeader;

	
    formPopulator.formInfo.title = self.varDateRuntimeInfo.tableTitle;
    
    assert(parentController != nil);
    SectionInfo *sectionInfo = [formPopulator nextSection];
	
    sectionInfo.title = LOCALIZED_STR(@"VARIABLE_DATE_FIXED_DATE_SECTION_TITLE");
	sectionInfo.subTitle = LOCALIZED_STR(@"VARIABLE_DATE_FIXED_DATE_SUBTITLE");
    [sectionInfo addFieldEditInfo:[DateFieldEditInfo createForObject:self.fixedDate 
                                    andKey:@"date" 
			andLabel:LOCALIZED_STR(@"VARIABLE_DATE_FIXED_DATE_TEXT_FIELD_LABEL")
			andPlaceholder:LOCALIZED_STR(@"VARIABLE_DATE_FIXED_DATE_PLACEHOLDER")]];
    
    MilestoneDateSectionInfo *mdSectionInfo = [[[MilestoneDateSectionInfo alloc] initWithRuntimeInfo:self.varDateRuntimeInfo] autorelease];
	
    mdSectionInfo.title =  LOCALIZED_STR(@"VARIABLE_DATE_MILESTONE_DATE_SECTION_TITLE");
	mdSectionInfo.subTitle = LOCALIZED_STR(@"VARIABLE_DATE_MILESTONE_DATE_SUBTITLE");
    mdSectionInfo.parentViewController = parentController;
    sectionInfo = mdSectionInfo;
    [formPopulator nextCustomSection:sectionInfo];
    
    NSArray *milestoneDates = [[DataModelController theDataModelController]
          fetchSortedObjectsWithEntityName:@"MilestoneDate" sortKey:@"name"];
    for (MilestoneDate *milestoneDate in milestoneDates)
    {
        // Create the row information for the given milestone date.
        [sectionInfo addFieldEditInfo:[MilestoneDateFieldEditInfo createForMilestoneDate:milestoneDate
									   andVarDateRuntimeInfo:self.varDateRuntimeInfo]];
    }
    return formPopulator.formInfo;
}

- (void) dealloc
{
    [super dealloc];
    [fieldInfo release];
    [fixedDate release];
	[varDateRuntimeInfo release];
}

@end
