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
@synthesize inputTag;

-(id)initWithInput:(Input*)theInput andTag:(InputTag*)theTag
{
	self = [super initWithManagedObj:theTag 
		andCaption:theTag.tagName andContent:@""];
	if(self)
	{
		self.inputTag = theTag;
		self.inputBeingTagged = theInput;
		self.staticCell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	return self;
}



-(id)initWithManagedObj:(NSManagedObject *)theFieldObj andCaption:(NSString *)theCaption 
	andContent:(NSString *)theContent
{
	assert(0);
	return nil;
}


-(void)dealloc
{
	[inputTag release];
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


- (UIViewController*)fieldEditController:(FormContext*)parentContext
{

	InputTagFormInfoCreator *tagFormInfoCreator =
		[[[InputTagFormInfoCreator alloc] initWithTag:self.inputTag] autorelease];
	
	GenericFieldBasedTableEditViewController *editView =
		[[[GenericFieldBasedTableEditViewController alloc] initWithFormInfoCreator:tagFormInfoCreator
		andDataModelController:parentContext.dataModelController] autorelease];
		
	return editView;

}


-(BOOL)supportsDelete
{
	return TRUE;
}


-(void)deleteObject:(DataModelController*)dataModelController
{
	assert([self supportsDelete]);
	[dataModelController deleteObject:self.inputTag];
	self.inputTag = nil;
}

@end
