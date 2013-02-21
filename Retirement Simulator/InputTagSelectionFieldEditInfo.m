//
//  InputTagSelectionFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/15/13.
//
//

#import "InputTagSelectionFieldEditInfo.h"
#import "Input.h"
#import "DataModelController.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "InputTag.h"
#import "FormContext.h"
#import "InputTagFormInfoCreator.h"
#import "ValueSubtitleTableCell.h"

@implementation InputTagSelectionFieldEditInfo

@synthesize inputBeingTagged;

-(id)initWithInput:(Input*)theInput andTag:(InputTag*)theTag
{
	self = [super initWithTag:theTag];
	if(self)
	{
		self.inputBeingTagged = theInput;
	}
	return self;
}

-(void)dealloc
{
	[inputBeingTagged release];
	[super dealloc];
}  


- (BOOL)isSelected
{
	return [inputBeingTagged.tags containsObject:self.inputTag];
}

- (void)updateSelection:(BOOL)isSelected
{

	if(isSelected)
	{
		[self.inputBeingTagged addTagsObject:self.inputTag];
	}
	else
	{
		[self.inputBeingTagged removeTagsObject:self.inputTag];
	}
}


@end
