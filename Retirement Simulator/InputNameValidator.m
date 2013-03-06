//
//  InputNameValidator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 3/6/13.
//
//

#import "InputNameValidator.h"

#import "CoreDataHelper.h"
#import "DataModelController.h"
#import "Input.h"
#import "LocalizationHelper.h"

@implementation InputNameValidator

@synthesize currentInput;
@synthesize otherInputNames;

-(void)dealloc
{
	[currentInput release];
	[otherInputNames release];
	[super dealloc];
}

-(id)initWithInput:(Input *)theCurrentInput andDataModelController:(DataModelController*)theDmc
{
	self = [super initWithValidationMsg:LOCALIZED_STR(@"INPUT_NAME_VALIDATION_MSG")];
	if(self)
	{
		assert(theCurrentInput != nil);
		self.currentInput = theCurrentInput;
		
		self.otherInputNames = [[[NSMutableSet alloc] init] autorelease];
		NSSet *allInputs = [theDmc fetchObjectsForEntityName:INPUT_ENTITY_NAME];
		for(Input *input in allInputs)
		{
			if(![CoreDataHelper sameCoreDataObjects:self.currentInput comparedTo:input])
			{
				[self.otherInputNames addObject:input.name];
			}
		}
		
		
	}
	return self;
}

-(BOOL)validateText:(NSString *)theText
{
	if(theText.length == 0)
	{
		return FALSE;
	}

	if([self.otherInputNames member:theText])
	{
		return FALSE;
	}
	
	return TRUE;
}


@end
