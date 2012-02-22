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
#import "NeverEndDateFieldEditInfo.h"
#import "SharedAppValues.h"
#import "NeverEndDate.h"
#import "FieldInfo.h"
#import "RelativeEndDateFieldEditInfo.h"
#import "RelativeEndDate.h"
#import "FormContext.h"


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

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
   FormPopulator *formPopulator = [[[FormPopulator alloc] 
				initWithFormContext:parentContext] autorelease];
    
	VariableHeightTableHeader *tableHeader = 
	[[[VariableHeightTableHeader alloc] initWithFrame:CGRectZero] autorelease];

	tableHeader.header.text = self.varDateRuntimeInfo.tableHeader;
	tableHeader.subHeader.text = self.varDateRuntimeInfo.tableSubHeader;
	[tableHeader resizeForChildren];
	formPopulator.formInfo.headerView = tableHeader;

	
    formPopulator.formInfo.title = self.varDateRuntimeInfo.tableTitle;
    
	SectionInfo *sectionInfo;
	
	if(showEndDates)
	{
	
		if(self.varDateRuntimeInfo.supportsNeverEndDate)
		{
			sectionInfo = [formPopulator nextSectionWithTitle:self.varDateRuntimeInfo.neverEndDateSectionTitle 
				andHelpFile:self.varDateRuntimeInfo.neverEndDateHelpFile];

			NeverEndDate *neverEndDate = 
				[SharedAppValues getUsingDataModelController:parentContext.dataModelController].sharedNeverEndDate;
			assert(neverEndDate != nil);
			NeverEndDateFieldEditInfo *neverEndingFieldEditInfo = 
				[[[NeverEndDateFieldEditInfo alloc] initWithNeverEndDate:neverEndDate 
				andContent:self.varDateRuntimeInfo.neverEndDateFieldCaption] autorelease];
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
		
	// Setup fixedDateFieldEditInfo as the default selection, so that when a date field is initially
	// edited, it will be selected as the default.
	DateFieldEditInfo *fixedDateFieldEditInfo = 
		[[[DateFieldEditInfo alloc] initWithFieldInfo:self.fixedDateFieldInfo] autorelease];
	fixedDateFieldEditInfo.isDefaultSelection = TRUE;
	[sectionInfo addFieldEditInfo:fixedDateFieldEditInfo];

	
    MilestoneDateSectionInfo *mdSectionInfo = [[[MilestoneDateSectionInfo alloc] initWithRuntimeInfo:self.varDateRuntimeInfo
		andFormContext:parentContext] autorelease];
	
    sectionInfo = mdSectionInfo;
    [formPopulator nextCustomSection:sectionInfo];
    
    NSArray *milestoneDates = [parentContext.dataModelController
          fetchSortedObjectsWithEntityName:MILESTONE_DATE_ENTITY_NAME sortKey:@"name"];
    for (MilestoneDate *milestoneDate in milestoneDates)
    {
	
		MilestoneDateFieldEditInfo *mdFieldEditInfo  = [[[MilestoneDateFieldEditInfo alloc]
			initWithMilestoneDate:milestoneDate andVarDateRuntimeInfo:self.varDateRuntimeInfo
			andParentController:parentContext.parentController] autorelease];
        // Create the row information for the given milestone date.
        [sectionInfo addFieldEditInfo:mdFieldEditInfo];
    }
    return formPopulator.formInfo;
}

- (void) dealloc
{
    [fieldInfo release];
    [fixedDateFieldInfo release];
	[varDateRuntimeInfo release];
	[defaultRelEndDateFieldInfo release];
    [super dealloc];
}

@end
