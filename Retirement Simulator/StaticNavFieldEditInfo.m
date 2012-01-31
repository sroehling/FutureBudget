//
//  StaticNavFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StaticNavFieldEditInfo.h"

#import "ValueSubtitleTableCell.h"
#import "FormInfoCreator.h"
#import "ColorHelper.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "FormFieldWithSubtitleTableCell.h"
#import "GenericTableViewFactory.h"
#import "GenericFieldBasedTableEditViewControllerFactory.h"
#import "DataModelController.h"
#import "GenericFieldBasedTableViewControllerFactory.h"

@implementation StaticNavFieldEditInfo

@synthesize valueCell;
@synthesize subViewFactory;
@synthesize objectForDelete;

- (id) initWithCaption:(NSString *)caption andSubtitle:(NSString *)subtitle 
		andContentDescription:(NSString*)contentDesc
		andSubViewFactory:(id<GenericTableViewFactory>)theSubViewFactory
{
	self = [super init];
	if(self)
	{
		
		self.valueCell = [[[FormFieldWithSubtitleTableCell alloc] initWithFrame:CGRectZero] autorelease];
		self.valueCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;   
		self.valueCell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;;

		assert(caption != nil);
		self.valueCell.caption.text = caption;
		
		self.valueCell.contentDescription.text = contentDesc;
		self.valueCell.subTitle.text = subtitle;
		
		assert(theSubViewFactory != nil);
		self.subViewFactory = theSubViewFactory;
		

	}
	return self;

}

- (id) initWithCaption:(NSString*)caption 
	andSubtitle:(NSString*)subtitle 
	andContentDescription:(NSString*)contentDesc
	andSubFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator
{
	id<GenericTableViewFactory> theSubViewFactory = [[[GenericFieldBasedTableEditViewControllerFactory alloc]
			initWithFormInfoCreator:theFormInfoCreator] autorelease];
	return [self initWithCaption:caption andSubtitle:subtitle 
		andContentDescription:contentDesc
		andSubViewFactory:theSubViewFactory];
}

-(id) initForReadOnlyViewWithCaption:(NSString*)caption 
	andSubtitle:(NSString*)subtitle 
	andContentDescription:(NSString*)contentDesc
	andSubFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator
{
	id<GenericTableViewFactory> theSubViewFactory = [[[GenericFieldBasedTableViewControllerFactory alloc]
			initWithFormInfoCreator:theFormInfoCreator] autorelease];
	return [self initWithCaption:caption andSubtitle:subtitle 
		andContentDescription:contentDesc
		andSubViewFactory:theSubViewFactory];
}


- (id) init
{
	assert(0); // must call init with caption, description, etc.
	return nil;
}

- (NSString*)textLabel
{
	return @"";
}


- (NSString*)detailTextLabel
{
	return @"";
}

- (UIViewController*)fieldEditController
{

	return [self.subViewFactory createTableView];	

}

- (BOOL)hasFieldEditController
{
    return TRUE;
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{

	return [self.valueCell cellHeightForWidth:width];
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    return self.valueCell;
}



- (BOOL)fieldIsInitializedInParentObject
{
    return TRUE;
}

- (void)disableFieldAccess
{
    // no-op
}

- (NSManagedObject*) managedObject
{
    return nil;
}


- (void)dealloc
{
	[super dealloc];
	[valueCell release];
	[subViewFactory release];
	[objectForDelete release];
}

-(BOOL)supportsDelete
{
	if(self.objectForDelete != nil)
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}


- (void)deleteObject
{
	assert(self.objectForDelete != nil);
	[[DataModelController theDataModelController] deleteObject:self.objectForDelete];
	self.objectForDelete = nil;
}

@end
