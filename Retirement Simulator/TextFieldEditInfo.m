//
//  TextFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextFieldEditInfo.h"
#import "TextFieldCell.h"
#import "ManagedObjectFieldInfo.h"
#import "ManagedObjectFieldEditInfo.h"
#import "StringValidation.h"


@implementation TextFieldEditInfo

@synthesize textCell;

+ (TextFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
							 andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder
{
    assert(obj != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
    
	
    ManagedObjectFieldInfo *fieldInfo = [[ManagedObjectFieldInfo alloc] 
        initWithManagedObject:obj andFieldKey:key andFieldLabel:label andFieldPlaceholder:placeholder];
    TextFieldEditInfo *fieldEditInfo = [[TextFieldEditInfo alloc] initWithFieldInfo:fieldInfo];
    [fieldEditInfo autorelease];
    [fieldInfo release];
    
    return fieldEditInfo;
}

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

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return 40.0;
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    assert(tableView!=nil);
    
    static NSString *TextCellIdentifier = @"TextFieldCell";
    
    TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:TextCellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
        cell = self.textCell;
		self.textCell = nil;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.editingAccessoryType = UITableViewCellAccessoryNone;

    cell.fieldEditInfo = self;
    cell.label.text = [self textLabel];

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
