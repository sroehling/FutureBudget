//
//  NameFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NameFieldEditInfo.h"
#import "NameFieldCell.h"


@implementation NameFieldEditInfo

@synthesize cell;

- (NSString*)detailTextLabel
{
    return [self.fieldInfo getFieldValue];
}


- (UIViewController*)fieldEditController
{
    assert(0);
    return nil;
    
}

- (BOOL)hasFieldEditController
{
    return FALSE;
}

- (void)dealloc {
    [super dealloc];
	[cell release];
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return 30.0;
}


- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    
    assert(tableView!=nil);
    
	if(self.cell == nil)
	{
		NameFieldCell *theCell = (NameFieldCell *)[tableView 
			dequeueReusableCellWithIdentifier:NAME_FIELD_CELL_IDENTIFIER];
		if (theCell == nil) {
			theCell = [[[NameFieldCell alloc] init] autorelease];
		}    
		theCell.fieldInfo = self.fieldInfo;
		self.cell = theCell;
	}
    
    // Only try to initialize the text in the field if the field's
    // value has been initialized in the parent object. If it hasn't,
    // the text field will be left blank and the placeholder value
    // will be shown.
    if([self.fieldInfo fieldIsInitializedInParentObject])
    {
        self.cell.textField.text = [self detailTextLabel];
    }

	self.cell.disabled = FALSE;
    self.cell.textField.placeholder = self.fieldInfo.fieldPlaceholder;
    
    return self.cell;
    
}


-(void)disableFieldAccess
{
	[super disableFieldAccess];
	if(self.cell != nil)
	{
		self.cell.disabled = TRUE;
	}	
}


@end
