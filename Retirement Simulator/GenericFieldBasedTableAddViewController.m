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

#pragma mark -
#pragma mark Observing changes to objects while add operation in place


- (void)managedObjectsSaved
{
    NSLog(@"Managed objects changed");
    if([self.formInfo allFieldsInitialized])
    {
        self.saveButton.enabled = TRUE;
    }
}


- (void)stopObservingObjectChangeNotifications
{
    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
    [dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:[DataModelController theDataModelController].managedObjectContext];
    
}

- (void)startObservingObjectChangeNotifications
{
    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(managedObjectsSaved) name:NSManagedObjectContextDidSaveNotification 
              object:[DataModelController theDataModelController].managedObjectContext];
    
}

#define DEFAULT_POP_DEPTH 2

-(id)initWithFormInfo:(FormInfo*)formInfo andNewObject:(NSManagedObject*)newObj
{
    self = [super initWithFormInfo:formInfo];
    if(self)
    {        
        assert(newObj != nil);
        self.newObject = newObj;
        
        UIBarButtonItem *cancelButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)] autorelease];
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
        
        UIBarButtonItem *saveButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)] autorelease];
        self.navigationItem.rightBarButtonItem = saveButtonItem;
        self.saveButton = saveButtonItem;
        self.saveButton.enabled = FALSE;
        
        self.popDepth = DEFAULT_POP_DEPTH;
        
        [self startObservingObjectChangeNotifications];
        
    }
    return self;
}

- (id) initWithFormInfo:(FormInfo *)formInfo
{
    assert(0); // should not be called - call version above with new object
}

- (void)dealloc
{
    [super dealloc];
    [newObject release];
    [saveButton release];
}


- (void)save {    
    [self stopObservingObjectChangeNotifications];
    [TableViewHelper popControllerByDepth:self popDepth:self.popDepth];
}


- (void)cancel {
    [self stopObservingObjectChangeNotifications];
    
    // If we cancel out of edit mode, then we need to disable further access
    // to the managed object before we delete the object. This can be an 
    // issue when/if adding a new object is canceled, but the edit of a field
    // is in progress.
    [self.formInfo disableFieldChanges];
    
    [[DataModelController theDataModelController] deleteObject:self.newObject];
    self.newObject = nil;
    
    [TableViewHelper popControllerByDepth:self popDepth:self.popDepth];
}


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    // Redisplay the data - notably, this is invoked when returning 
    // from an editor for one of the field values,
    // causing the display of these values to refresh if changed.
    self.editing = TRUE;
    [super viewWillAppear:animated];
}





#pragma mark -
#pragma mark Table view data source methods


/**
 Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    id<FieldEditInfo> fieldEditInfoForRow = 
        [self.formInfo fieldEditInfoIndexPath:indexPath];
    
    // Deselect the row.
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([fieldEditInfoForRow hasFieldEditController])
    {
        UIViewController *viewControllerForRow = [fieldEditInfoForRow fieldEditController];
        assert(viewControllerForRow != nil);
        [self.navigationController pushViewController:viewControllerForRow animated:YES];       
    }
}


@end
