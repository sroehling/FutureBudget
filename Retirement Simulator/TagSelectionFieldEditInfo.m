//
//  TagSelectionFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/20/13.
//
//

#import "TagSelectionFieldEditInfo.h"
#import "Input.h"
#import "DataModelController.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "InputTag.h"
#import "FormContext.h"
#import "InputTagFormInfoCreator.h"
#import "ValueSubtitleTableCell.h"


@implementation TagSelectionFieldEditInfo

@synthesize inputTag;

-(void)dealloc
{
	[inputTag release];
	[super dealloc];
}  


-(id)initWithTag:(InputTag*)theTag
{
	self = [super initWithManagedObj:theTag 
		andCaption:theTag.tagName andContent:@""];
	if(self)
	{
		self.inputTag = theTag;
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




- (BOOL)isSelected
{
	assert(0); // must be overriden
	return FALSE;
}

- (void)updateSelection:(BOOL)isSelected
{
	assert(0); // must be overridden
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
