//
//  InputTagFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/15/13.
//
//

#import "InputTagFormInfoCreator.h"
#import "FormPopulator.h"
#import "LocalizationHelper.h"
#import "InputTagNameFieldValidator.h"
#import "FormContext.h"
#import "InputTag.h"

@implementation InputTagFormInfoCreator

@synthesize inputTag;

-(id)initWithTag:(InputTag*)theTag
{
	self = [super init];
	if(self)
	{
		self.inputTag = theTag;
	}
	return self;
}

-(void)dealloc
{
	[inputTag release];
	[super dealloc];
}

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{

	FormPopulator *formPopulator = [[[FormPopulator alloc]
		initWithFormContext:parentContext] autorelease];

    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_TAG_TITLE");
	
	[formPopulator nextSection];
	
	InputTagNameFieldValidator *nameValidator =
		[[[InputTagNameFieldValidator alloc] initWithTag:self.inputTag
		andDmc:parentContext.dataModelController] autorelease];
	
	[formPopulator populateNameFieldInParentObj:self.inputTag withNameField:INPUT_TAG_NAME_KEY andPlaceholder:LOCALIZED_STR(@"INPUT_TAG_NAME_PLACEHOLDER") andMaxLength:INPUT_TAG_NAME_MAX_LENGTH
		andCustomValidator:nameValidator];
	
	[formPopulator populateNoteFieldInParentObj:self.inputTag withNameField:INPUT_TAG_NOTES_KEY andFieldTitle:LOCALIZED_STR(@"INPUT_TAG_NOTES_FIELD_LABEL")
		andPlaceholder:LOCALIZED_STR(@"INPUT_TAG_NOTES_PLACEHOLDER")];
			
		

	return formPopulator.formInfo;
}


@end
