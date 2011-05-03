//
//  OneTimeExpenseViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OneTimeExpenseViewController.h"
#import "OneTimeExpenseInput.h"


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
    return 3;
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
    }
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only allow selection if editing.
    return (self.editing) ? indexPath : nil;
}

/**
 Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (!self.editing) return;
	
    /*
    EditingViewController *controller = [[EditingViewController alloc] initWithNibName:@"EditingView" bundle:nil];
    
    controller.editedObject = book;
    switch (indexPath.row) {
        case 0: {
            controller.editedFieldKey = @"title";
            controller.editedFieldName = NSLocalizedString(@"title", @"display name for title");
            controller.editingDate = NO;
        } break;
        case 1: {
            controller.editedFieldKey = @"author";
			controller.editedFieldName = NSLocalizedString(@"author", @"display name for author");
			controller.editingDate = NO;
        } break;
        case 2: {
            controller.editedFieldKey = @"copyright";
			controller.editedFieldName = NSLocalizedString(@"copyright", @"display name for copyright");
			controller.editingDate = YES;
        } break;
    }
	
    [self.navigationController pushViewController:controller animated:YES];
	[controller release];

*/     
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
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
