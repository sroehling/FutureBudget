//
//  VariableValueFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableValueFieldEditInfo.h"
#import "TableViewHelper.h"
#import "StringValidation.h"
#import "FormPopulator.h"
#import "NumberHelper.h"
#import "MilestoneDate.h"
#import "FormInfo.h"
#import "VariableValue.h"
#import "SectionInfo.h"
#import "DateHelper.h"
#import "VariableValueViewController.h"


@implementation VariableValueFieldEditInfo


@synthesize variableVal;


- (id)initWithVariableValue:(VariableValue*)varValue
{
    assert(varValue != nil);
    self = [super init];
    if(self)
    {
        self.variableVal = varValue;
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
    [variableVal release];
}

- (NSString*)detailTextLabel
{
    // TBD - Should we only show starting value, or something else
    return [[[NumberHelper theHelper] numberFormatter ] stringFromNumber:self.variableVal.startingValue];
}

- (NSString*)textLabel
{
    return self.variableVal.name;
}

- (UIViewController*)fieldEditController
{
    UIViewController *controller = [[[VariableValueViewController alloc] 
                   initWithVariableValue:self.variableVal] autorelease];
    return controller;
}

- (BOOL)hasFieldEditController
{
    return TRUE;
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    // TODO - Push this, along with code in milestone field edit info into helper
    // function to create table cells with subtitle.
    assert(tableView!=nil);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VariableValues"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VariableValues"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self textLabel];
    cell.detailTextLabel.text = [self detailTextLabel];
    return cell;
}


- (BOOL)fieldIsInitializedInParentObject
{
    return TRUE;
}

- (void)disableFieldAccess
{
    // no-op
    // TBD - should this be a no-op
}

- (NSManagedObject*) managedObject
{
    return self.variableVal;
}



@end
