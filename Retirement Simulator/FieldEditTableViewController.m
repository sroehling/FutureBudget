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

- (id) initWithFieldInfo:(ManagedObjectFieldInfo*)theFieldInfo
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self)
    {
        assert(theFieldInfo != nil);
        self.fieldInfo = theFieldInfo;
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
	
    [[DataModelController theDataModelController] saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)cancel {
    // Don't pass current value to the edited object, just pop.
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc {
    [fieldInfo release];
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
