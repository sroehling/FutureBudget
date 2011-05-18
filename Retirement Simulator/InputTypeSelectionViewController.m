//
//  InputTypeSelectionViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputTypeSelectionViewController.h"
#import "InputTypeSelectionInfo.h"


@implementation InputTypeSelectionViewController

@synthesize inputTypes;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"Input Type";

    self.inputTypes = [[[NSMutableArray alloc] init ] autorelease];
    
    InputTypeSelectionInfo *typeInfo = [[[IncomeInputTypeSelectionInfo alloc] init ] autorelease];
    typeInfo.description = @"Income";
    
    [self.inputTypes addObject:typeInfo];
    
    typeInfo = [[[ExpenseInputTypeSelectionInfo alloc] init ] autorelease];
    typeInfo.description = @"Expense";
    
    [self.inputTypes addObject:typeInfo];


}

- (void)dealloc
{
    [super dealloc];
    [inputTypes release];
    
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Update the current frequency
    InputTypeSelectionInfo *typeInfo = [self.inputTypes objectAtIndex:indexPath.row];
    assert(typeInfo!=nil);
    
    [typeInfo createInput]; // create the managed (core data) object for the given input
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end