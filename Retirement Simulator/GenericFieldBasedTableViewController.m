//
//  GenericFieldBasedTableViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GenericFieldBasedTableViewController.h"
#import "FormInfo.h"
#import "FieldEditInfo.h"
#import "SectionInfo.h"

@implementation GenericFieldBasedTableViewController

@synthesize formInfo;
@synthesize formInfoCreator;


- (id)initWithFormInfoCreator:(id<FormInfoCreator>) theFormInfoCreator
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self)
    {
        assert(theFormInfoCreator != nil);
        self.formInfoCreator = theFormInfoCreator;
        
        // Initially pass in an empty FormInfo object. It will be fully
        // re-populatee with viewDidLoad. The reason the FormInfo can't
        // be fully populated here is because theFormInfoCreator is passed
        // a reference to this view controller (self) for the creation, and
        // self isn't fully instantiated yet.
        FormInfo *initialFormInfo = [[[FormInfo alloc]init ] autorelease];
        initialFormInfo.title = @"Dummy";

        self.formInfo = initialFormInfo;
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
    [formInfo release];
    [formInfoCreator release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(self.formInfoCreator != nil)
    {
        self.formInfo = [self.formInfoCreator createFormInfo:self];
    }
    
    self.tableView.allowsSelectionDuringEditing = TRUE;
	
	

}


- (void)viewWillAppear:(BOOL)animated {
    
    if(self.formInfoCreator != nil)
    {
        self.formInfo = [self.formInfoCreator createFormInfo:self];
    }
	
    
    // A title is needed, since when child views are pushed on the view
    // stack, a back button is needed to get back to this view. The back
    // button only appears if the parent (this view) has a non-zero-length
    // title.
    assert([self.formInfo.title length] > 0); 
    
    self.title = self.formInfo.title;

	if(self.formInfo.headerView)
	{
		self.tableView.tableHeaderView = self.formInfo.headerView;
	}

    
    [super viewWillAppear:animated];
    

    // Redisplay the data - notably, this is invoked when returning 
    // from an editor for one of the field values,
    // causing the display of these values to refresh if changed.
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.formInfo numSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SectionInfo* sectionInfo = [self.formInfo sectionInfoAtIndex:section];
    return sectionInfo.title;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        // create the parent view that will hold header Label
    
        SectionInfo* sectionInfo = [self.formInfo sectionInfoAtIndex:section];
        if([sectionInfo.title length] > 0)
        {
            return [sectionInfo viewForSectionHeader:tableView.bounds.size.width
                                         andEditMode:self.editing];
        }
        else
        {
            return nil;
        }
    
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	SectionInfo* sectionInfo = [self.formInfo sectionInfoAtIndex:section];
	return [sectionInfo viewHeightForSection];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	id<FieldEditInfo> feInfo = [self.formInfo fieldEditInfoIndexPath:indexPath];
	return [feInfo cellHeightForWidth:300.0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SectionInfo* sectionInfo = [self.formInfo sectionInfoAtIndex:section];
    return [sectionInfo numFields];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    id<FieldEditInfo> feInfo = [self.formInfo fieldEditInfoIndexPath:indexPath];
    return [feInfo cellForFieldEdit:self.tableView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only allow selection if editing.
    return indexPath;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];

    // Reload the sections depending upon if we're in edit mode or not. This is needed for sections

    NSIndexSet *sectionIndices = [self.formInfo sectionIndicesNeedingRefreshForEditMode];
    [self.tableView reloadSections:sectionIndices 
                  withRowAnimation:UITableViewRowAnimationNone];
}



@end
