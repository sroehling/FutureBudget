//
//  TransferEndpointFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransferEndpointFieldEditInfo.h"

#import "ValueSubtitleTableCell.h"
#import "ColorHelper.h"
#import "LocalizationHelper.h"
#import "SelectableObjectTableEditViewController.h"
#import "GenericFieldBasedTableViewController.h"
#import "FormContext.h"
#import "ManagedObjectFieldInfo.h"
#import "MultiLevelSelectionViewController.h"
#import "TransferEndpointSelectionFormInfoCreator.h"
#import "TransferInput.h"
#import "TransferEndpoint.h"
#import "SelectableObjectTableEditViewController.h"

@implementation TransferEndpointFieldEditInfo

@synthesize valueCell;
@synthesize endpointFieldInfo;

- (NSString*)textLabel
{
	return @"";
}

- (NSString*)detailTextLabel
{
	return @"";
}

- (void) configureValueCell
{
	self.valueCell.caption.text = self.endpointFieldInfo.fieldLabel;
    if([self.fieldInfo fieldIsInitializedInParentObject])
    {
        self.valueCell.valueDescription.textColor = [ColorHelper blueTableTextColor];
		TransferEndpoint *theEndPoint = (TransferEndpoint*)[self.fieldInfo getFieldValue];
        self.valueCell.valueDescription.text = [theEndPoint endpointLabel];
		self.valueCell.valueSubtitle.text = @"";
    }
    else
    {
        // Set the text color on the label to light gray to indicate that
        // the value needs to be filled in (the same as a placeholder
        // in a text field).
        self.valueCell.valueDescription.textColor = [ColorHelper promptTextColor];
        self.valueCell.valueDescription.text = self.fieldInfo.fieldPlaceholder;
        self.valueCell.valueSubtitle.text = @"";
    }
	
}

- (id)initWithManagedObjFieldInfo:(ManagedObjectFieldInfo *)theFieldInfo
{
	self = [super initWithFieldInfo:theFieldInfo];
	if(self)
	{
		self.endpointFieldInfo = theFieldInfo;		
		
		self.valueCell = [[[ValueSubtitleTableCell alloc] init] autorelease];
		self.valueCell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.valueCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	}
	return self;
}

- (id) initWithFieldInfo:(FieldInfo *)theFieldInfo
{
    assert(0); // should not be called
}

- (id) init
{
    assert(0); // should not be called
}

- (UIViewController*)fieldEditController:(FormContext*)parentContext
{    
    TransferEndpointSelectionFormInfoCreator *xferFormInfoCreator = 
		[[[TransferEndpointSelectionFormInfoCreator alloc]
		initWithTitle:self.endpointFieldInfo.fieldLabel] autorelease];
		
		
	// Need to use a new field info for the assignment, because self.fieldInfo will
	// be disabled to deactivate validation when first responders are resigned.
	ManagedObjectFieldInfo *assignmentFieldInfo = [[[ManagedObjectFieldInfo alloc] 
		initWithManagedObject:self.endpointFieldInfo.managedObject 
		andFieldKey:self.endpointFieldInfo.fieldKey
		andFieldLabel:self.endpointFieldInfo.fieldLabel
		andFieldPlaceholder:@"N/A"] autorelease];
	
	 SelectableObjectTableEditViewController *selectTransferEndpointFieldController = 
            [[[SelectableObjectTableEditViewController alloc] 
			initWithFormInfoCreator:xferFormInfoCreator 
                  andAssignedField:assignmentFieldInfo
				  andDataModelController:parentContext.dataModelController] autorelease];
	selectTransferEndpointFieldController.closeAfterSelection = TRUE;

    return selectTransferEndpointFieldController;
}


- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	[self configureValueCell];
	return [self.valueCell cellHeight];
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
	[self configureValueCell];
    return self.valueCell;
}


-(void)dealloc
{
	[valueCell release];
	[endpointFieldInfo release];
	[super dealloc];
}



@end
