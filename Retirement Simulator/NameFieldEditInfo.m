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
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return 30.0;
}


- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    
    assert(tableView!=nil);
    
    NameFieldCell *cell = (NameFieldCell *)[tableView 
		dequeueReusableCellWithIdentifier:NAME_FIELD_CELL_IDENTIFIER];
    if (cell == nil) {
		cell = [[[NameFieldCell alloc] init] autorelease];
    }    
    cell.fieldInfo = self.fieldInfo;
    
    // Only try to initialize the text in the field if the field's
    // value has been initialized in the parent object. If it hasn't,
    // the text field will be left blank and the placeholder value
    // will be shown.
    if([self.fieldInfo fieldIsInitializedInParentObject])
    {
        cell.textField.text = [self detailTextLabel];
    }

    cell.textField.placeholder = self.fieldInfo.fieldPlaceholder;
    
    return cell;
    
}


@end
