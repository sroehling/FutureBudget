//
//  InputTagSelectionFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/15/13.
//
//

#import "InputTagSelectionFormInfoCreator.h"
#import "FormPopulator.h"
#import "Input.h"
#import "LocalizationHelper.h"
#import "FormContext.h"
#import "InputTag.h"
#import "DataModelController.h"
#import "InputTagSelectionFieldEditInfo.h"
#import "SectionInfo.h"
#import "FormContext.h"
#import "InputTagAdder.h"

@implementation InputTagSelectionFormInfoCreator

@synthesize inputBeingTagged;

-(id)initWithInput:(Input*)theInput
{
	self = [super init];
	if(self)
	{
		assert(theInput != nil);
		self.inputBeingTagged = theInput;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{

	FormPopulator *formPopulator = [[[FormPopulator alloc]
		initWithFormContext:parentContext] autorelease];
		
	NSString *tagsHeader = [NSString stringWithFormat:LOCALIZED_STR(@"INPUT_TAG_SELECT_TABLE_HEADER_FORMAT"),
		self.inputBeingTagged.name];
		
	[formPopulator populateWithHeader:tagsHeader andSubHeader:LOCALIZED_STR(@"INPUT_TAG_SELECT_TABLE_SUBHEADER")
		andHelpFile:@"inputTags" andParentController:parentContext.parentController ];

    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_TAGS_LIST_TITLE");
	
	formPopulator.formInfo.objectAdder = [[[InputTagAdder alloc] init] autorelease];
		
	[formPopulator nextSection];
		
	NSArray *inputTags = [parentContext.dataModelController fetchSortedObjectsWithEntityName:INPUT_TAG_ENTITY_NAME sortKey:INPUT_TAG_NAME_KEY];
	for(InputTag *inputTag in inputTags)
	{
		InputTagSelectionFieldEditInfo *inputTagSelFieldEditInfo =
			[[[InputTagSelectionFieldEditInfo alloc] initWithInput:self.inputBeingTagged andTag:inputTag] autorelease];
		[formPopulator.currentSection addFieldEditInfo:inputTagSelFieldEditInfo];
	
	}

	return formPopulator.formInfo;
}

-(void)dealloc
{
	[inputBeingTagged release];
	[super dealloc];
}


@end
