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

- (id)initWithFormInfo:(FormInfo*)theFormInfo
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self)
    {
        self.formInfo = theFormInfo;
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
    self.tableView.allowsSelectionDuringEditing = TRUE;
}


- (void)viewWillAppear:(BOOL)animated {
    
    // A title is needed, since when child views are pushed on the view
    // stack, a back button is needed to get back to this view. The back
    // button only appears if the parent (this view) has a non-zero-length
    // title.
    assert([self.formInfo.title length] > 0); 
    
    self.title = self.formInfo.title;

    
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
    NSLog(@"Table view num sections: %d",[self.formInfo numSections]);
    return [self.formInfo numSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SectionInfo* sectionInfo = [self.formInfo sectionInfoAtIndex:section];
    return sectionInfo.title;
}

#define CUSTOM_SECTION_HEIGHT 22.0

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
    return CUSTOM_SECTION_HEIGHT;
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
