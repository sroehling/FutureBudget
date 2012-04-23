//
//  RepeatFrequencyEditViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RepeatFrequencyEditViewController.h"
#import "DataModelController.h"
#import "EventRepeatFrequency.h"
#import "ManagedObjectFieldInfo.h"
#import "UIHelper.h"

// TBD - Can this class be made into a generic "Core Data object Checklist" controller?


@implementation RepeatFrequencyEditViewController


@synthesize repeatFrequencies,currentFrequency;

-(void)viewDidLoad
{
	[super viewDidLoad];
	
	[UIHelper setCommonBackgroundForTable:self];

}

- (void)setTitle:(NSString *)title
{
	[super setTitle:title];
	[UIHelper setCommonTitleForController:self withTitle:title];
}


- (void) commidFieldEdit
{
    assert(currentFrequency!=nil);
    [fieldInfo setFieldValue:currentFrequency]; 
}

- (void) initFieldUI
{
    self.repeatFrequencies = [self.dataModelController
                              fetchSortedObjectsWithEntityName:EVENT_REPEAT_FREQUENCY_ENTITY_NAME sortKey:@"period"];    
    self.currentFrequency = [self.fieldInfo getFieldValue];
}



- (void)dealloc
{
    [repeatFrequencies release];
    [currentFrequency release];
    [super dealloc];
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Number of rows is the number of recipe types
    return [repeatFrequencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
    }
    
    // Configure the cell
	EventRepeatFrequency *repeatFrequency = [repeatFrequencies objectAtIndex:indexPath.row];
    cell.textLabel.text = [repeatFrequency description];
    
    if (repeatFrequency == currentFrequency) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Unset the accessory view for its cell.
    assert(currentFrequency!=nil);

    NSInteger index = [repeatFrequencies indexOfObject:currentFrequency];
    NSIndexPath *selectionIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:selectionIndexPath];
    checkedCell.accessoryType = UITableViewCellAccessoryNone;
	
    
    // Set the checkmark accessory for the selected row.
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];    
    
    // Update the current frequency
    self.currentFrequency = [repeatFrequencies objectAtIndex:indexPath.row];
    assert(currentFrequency!=nil);
    
    // Deselect the row.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
