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

@implementation StaticNavFieldEditInfo

@synthesize valueCell;
@synthesize formInfoCreator;

- (id) initWithCaption:(NSString*)caption 
	andSubtitle:(NSString*)subtitle 
	andSubFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator
{
	self = [super init];
	if(self)
	{
		assert(caption != nil);
		
		self.valueCell = [[[FormFieldWithSubtitleTableCell alloc] initWithFrame:CGRectZero] autorelease];
		self.valueCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;   
		self.valueCell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;;

		self.valueCell.caption.text = caption;
		
		if(subtitle != nil)
		{
			self.valueCell.subTitle.text = subtitle;
		}
		
		assert(theFormInfoCreator != nil);
		self.formInfoCreator = theFormInfoCreator;

	}
	return self;
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

	UIViewController *controller = [[[GenericFieldBasedTableEditViewController alloc]
	    initWithFormInfoCreator:self.formInfoCreator] autorelease];
	return controller;	

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
	[formInfoCreator release];
}

@end
