//
//  InputFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputFieldEditInfo.h"
#import "FormFieldWithSubtitleTableCell.h"
#import "Input.h"
#import "InputListInputDescriptionCreator.h"
#import "DetailInputViewCreator.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "DataModelController.h"
#import "FormContext.h"


@implementation InputFieldEditInfo

@synthesize input;
@synthesize dataModelController;
@synthesize inputCell;

- (id)initWithInput:(Input*)theInput andDataModelController:(DataModelController*)theDataModelController
{
	self = [super init];
	if(self)
	{
		assert(theInput != nil);
		self.input = theInput;
		
		self.inputCell = 
		[[[FormFieldWithSubtitleTableCell alloc] initWithFrame:CGRectZero] autorelease];
		self.inputCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;   
		self.inputCell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;


		assert(theDataModelController != nil);
		self.dataModelController = theDataModelController;
	}
	return self;
}

- (id) init
{
	assert(0); // must not be called
	return nil;
}

- (void) dealloc
{
	[input release];
	[inputCell release];
	[dataModelController release];
	[super dealloc];
}



- (NSString*)detailTextLabel
{
	InputListInputDescriptionCreator *descriptionCreator = 
	[[[InputListInputDescriptionCreator alloc] initWithDataModelController:self.dataModelController] autorelease];
	
    return [descriptionCreator descripionForInput:self.input];
			
}

- (NSString*)textLabel
{
    return self.input.name;
}

- (UIViewController*)fieldEditController:(FormContext*)parentContext
{
    DetailInputViewCreator *detailViewCreator = [[[DetailInputViewCreator alloc]
					initWithInput:self.input andIsForNewObject:FALSE] autorelease];
    UIViewController *detailViewController = 
		[[[GenericFieldBasedTableEditViewController alloc] 
		  initWithFormInfoCreator:detailViewCreator
		  andDataModelController:parentContext.dataModelController] autorelease];
	return detailViewController;
}

- (void)configureInputCell
{
	self.inputCell.caption.text = [self textLabel];	
	self.inputCell.subTitle.text = [self detailTextLabel];
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	[self configureInputCell];
	return [self.inputCell cellHeightForWidth:width];
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    assert(tableView!=nil);
	
	[self configureInputCell]; 
	
	return self.inputCell;
}


- (BOOL)fieldIsInitializedInParentObject
{
    return TRUE;
}

- (void)disableFieldAccess
{
    // no-op
    // TBD - should this be a no-op
}

- (NSManagedObject*) managedObject
{
    return self.input;
}

-(BOOL)supportsDelete
{
	return TRUE;
}


- (void)deleteObject:(DataModelController*)dataModelController
{
	assert(self.input != nil);
	[self.dataModelController deleteObject:self.input];
	self.input = nil;
}

@end
