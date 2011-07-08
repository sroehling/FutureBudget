//
//  VariableDateFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimDateFormInfoCreator.h"
#import "DataModelController.h"
#import "MilestoneDate.h"
#import "FormPopulator.h"
#import "DateFieldEditInfo.h"
#import "MilestoneDateFieldEditInfo.h"
#import "MilestoneDateSectionInfo.h"
#import "SimDateRuntimeInfo.h"
#import "FixedDate.h"
#import "SectionInfo.h"
#import "StringLookupTable.h"
#import "VariableHeightTableHeader.h"
#import "LocalizationHelper.h"
#import "StaticFieldEditInfo.h"
#import "SharedAppValues.h"
#import "NeverEndDate.h"
#import "FieldInfo.h"


@implementation SimDateFormInfoCreator

@synthesize fieldInfo;
@synthesize fixedDateFieldInfo;
@synthesize varDateRuntimeInfo;

- (id)initWithVariableDateFieldInfo:(FieldInfo*)vdFieldInfo
			 andDefaultValFieldInfo:(FieldInfo*)theDefaultFieldInfo
			  andVarDateRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo
			  andDoShowNeverEnding:(bool)doShowNeverEnding;
{
    self = [super init];
    if(self)
    {
        assert(vdFieldInfo != nil);
        self.fieldInfo = vdFieldInfo;
		
		self.varDateRuntimeInfo = theVarDateRuntimeInfo;
		self.fixedDateFieldInfo = theDefaultFieldInfo;
		showNeverEnding = doShowNeverEnding;

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
	
	SectionInfo *sectionInfo;
	
	if(showNeverEnding)
	{
		sectionInfo = [formPopulator nextSection];
	
		sectionInfo.title = LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_SECTION_TITLE");
		sectionInfo.subTitle = LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_SECTION_SUBTITLE");
	
		NeverEndDate *neverEndDate = [DataModelController theDataModelController].sharedAppVals.sharedNeverEndDate;
		StaticFieldEditInfo *neverEndingFieldEditInfo = 
			[[[StaticFieldEditInfo alloc] initWithManagedObj:neverEndDate 
			andCaption:@"" andContent:LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_LABEL")] autorelease];
		[sectionInfo addFieldEditInfo:neverEndingFieldEditInfo];
	}
	
	
    sectionInfo = [formPopulator nextSection];
	
    sectionInfo.title = LOCALIZED_STR(@"VARIABLE_DATE_FIXED_DATE_SECTION_TITLE");
	sectionInfo.subTitle = LOCALIZED_STR(@"VARIABLE_DATE_FIXED_DATE_SUBTITLE");
	
	DateFieldEditInfo *fixedDateFieldEditInfo = 
		[[[DateFieldEditInfo alloc] initWithFieldInfo:self.fixedDateFieldInfo] autorelease];
	[sectionInfo addFieldEditInfo:fixedDateFieldEditInfo];
    MilestoneDateSectionInfo *mdSectionInfo = [[[MilestoneDateSectionInfo alloc] initWithRuntimeInfo:self.varDateRuntimeInfo] autorelease];
	
    mdSectionInfo.title =  LOCALIZED_STR(@"VARIABLE_DATE_MILESTONE_DATE_SECTION_TITLE");
	mdSectionInfo.subTitle = LOCALIZED_STR(@"VARIABLE_DATE_MILESTONE_DATE_SUBTITLE");
    mdSectionInfo.parentViewController = parentController;
    sectionInfo = mdSectionInfo;
    [formPopulator nextCustomSection:sectionInfo];
    
    NSArray *milestoneDates = [[DataModelController theDataModelController]
          fetchSortedObjectsWithEntityName:MILESTONE_DATE_ENTITY_NAME sortKey:@"name"];
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
    [fixedDateFieldInfo release];
	[varDateRuntimeInfo release];
}

@end