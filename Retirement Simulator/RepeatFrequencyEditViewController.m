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
#import "OneTimeExpenseInput.h"

// TBD - Can this class be made into a generic "Core Data object Checklist" controller?


@implementation RepeatFrequencyEditViewController


@synthesize expenseInput;
@synthesize repeatFrequencies;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [repeatFrequencies release];
    [expenseInput release];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.repeatFrequencies = [[DataModelController theDataModelController]
                              fetchSortedObjectsWithEntityName:@"EventRepeatFrequency" sortKey:@"period"];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    
    if (repeatFrequency == expenseInput.repeatFrequency) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Unset the accessory view for its cell.
	EventRepeatFrequency *currentRepeatFrequency = expenseInput.repeatFrequency;
    assert(currentRepeatFrequency != nil);
    NSInteger index = [repeatFrequencies indexOfObject:currentRepeatFrequency];
    NSIndexPath *selectionIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:selectionIndexPath];
    checkedCell.accessoryType = UITableViewCellAccessoryNone;
	
    
    // Set the checkmark accessory for the selected row.
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];    
    
    // Update the type of the recipe instance
    expenseInput.repeatFrequency = [repeatFrequencies objectAtIndex:indexPath.row];
    
    [[DataModelController theDataModelController] saveContext];
    
    // Deselect the row.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
