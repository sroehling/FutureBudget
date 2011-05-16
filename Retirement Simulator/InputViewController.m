//
//  InputViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputViewController.h"
#import "DataModelController.h"

#import "OneTimeExpenseInput.h"
#import "OneTimeExpenseViewController.h"
#import "EventRepeatFrequency.h"

#import "ManagedObjectFieldInfo.h"
#import "TextFieldEditInfo.h"
#import "NumberFieldEditInfo.h"
#import "DateFieldEditInfo.h"
#import "RepeatFrequencyFieldEditInfo.h"
#import "GenericFieldBasedTableEditViewController.h"

@interface InputViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation InputViewController


@synthesize fetchedResultsController=__fetchedResultsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [__fetchedResultsController release];
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
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]   
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd   
                                  target:self   
                                  action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton; 
    [addButton release];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Inserting data implementation

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[managedObject valueForKey:@"name"] description];
}

- (void)insertNewObject
{
    // Create a new instance of the entity managed by the fetched results controller.
 
	OneTimeExpenseInput *newInput  = (OneTimeExpenseInput*)[NSEntityDescription insertNewObjectForEntityForName:            @"OneTimeExpenseInput" 
        inManagedObjectContext:[[DataModelController theDataModelController] managedObjectContext]];
    newInput.name = @"Testing 1,2,3";
    newInput.inputType = @"Expense";
    newInput.amount = [NSNumber numberWithInt:2000];
    newInput.transactionDate = [NSDate date];
    
    NSArray *repeatFrequencies = [[DataModelController theDataModelController] fetchSortedObjectsWithEntityName:@"EventRepeatFrequency" sortKey:@"period"];
    assert([repeatFrequencies count] >0);
    
    newInput.repeatFrequency = (EventRepeatFrequency *)[repeatFrequencies objectAtIndex:0];
    NSLog(@"New Input with Repeat Frequency: %@",newInput.repeatFrequency.description);
 
    [[DataModelController theDataModelController] saveContext];
}


#pragma mark - Table view data implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// Display the input type as section headings.
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        [[DataModelController theDataModelController]saveContext];
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    // Create and push a detail view controller.
    
    
    
    OneTimeExpenseInput *selectedInput = (OneTimeExpenseInput *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    // Pass the selected book to the new view controller.
     NSLog(@"input = %@",[selectedInput description]);
    
    NSMutableArray *detailFieldEditInfo = [[NSMutableArray alloc] init ];
    
    ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc] 
         initWithManagedObject:selectedInput andFieldKey:@"name" andFieldLabel:@"Input Name"] autorelease];
    [detailFieldEditInfo addObject:[[[TextFieldEditInfo alloc] initWithFieldInfo:fieldInfo] autorelease]];

    fieldInfo = [[[ManagedObjectFieldInfo alloc] 
         initWithManagedObject:selectedInput andFieldKey:@"amount" andFieldLabel:@"Amount"] autorelease];
    [detailFieldEditInfo addObject:[[[NumberFieldEditInfo alloc] initWithFieldInfo:fieldInfo] autorelease]];

    fieldInfo = [[[ManagedObjectFieldInfo alloc] 
        initWithManagedObject:selectedInput andFieldKey:@"transactionDate" andFieldLabel:@"Date"] autorelease];
    [detailFieldEditInfo addObject:[[[DateFieldEditInfo alloc] initWithFieldInfo:fieldInfo] autorelease]];
    
    fieldInfo = [[[ManagedObjectFieldInfo alloc] 
        initWithManagedObject:selectedInput andFieldKey:@"repeatFrequency" andFieldLabel:@"Repeat"] autorelease];
    [detailFieldEditInfo addObject:[[[RepeatFrequencyFieldEditInfo alloc] initWithFieldInfo:fieldInfo] autorelease]];
    
    GenericFieldBasedTableEditViewController *inputDetailViewController = 
    [[[GenericFieldBasedTableEditViewController alloc] initWithFieldEditInfo:detailFieldEditInfo] autorelease];
   

	[self.navigationController pushViewController:inputDetailViewController animated:YES];
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    // Create the fetch request for the entity.
    
    NSFetchRequest *fetchRequest = [[DataModelController theDataModelController] 
                      createSortedFetchRequestWithEntityName:@"Input" andSortKey:@"name"];
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[DataModelController theDataModelController] managedObjectContext] sectionNameKeyPath:@"inputType" cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
	    /*
	     TODO - Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    


#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellAccessoryDisclosureIndicator;
}


@end
