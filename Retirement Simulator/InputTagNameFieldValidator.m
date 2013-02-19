//
//  InputTagNameFieldValidator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/15/13.
//
//

#import "InputTagNameFieldValidator.h"
#import "InputTag.h"
#import "CoreDataHelper.h"
#import "LocalizationHelper.h"
#import "DataModelController.h"

@implementation InputTagNameFieldValidator

@synthesize inputTag;
@synthesize dmcForTagList;

-(void)dealloc
{
	[inputTag release];
	[dmcForTagList release];
	[super dealloc];
}


-(id)initWithTag:(InputTag*)theTag andDmc:(DataModelController*)theDmcForTagList
{
	self = [super initWithValidationMsg:LOCALIZED_STR(@"INPUT_TAG_NAME_VALIDATION_MSG")];
	if(self)
	{
		self.inputTag = theTag;
		self.dmcForTagList = theDmcForTagList;
		
	}
	return self;
}

-(id)initWithValidationMsg:(NSString *)validationMsg
{
	assert(0);
	return nil;
}


-(BOOL)validateText:(NSString *)theText
{
	if(theText.length == 0)
	{
		return FALSE;
	}


	NSMutableDictionary *tagsByName = [[[NSMutableDictionary alloc] init] autorelease];
	NSArray *inputTags = [self.dmcForTagList
		fetchSortedObjectsWithEntityName:INPUT_TAG_ENTITY_NAME sortKey:INPUT_TAG_NAME_KEY];
	for(InputTag *tag in inputTags)
	{
		if(![CoreDataHelper sameCoreDataObjects:tag comparedTo:self.inputTag])
		{
			[tagsByName setObject:tag forKey:tag.tagName];
		}
	}
	
	
	
	InputTag *existingTag = [tagsByName objectForKey:theText];
	if(existingTag != nil)
	{
		// If there's an existing tag with the same name, only validate if 
		// it's the same one as the one being edited.
		if([CoreDataHelper sameCoreDataObjects:existingTag comparedTo:self.inputTag])
		{
			return TRUE;
		}
		else 
		{
			return FALSE;
		}
	}
	else 
	{
		return TRUE;
	}
}



@end
