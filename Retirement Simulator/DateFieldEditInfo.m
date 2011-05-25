//
//  DateFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateFieldEditInfo.h"
#import "DateFieldEditViewController.h"
#import "TableViewHelper.h"
#import "StringValidation.h"


@implementation DateFieldEditInfo

@synthesize dateFormatter;


+ (DateFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
                             andLabel:(NSString*)label
{
    assert(obj != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
    
    ManagedObjectFieldInfo *fieldInfo = [[ManagedObjectFieldInfo alloc] 
                                         initWithManagedObject:obj andFieldKey:key andFieldLabel:label];
    DateFieldEditInfo *fieldEditInfo = [[DateFieldEditInfo alloc] initWithFieldInfo:fieldInfo];
    [fieldEditInfo autorelease];
    [fieldInfo release];
    
    return fieldEditInfo;
}


- (NSString*)detailTextLabel
{
    return [self.dateFormatter stringFromDate:[self.fieldInfo getFieldValue]];
}

- (UIViewController*)fieldEditController
{
    DateFieldEditViewController *dateController = 
        [[DateFieldEditViewController alloc] initWithNibName:@"DateFieldEditViewController"
                                                andFieldInfo:fieldInfo];
    [dateController autorelease];
    return dateController;

}

- (NSDateFormatter *)dateFormatter {	
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
	return dateFormatter;
}

- (void)dealloc {
    [super dealloc];
    [dateFormatter release];
}

- (BOOL)hasFieldEditController
{
    return TRUE;
}


- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    assert(tableView!=nil);
    UITableViewCell *cell = [TableViewHelper reuseOrAllocCell:tableView];
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self textLabel];
    cell.detailTextLabel.text = [self detailTextLabel];
    return cell;
}

@end
