//
//  FieldEditTableViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FieldEditTableViewController.h"
#import "DataModelController.h"


@implementation FieldEditTableViewController

@synthesize fieldInfo;
@synthesize dataModelController;

- (id) initWithFieldInfo:(FieldInfo*)theFieldInfo
	andDataModelController:(DataModelController*)theDataModelController
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self)
    {
        assert(theFieldInfo != nil);
        self.fieldInfo = theFieldInfo;
		
		assert(theDataModelController != nil);
		self.dataModelController = theDataModelController;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.title = fieldInfo.fieldLabel;
    
	// Configure the save and cancel buttons.
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
    
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	// Configure the user interface according to state.
    [self initFieldUI];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)save {
	
	// TODO: Set the action name for the undo operation.
    //	NSUndoManager * undoManager = [[editedObject managedObjectContext] undoManager];
    //	[undoManager setActionName:[NSString stringWithFormat:@"%@", editedFieldName]];
	
    [self commidFieldEdit];
	
	// It is important to save *before* popping the view controller, since the 
	// parent controller may need to refresh its results and those results
	// need to be up to date.
	[self.dataModelController saveContextAndIgnoreErrors];
	    
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)cancel {
    // Don't pass current value to the edited object, just pop.
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc {
    [fieldInfo release];
	[dataModelController release];
	[super dealloc];
}

- (void)initFieldUI
{
    // Should be overridden
    assert(0);
}

- (void) commidFieldEdit
{
    // Should be overridden
    assert(0);
}

@end
