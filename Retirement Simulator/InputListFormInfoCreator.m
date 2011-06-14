//
//  InputListFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputListFormInfoCreator.h"
#import "FormPopulator.h"
#import "Input.h"
#import "DataModelController.h"
#import "InputFieldEditInfo.h"
#import "SectionInfo.h"
#import "InputListObjectAdder.h"

@implementation InputListFormInfoCreator

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
    
    formPopulator.formInfo.title = @"Inputs";
	formPopulator.formInfo.objectAdder = [[[InputListObjectAdder alloc] init] autorelease];
	
	SectionInfo *sectionInfo = [formPopulator nextSection];

	NSArray *inputs = [[DataModelController theDataModelController]
								   fetchSortedObjectsWithEntityName:@"Input" sortKey:@"name"];
	for (Input *input in inputs)
	{
		// Create the row information for the given milestone date.
		InputFieldEditInfo *inputFieldEditInfo =
			[[[InputFieldEditInfo alloc] initWithInput:input] autorelease];
		[sectionInfo addFieldEditInfo:inputFieldEditInfo];
	}
	return formPopulator.formInfo;
	
}

@end
