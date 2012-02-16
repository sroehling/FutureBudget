//
//  GenericFieldBasedTableAddViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GenericFieldBasedTableAddViewController.h"
#import "FieldEditInfo.h"
#import "TableViewHelper.h"
#import "DataModelController.h"
#import "FormInfo.h"

@implementation GenericFieldBasedTableAddViewController

@synthesize newObject;
@synthesize saveButton;
@synthesize popDepth;
@synthesize finshedAddingListener;
@synthesize disableCoreDataSaveUntilSaveButtonPressed;

#pragma mark -
#pragma mark Observing changes to objects while add operation in place

- (void)updateSaveButtonEnabled
{
    if([self.formInfo allFieldsInitialized])
    {
        self.saveButton.enabled = TRUE;
    }
	else
	{
		self.saveButton.enabled = FALSE;
	}

}

- (void)managedObjectsChanged
{
    NSLog(@"Managed objects changed - updating saving button for table controller");
	[self updateSaveButtonEnabled];
}

#define DEFAULT_POP_DEPTH 2


- (id)initWithFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator andNewObject:(NSManagedObject*)newObj
	andDataModelController:(DataModelController*)theDataModelController
{
    self = [super initWithFormInfoCreator:theFormInfoCreator
		andDataModelController:theDataModelController];
    {
        assert(newObj != nil);
        self.newObject = newObj;
        self.popDepth = DEFAULT_POP_DEPTH;
		self.disableCoreDataSaveUntilSaveButtonPressed = FALSE;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [newObject release];
    [saveButton release];
	[finishedAddingListener release];
}


- (void)save {
    if([self.formInfo allFieldsInitialized])
	{
		[self.formInfo disableFieldChanges];
		
		
		[self.dataModelController stopObservingContextChanges:self];    
		
		if(self.finshedAddingListener != nil)
		{
			[self.finshedAddingListener objectFinshedBeingAdded:self.newObject];
		}
		
		if(self.disableCoreDataSaveUntilSaveButtonPressed)
		{
			self.dataModelController.saveEnabled = TRUE;
		}
		
		// To make the save more robust, a separate context can
		// be used for each form doing an add.
		[self.dataModelController saveContextAndIgnoreErrors];

		// It is important to save the context before popping the view
		// controller. In particular, the parent's view controller's 
		// viewWill appear method will be called after popping. If the
		// context is not saved, the results shown in the parent controller
		// may not be up to date.
		[TableViewHelper popControllerByDepth:self popDepth:self.popDepth];

	}

}


- (void)cancel {
	
	[self.dataModelController stopObservingContextChanges:self];    

	self.dataModelController.saveEnabled = TRUE;

    
    // If we cancel out of edit mode, then we need to disable further access
    // to the managed object before we delete the object. This can be an 
    // issue when/if adding a new object is canceled, but the edit of a field
    // is in progress.
    [self.formInfo disableFieldChanges];
    
	// If adding a new object is canceled, then any uncommitted changes need to
	// be undone. This will include any objects with required properties that
	// are still uninitialized or filled with invalid values.  
	[self.dataModelController rollbackUncommittedChanges];
	
	// If a "soft save" (i.e., one which takes place without error checking) occurs
	// leading up to the cancel, it's possible the new object could have been
	// already saved, such that it won't get rolled back above. In this case,
	// we still need to respect the intent of the cancel operation and not 
	// add the new object. 
	//
	// TODO - If we know the editing that is occurring is for new objects, then
	// we probably need to turn off "soft saving" altogether in any sub forms.
	// This will have the effect of ensuring a complete rollback in the case of 
	// a cancel. 
    [self.dataModelController deleteObject:self.newObject];
    self.newObject = nil;
	
    [TableViewHelper popControllerByDepth:self popDepth:self.popDepth];
}


#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
	// TODO - Replace titles below with localized strings
    UIBarButtonItem *cancelButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)] autorelease];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    
    UIBarButtonItem *saveButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)] autorelease];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    self.saveButton = saveButtonItem;
	
	if(self.disableCoreDataSaveUntilSaveButtonPressed)
	{
		self.dataModelController.saveEnabled = FALSE;
	}
	
	[self updateSaveButtonEnabled];
        
	[self.dataModelController 
		startObservingContextChanges:self withSelector:@selector(managedObjectsChanged)];    
   
}

- (void)viewWillAppear:(BOOL)animated {
    // Redisplay the data - notably, this is invoked when returning 
    // from an editor for one of the field values,
    // causing the display of these values to refresh if changed.
    [super viewWillAppear:animated];

	// Another sub-view may be pushed onto the stack for editing and/or setting a
	// complex property. viewWillAppear will be called when this sub-view
	// is popped from the stack.
	[self updateSaveButtonEnabled];

    self.editing = TRUE;


}

@end
