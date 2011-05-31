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


- (void)viewWillAppear:(BOOL)animated {
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



@end
