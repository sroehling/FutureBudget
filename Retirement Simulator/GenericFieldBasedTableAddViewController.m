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
{
    self = [super initWithFormInfoCreator:theFormInfoCreator];
    {
        assert(newObj != nil);
        self.newObject = newObj;
        self.popDepth = DEFAULT_POP_DEPTH;
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
		
		
		[[DataModelController theDataModelController] stopObservingContextChanges:self];    
		
		if(self.finshedAddingListener != nil)
		{
			[self.finshedAddingListener objectFinshedBeingAdded:self.newObject];
		}
		[TableViewHelper popControllerByDepth:self popDepth:self.popDepth];
		
		// TBD - To make the save more robust, should a separate context
		// be used for each form doing an add. A case to consider is when
		// a shared milestone date is created and added during the addition
		// of an input, but the input as a whole is not validated. The milestone
		// date should be saved (with error checking), but the input should
		// be validated and saved independently.
		[[DataModelController theDataModelController] saveContextAndIgnoreErrors];
	}

}


- (void)cancel {
	
	[[DataModelController theDataModelController] stopObservingContextChanges:self];    
    
    // If we cancel out of edit mode, then we need to disable further access
    // to the managed object before we delete the object. This can be an 
    // issue when/if adding a new object is canceled, but the edit of a field
    // is in progress.
    [self.formInfo disableFieldChanges];
    
	// If adding a new object is canceled, then any uncommitted changes need to
	// be undone. This will include any objects with required properties that
	// are still uninitialized or filled with invalid values.  
	[[DataModelController theDataModelController] rollbackUncommittedChanges];
	
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
    [[DataModelController theDataModelController] deleteObject:self.newObject];
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
	
	[self updateSaveButtonEnabled];
        
	[[DataModelController theDataModelController] 
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
