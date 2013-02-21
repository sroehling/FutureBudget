//
//  InputListTableViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/20/13.
//
//

#import "InputListTableViewController.h"
#import "InputListFormInfoCreator.h"
#import "InputListFilterTagSelectionFormInfoCreator.h"
#import "MultipleSelectionTableViewController.h"
#import "ColorHelper.h"

@implementation InputListTableViewController

@synthesize inputListFormInfoCreator;

-(void)dealloc
{
	[inputListFormInfoCreator release];
	[super dealloc];
}

-(id)initWithDataModelController:(DataModelController*)theDataModelController
{
	InputListFormInfoCreator *theInputListFormInfoCreator = [[[InputListFormInfoCreator alloc] init] autorelease];

	self = [super initWithFormInfoCreator:theInputListFormInfoCreator andDataModelController:theDataModelController];
	if (self) {
	
		self.inputListFormInfoCreator = theInputListFormInfoCreator;
		self.inputListFormInfoCreator.headerDelegate = self;
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	assert(0);
}

-(void)inputFilterTagEditDone
{
	NSLog(@"Done editing input filter");
	// If thew view is re-appearing after showing the list of tags to show, then
	// the header displaying the tags list needs to be refreshed/reconfigured
	// and the header and table view need to be layed out again.
	[self.inputListFormInfoCreator configureHeader:self.dataModelController];
	[self.tableViewWrapper setNeedsLayout];

    [self.navigationController dismissViewControllerAnimated:TRUE completion:nil];

}

- (void)inputListHeaderFilterTagsButtonPressed
{
	NSLog(@"Input Filter button pressed - view controller");
	
	InputListFilterTagSelectionFormInfoCreator *filterTagFormInfoCreator =
		[[[InputListFilterTagSelectionFormInfoCreator alloc] init] autorelease];
	
	MultipleSelectionTableViewController *tagSelectionController =
		[[[MultipleSelectionTableViewController alloc]
		initWithFormInfoCreator:filterTagFormInfoCreator
			andDataModelController:self.dataModelController] autorelease];
	tagSelectionController.supportsEditing = TRUE;
	
	
	UINavigationController *navController = [[[UINavigationController alloc]
		initWithRootViewController:tagSelectionController] autorelease];
	navController.navigationBar.tintColor = [ColorHelper navBarTintColor];
	
	UIBarButtonItem *tagFilterEditDoneButton = [[[UIBarButtonItem alloc] 
		initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
		target:self action:@selector(inputFilterTagEditDone)] autorelease];
	
	tagSelectionController.navigationItem.leftBarButtonItem = tagFilterEditDoneButton;
	tagSelectionController.defaultLeftButtonItem = tagFilterEditDoneButton;

	navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

    [self.navigationController presentViewController:navController animated:TRUE completion:nil];		
}


@end
