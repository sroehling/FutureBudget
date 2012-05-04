//
//  TransferEndpointSelectionFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransferEndpointSelectionFieldEditInfo.h"
#import "TransferEndpoint.h"
#import "FormFieldWithSubtitleTableCell.h"

@implementation TransferEndpointSelectionFieldEditInfo

@synthesize endpointCell;
@synthesize transferEndpoint;

-(id)initWithTransferEndpoint:(TransferEndpoint*)theTransferEndpoint
{
	self = [super init];
	if(self)
	{
		assert(theTransferEndpoint != nil);
		self.transferEndpoint = theTransferEndpoint;
		
		
		self.endpointCell = [[[FormFieldWithSubtitleTableCell alloc] initWithFrame:CGRectZero] autorelease];

	}
	return self;
}


- (BOOL)isSelected
{
	return self.transferEndpoint.isSelectedForSelectableObjectTableView;
}

- (void)updateSelection:(BOOL)isSelected
{
	self.transferEndpoint.isSelectedForSelectableObjectTableView = isSelected;
}


- (void) dealloc
{
	[transferEndpoint release];
	[endpointCell release];
	[super dealloc];
}


- (NSString*)detailTextLabel
{
    return @"";
}

- (NSString*)textLabel
{
    return [self.transferEndpoint endpointLabel];
}

- (void)configureEndpointCell
{
	self.endpointCell.caption.text = [self textLabel];	
	self.endpointCell.subTitle.text = [self detailTextLabel];
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	[self configureEndpointCell];
	return [self.endpointCell cellHeightForWidth:width];
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    assert(tableView!=nil);
	
	[self configureEndpointCell]; 
	
	return self.endpointCell;
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
    return self.transferEndpoint;
}

-(BOOL)supportsDelete
{
	return FALSE;
}




@end
