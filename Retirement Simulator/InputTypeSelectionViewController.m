//
//  InputTypeSelectionViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputTypeSelectionViewController.h"
#import "InputTypeSelectionInfo.h"
#import "LocalizationHelper.h"
#import "Input.h"
#import "DetailInputViewCreator.h"
#import "TableViewHelper.h"
#import "GenericFieldBasedTableAddViewController.h"
#import "UIHelper.h"
#import "DataModelController.h"
#import "TableCellHelper.h"
#import "InputCreationHelper.h"
#import "SharedAppValues.h"

@implementation InputTypeSelectionViewController

@synthesize inputTypes;
@synthesize dmcForNewInputs;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// TODO replace with system cancel button (or localize the cancel string)
    UIBarButtonItem *cancelButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)] autorelease];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;

    
    // Do any additional setup after loading the view from its nib.
    self.title = LOCALIZED_STR(@"INPUT_TYPE_VIEW_TITLE");

    self.inputTypes = [[[NSMutableArray alloc] init ] autorelease];
	
	// Initialize dmcForNewInputs to a new DataModelController, so changes associated with
	// the new object are kept isolated from other changes, and can
	// be saved all at once when the new input has been fully populated
	// and validated.
	self.dmcForNewInputs = [[[DataModelController alloc] init] autorelease];
		
	InputCreationHelper *inputCreationHelper =
		[[[InputCreationHelper alloc] 
		initWithDataModelInterface:dmcForNewInputs andSharedAppVals:
			[SharedAppValues getUsingDataModelController:self.dmcForNewInputs]]
		autorelease];
    
    InputTypeSelectionInfo *typeInfo = [[[IncomeInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:inputCreationHelper 
		andDataModelInterface:dmcForNewInputs ] autorelease];
    typeInfo.description = LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_INCOME_TITLE");
    [self.inputTypes addObject:typeInfo];
    
    typeInfo = [[[ExpenseInputTypeSelectionInfo alloc] 
		initWithInputCreationHelper:inputCreationHelper 
		andDataModelInterface:dmcForNewInputs ] autorelease];
    typeInfo.description = LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_EXPENSE_TITLE");
    [self.inputTypes addObject:typeInfo];
	
	typeInfo = [[[SavingsAccountTypeSelectionInfo alloc]
		initWithInputCreationHelper:inputCreationHelper 
		andDataModelInterface:dmcForNewInputs ] autorelease];
    typeInfo.description = 	LOCALIZED_STR(@"INPUT_ACCOUNT_TITLE");
    [self.inputTypes addObject:typeInfo];


	typeInfo = [[[LoanInputTypeSelctionInfo alloc]
		initWithInputCreationHelper:inputCreationHelper 
		andDataModelInterface:dmcForNewInputs ] autorelease];
	typeInfo.description = LOCALIZED_STR(@"INPUT_LOAN_TITLE");
	[self.inputTypes addObject:typeInfo];
    
	typeInfo = [[[AssetInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:inputCreationHelper 
		andDataModelInterface:dmcForNewInputs ] autorelease];
	typeInfo.description = LOCALIZED_STR(@"INPUT_ASSET_TITLE");
	[self.inputTypes addObject:typeInfo];


	typeInfo = [[[TaxInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:inputCreationHelper 
		andDataModelInterface:dmcForNewInputs ] autorelease];
	typeInfo.description = LOCALIZED_STR(@"INPUT_TAX_TITLE");
	[self.inputTypes addObject:typeInfo];

	[UIHelper setCommonBackgroundForTable:self];

    typeSelected = FALSE;


}

- (void)setTitle:(NSString *)title
{
	[super setTitle:title];
	[UIHelper setCommonTitleForTable:self withTitle:title];
}



- (IBAction)cancel
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)dealloc
{
    [inputTypes release];
	[dmcForNewInputs release];
     [super dealloc];
   
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Number of rows is the number of recipe types
    return [self.inputTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
    }
    
    // Configure the cell
	InputTypeSelectionInfo *typeInfo = (InputTypeSelectionInfo*)
        [self.inputTypes objectAtIndex:indexPath.row];
    assert(typeInfo != nil);
    assert([typeInfo.description length] > 0);
    cell.textLabel.text = typeInfo.description;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:TABLE_CELL_LABEL_FONT_SIZE];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Update the current frequency
    InputTypeSelectionInfo *typeInfo = [self.inputTypes objectAtIndex:indexPath.row];
    assert(typeInfo!=nil);
    
    Input *newInput = [typeInfo createInput]; // create the managed (core data) object for the given input
    
	// TODO - Need to initialize with a standalone DataModelController, so that changes
	// for the new objects can be done in isolation.
    DetailInputViewCreator *detailViewCreator = [[[DetailInputViewCreator alloc] 
                        initWithInput:newInput andIsForNewObject:TRUE] autorelease];
    
	// Create a new data model controller for the inputs. This keeps any un-validated
	// additions isolated w.r.t. other changes.
    
    GenericFieldBasedTableAddViewController *addView =  [[[GenericFieldBasedTableAddViewController alloc] 
        initWithFormInfoCreator:detailViewCreator andNewObject:newInput
		andDataModelController:self.dmcForNewInputs] autorelease];
	addView.disableCoreDataSaveUntilSaveButtonPressed = TRUE;

    assert(addView != nil);
    
    typeSelected = TRUE;
    
	[self.navigationController pushViewController:addView animated:YES];  
    
}

@end
