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
#import "RelativeEndDateFieldEditInfo.h"
#import "RelativeEndDate.h"


@implementation SimDateFormInfoCreator

@synthesize fieldInfo;
@synthesize defaultRelEndDateFieldInfo;
@synthesize fixedDateFieldInfo;
@synthesize varDateRuntimeInfo;

- (id)initWithVariableDateFieldInfo:(FieldInfo*)vdFieldInfo 
             andDefaultValFieldInfo:(FieldInfo*)theDefaultFieldInfo
			 andVarDateRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo
			 andDoShowEndDates:(bool)doShowEndDates
			 andDefaultRelEndDateFieldInfo:(FieldInfo*)theDefaultRelEndDateFieldInfo;
{
    self = [super init];
    if(self)
    {
        assert(vdFieldInfo != nil);
        self.fieldInfo = vdFieldInfo;
		
		self.varDateRuntimeInfo = theVarDateRuntimeInfo;
		self.fixedDateFieldInfo = theDefaultFieldInfo;
		showEndDates = doShowEndDates;
		if(showEndDates)
		{
			assert(theDefaultRelEndDateFieldInfo != nil);
		}
		self.defaultRelEndDateFieldInfo = theDefaultRelEndDateFieldInfo;

    }
    return self;
}

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
   FormPopulator *formPopulator = [[[FormPopulator alloc] initWithParentController:parentController] autorelease];
    
	VariableHeightTableHeader *tableHeader = 
	[[[VariableHeightTableHeader alloc] initWithFrame:CGRectZero] autorelease];

	tableHeader.header.text = self.varDateRuntimeInfo.tableHeader;
	tableHeader.subHeader.text = self.varDateRuntimeInfo.tableSubHeader;
	[tableHeader resizeForChildren];
	formPopulator.formInfo.headerView = tableHeader;

	
    formPopulator.formInfo.title = self.varDateRuntimeInfo.tableTitle;
    
    assert(parentController != nil);
	
	SectionInfo *sectionInfo;
	
	if(showEndDates)
	{
	
		if(self.varDateRuntimeInfo.supportsNeverEndDate)
		{
			sectionInfo = [formPopulator nextSectionWithTitle:self.varDateRuntimeInfo.neverEndDateSectionTitle 
				andHelpFile:self.varDateRuntimeInfo.neverEndDateHelpFile];

			NeverEndDate *neverEndDate = [SharedAppValues singleton].sharedNeverEndDate;
			assert(neverEndDate != nil);
			StaticFieldEditInfo *neverEndingFieldEditInfo = 
				[[[StaticFieldEditInfo alloc] initWithManagedObj:neverEndDate 
				andCaption:@"" andContent:self.varDateRuntimeInfo.neverEndDateFieldCaption] autorelease];
			[sectionInfo addFieldEditInfo:neverEndingFieldEditInfo];
		}
		
		sectionInfo = [formPopulator nextSectionWithTitle:self.varDateRuntimeInfo.relEndDateSectionTitle 
				andHelpFile:self.varDateRuntimeInfo.relEndDateHelpFile];


		RelativeEndDateFieldEditInfo *relEndDateFieldEditInfo =
			[[[RelativeEndDateFieldEditInfo alloc] 
			initWithRelativeEndDateFieldInfo:self.defaultRelEndDateFieldInfo andSimDateRuntimeInfo:self.varDateRuntimeInfo] autorelease];
		[sectionInfo addFieldEditInfo:relEndDateFieldEditInfo];
	}	
	
    sectionInfo = [formPopulator nextSectionWithTitle:LOCALIZED_STR(@"VARIABLE_DATE_FIXED_DATE_SECTION_TITLE")
			andHelpFile:@"fixedDate"];
		
	DateFieldEditInfo *fixedDateFieldEditInfo = 
		[[[DateFieldEditInfo alloc] initWithFieldInfo:self.fixedDateFieldInfo] autorelease];
	[sectionInfo addFieldEditInfo:fixedDateFieldEditInfo];
	
    MilestoneDateSectionInfo *mdSectionInfo = [[[MilestoneDateSectionInfo alloc] initWithRuntimeInfo:self.varDateRuntimeInfo
		andParentController:parentController] autorelease];
	
	
    mdSectionInfo.parentViewController = parentController;
    sectionInfo = mdSectionInfo;
    [formPopulator nextCustomSection:sectionInfo];
    
    NSArray *milestoneDates = [[DataModelController theDataModelController]
          fetchSortedObjectsWithEntityName:MILESTONE_DATE_ENTITY_NAME sortKey:@"name"];
    for (MilestoneDate *milestoneDate in milestoneDates)
    {
	
		MilestoneDateFieldEditInfo *mdFieldEditInfo  = [[[MilestoneDateFieldEditInfo alloc]
			initWithMilestoneDate:milestoneDate andVarDateRuntimeInfo:self.varDateRuntimeInfo
			andParentController:parentController] autorelease];
        // Create the row information for the given milestone date.
        [sectionInfo addFieldEditInfo:mdFieldEditInfo];
    }
    return formPopulator.formInfo;
}

- (void) dealloc
{
    [super dealloc];
    [fieldInfo release];
    [fixedDateFieldInfo release];
	[varDateRuntimeInfo release];
	[defaultRelEndDateFieldInfo release];
}

@end
