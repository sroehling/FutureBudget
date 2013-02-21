//
//  InputListFilterTagSelectionFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/20/13.
//
//

#import "InputListFilterTagSelectionFormInfoCreator.h"
#import "FormPopulator.h"
#import "LocalizationHelper.h"
#import "FormContext.h"
#import "FormInfo.h"
#import "InputTagAdder.h"
#import "InputTag.h"
#import "SharedAppValues.h"
#import "SectionInfo.h"
#import "FilteredTagFieldEditInfo.h"

@implementation InputListFilterTagSelectionFormInfoCreator

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{

	FormPopulator *formPopulator = [[[FormPopulator alloc]
		initWithFormContext:parentContext] autorelease];
				
	[formPopulator populateWithHeader:LOCALIZED_STR(@"INPUT_LIST_TAG_FILTER_TABLE_HEADER")
		andSubHeader:LOCALIZED_STR(@"INPUT_LIST_TAG_FILTER_TABLE_SUBHEADER")
		andHelpFile:@"inputTags" andParentController:parentContext.parentController ];

    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_TAGS_LIST_TITLE");
	
	formPopulator.formInfo.objectAdder = [[[InputTagAdder alloc] init] autorelease];
		
	[formPopulator nextSection];

	SharedAppValues *sharedAppVals = [SharedAppValues
		getUsingDataModelController:parentContext.dataModelController];

		
	NSArray *inputTags = [parentContext.dataModelController
		fetchSortedObjectsWithEntityName:INPUT_TAG_ENTITY_NAME sortKey:INPUT_TAG_NAME_KEY];
	for(InputTag *inputTag in inputTags)
	{
		FilteredTagFieldEditInfo *filteredTagFieldEditInfo =
			[[[FilteredTagFieldEditInfo alloc] initWithSharedAppVals:sharedAppVals andInputTag:inputTag] autorelease];
		[formPopulator.currentSection addFieldEditInfo:filteredTagFieldEditInfo];
	}

	return formPopulator.formInfo;
}

-(void)dealloc
{
	[super dealloc];
}


@end
