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

@implementation GenericFieldBasedTableAddViewController

@synthesize fieldEditInfo;
@synthesize newObject;
@synthesize saveButton;
@synthesize popDepth;

#pragma mark -
#pragma mark Observing changes to objects while add operation in place

- (BOOL)allFieldsInitialized
{
    for(id<FieldEditInfo> feInfo in self.fieldEditInfo)
    {
        if(!([feInfo fieldIsInitializedInParentObject]))
        {
            return FALSE;
        }
    }
    return TRUE;
    
}

- (void)disableFieldChanges
{
    for(id<FieldEditInfo> feInfo in self.fieldEditInfo)
    {
        [feInfo disableFieldAccess];
    }

}

- (void)managedObjectsSaved
{
    NSLog(@"Managed objects changed");
    if([self allFieldsInitialized])
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

-(id)initWithFieldEditInfo:(NSMutableArray *)theFieldEditInfo andNewObject:(NSManagedObject*)newObj;
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self)
    {
        assert(theFieldEditInfo!=nil);
        assert([theFieldEditInfo count] > 0);
        self.fieldEditInfo = theFieldEditInfo;
        
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

- (id)initWithStyle:(UITableViewStyle)style
{
    assert(0); // should not call this version of init
}

- (id)init
{
    assert(0); // should not call this version of init
}


- (void)dealloc
{
    [super dealloc];
    [fieldEditInfo release];
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
    [self disableFieldChanges];
    
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
    [self.tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // The fieldEditInfo vector must be initialized and have > 0 field info objects
    // for this table view to be properly configured.
    assert(self.fieldEditInfo != nil);
    assert([self.fieldEditInfo count] > 0);
    
    return [self.fieldEditInfo count];
}



- (id<FieldEditInfo>)fieldEditInfoAtIndex:(NSUInteger)theIndex
{
    assert(theIndex < [self.fieldEditInfo count]);
    id<FieldEditInfo> fieldEditInfoForRow = (id<FieldEditInfo>)[self.fieldEditInfo objectAtIndex:theIndex];
    assert(fieldEditInfoForRow != nil);
    return fieldEditInfoForRow;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    id<FieldEditInfo> fieldEditInfoForRow = [self fieldEditInfoAtIndex:indexPath.row];    
    UITableViewCell *cell = [fieldEditInfoForRow cellForFieldEdit:tableView];
    assert(cell != nil);
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only allow selection if editing.
    return indexPath;
}



/**
 Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    id<FieldEditInfo> fieldEditInfoForRow = [self fieldEditInfoAtIndex:indexPath.row];
    
    // Deselect the row.
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([fieldEditInfoForRow hasFieldEditController])
    {
        UIViewController *viewControllerForRow = [fieldEditInfoForRow fieldEditController];
        assert(viewControllerForRow != nil);
        [self.navigationController pushViewController:viewControllerForRow animated:YES];       
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

@end
