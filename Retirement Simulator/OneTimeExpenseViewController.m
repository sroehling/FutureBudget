//
//  OneTimeExpenseViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OneTimeExpenseViewController.h"
#import "OneTimeExpenseInput.h"
#import "DateFieldEditViewController.h"
#import "TextFieldEditViewController.h"
#import "NumberFieldEditViewController.h"
#import "RepeatFrequencyEditViewController.h"
#import "EventRepeatFrequency.h"


@implementation OneTimeExpenseViewController

@synthesize expense, dateFormatter, numberFormatter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Expense";

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    // Redisplay the data - notably, this is invoked when returning 
    // from an editor for one of the field values,
    // causing the display of these values to refresh if changed.
    [self.tableView reloadData];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 1 section
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 3 rows
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	switch (indexPath.row) {
        case 0: 
			cell.textLabel.text = @"Title";
			cell.detailTextLabel.text = expense.name;
			break;
        case 1: 
			cell.textLabel.text = @"Amount";
			cell.detailTextLabel.text = [self.numberFormatter stringFromNumber:self.expense.amount];
			break;
        case 2:
			cell.textLabel.text = @"Date";
			cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.expense.transactionDate];
			break;
        case 3:
			cell.textLabel.text = @"Repeat";
			cell.detailTextLabel.text = self.expense.repeatFrequency.description;
			break;
    }
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only allow selection if editing.
  //  return (self.editing) ? indexPath : nil;
    return indexPath;
}

/**
 Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
//	if (!self.editing) return;
	
    switch (indexPath.row) {
        case 0: {
            TextFieldEditViewController *nameEditController = 
                [[TextFieldEditViewController alloc] initWithNibName:@"TextFieldEditViewController" bundle:nil];
            nameEditController.editedObject = self.expense;
            nameEditController.editedFieldKey = @"name";
            nameEditController.editedFieldName = @"Input Name";
            [self.navigationController 
             pushViewController:nameEditController animated:YES];
            [nameEditController release];
        } break;
        case 1: {
            NumberFieldEditViewController *amountEditController = 
            [[NumberFieldEditViewController alloc] initWithNibName:@"NumberFieldEditViewController" bundle:nil];
            amountEditController.editedObject = self.expense;
            amountEditController.editedFieldKey = @"amount";
            amountEditController.editedFieldName = @"Amount";
            [self.navigationController 
             pushViewController:amountEditController animated:YES];
            [amountEditController release];
        } break;
        case 2: {
            DateFieldEditViewController *dateController = 
            [[DateFieldEditViewController alloc] initWithNibName:@"DateFieldEditViewController" bundle:nil];
            dateController.editedObject = self.expense;
            dateController.editedFieldKey = @"transactionDate";
            dateController.editedFieldName = @"Date";
            [self.navigationController 
                pushViewController:dateController animated:YES];
            [dateController release];
        } break;
        case 3: {
            RepeatFrequencyEditViewController *repeatController = 
            [[RepeatFrequencyEditViewController alloc] initWithNibName:@"RepeatFrequencyEditViewController" bundle:nil];
            repeatController.expenseInput = self.expense;
            [self.navigationController 
             pushViewController:repeatController animated:YES];
            [repeatController release];
        } break;

    }
	     
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellAccessoryDetailDisclosureButton;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

#pragma mark -
#pragma Formatters


- (NSNumberFormatter *)numberFormatter
{
    if (numberFormatter == nil)
    {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    return numberFormatter;
}

- (NSDateFormatter *)dateFormatter {	
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
	return dateFormatter;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [numberFormatter release];
    [dateFormatter release];
    [expense release];
    [super dealloc];
}



@end
