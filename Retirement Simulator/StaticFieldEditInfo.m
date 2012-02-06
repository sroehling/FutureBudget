//
//  StaticFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StaticFieldEditInfo.h"
#import "ValueSubtitleTableCell.h"


@implementation StaticFieldEditInfo

@synthesize staticCell;
@synthesize fieldObj;
@synthesize caption;
@synthesize content;

- (void) configureCell
{
	self.staticCell.caption.text = self.caption;
    self.staticCell.valueDescription.text = self.content;
	self.staticCell.editingAccessoryType = UITableViewCellAccessoryNone;
	self.staticCell.accessoryType = UITableViewCellAccessoryNone;
}

- (id)initWithManagedObj:(NSManagedObject*)theFieldObj andCaption:(NSString*)theCaption 
	andContent:(NSString*)theContent
{
    assert(theFieldObj != nil);
    self = [super init];
    if(self)
    {
        self.fieldObj = theFieldObj;
		self.caption = theCaption;
		self.content = theContent;
				
		self.staticCell = [[[ValueSubtitleTableCell alloc] init] autorelease];
		[self configureCell];
    }
    return self;
}

- (id) init
{
	assert(0); // must call init above
	return nil;
}


- (void) dealloc
{
    [super dealloc];
    [fieldObj release];
	[staticCell release];
	[content release];
	[caption release];
}

- (NSString*)detailTextLabel
{
    return @"Detail";
}

- (NSString*)textLabel
{
    return @"Text";
}

- (UIViewController*)fieldEditController
{
    assert(0); // should not be called
	return nil;
}

- (BOOL)hasFieldEditController
{
    return FALSE;
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return [self.staticCell cellHeight];
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    assert(tableView!=nil);
    [self configureCell];
    return self.staticCell;
}


- (BOOL)fieldIsInitializedInParentObject
{
    return FALSE;
}

- (void)disableFieldAccess
{
    // no-op
    // TBD - should this be a no-op
}

- (NSManagedObject*) managedObject
{
    return self.fieldObj;
}





@end
