//
//  NumberFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NumberFieldEditInfo.h"
#import "NumberFieldEditViewController.h"
#import "NumberFieldCell.h"
#import "StringValidation.h"


@implementation NumberFieldEditInfo


@synthesize numberFormatter;

@synthesize numberCell;


+ (NumberFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
                             andLabel:(NSString*)label
{
    assert(obj != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
    
    ManagedObjectFieldInfo *fieldInfo = [[ManagedObjectFieldInfo alloc] 
                                         initWithManagedObject:obj andFieldKey:key andFieldLabel:label];
    NumberFieldEditInfo *fieldEditInfo = [[NumberFieldEditInfo alloc] initWithFieldInfo:fieldInfo];
    [fieldEditInfo autorelease];
    [fieldInfo release];
    
    return fieldEditInfo;
}

- (NSString*)detailTextLabel
{
    return [self.numberFormatter stringFromNumber:[self.fieldInfo getFieldValue]];
    
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


- (NSNumberFormatter *)numberFormatter
{
    if (numberFormatter == nil)
    {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    return numberFormatter;
}

- (void)dealloc {
    [super dealloc];
    [numberFormatter release];
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    
    assert(tableView!=nil);
    static NSString *NumberCellIdentifier = @"NumberFieldCell";
    
    NumberFieldCell *cell = (NumberFieldCell *)[tableView dequeueReusableCellWithIdentifier:NumberCellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"NumberFieldCell" owner:self options:nil];
        cell = self.numberCell;
		self.numberCell = nil;
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

    cell.textField.placeholder = @"Enter a Value";
    
    return cell;
    
}



@end
