//
//  UserScenarioFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserScenarioFieldEditInfo.h"
#import "UserScenario.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "FormFieldWithSubtitleTableCell.h"
#import "UserScenarioFormInfoCreator.h"
#import "DataModelController.h"
#import "FormContext.h"


@implementation UserScenarioFieldEditInfo

@synthesize userScen;
@synthesize scenarioCell;

- (id)initWithUserScenario:(UserScenario*)theUserScen
{
	self = [super init];
	if(self)
	{
		assert(theUserScen != nil);
		self.userScen = theUserScen;
		self.scenarioCell = 
		[[[FormFieldWithSubtitleTableCell alloc] initWithFrame:CGRectZero] autorelease];
		self.scenarioCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;   
		self.scenarioCell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;

		if((self.userScen.iconImageName != nil) &&
			(self.userScen.iconImageName.length > 0))
		{
			self.scenarioCell.imageView.image = [UIImage imageNamed:self.userScen.iconImageName];
		}


	}
	return self;
}

- (void) dealloc
{
	[userScen release];
	[scenarioCell release];
	[super dealloc];
}



- (NSString*)detailTextLabel
{
    return @"";
}

- (NSString*)textLabel
{
    return self.userScen.name;
}

- (UIViewController*)fieldEditController:(FormContext*)parentContext
{
    UserScenarioFormInfoCreator *formInfoCreator = 
		[[[UserScenarioFormInfoCreator alloc]
		initWithUserScenario:self.userScen] autorelease];
    UIViewController *detailViewController = 
	[[[GenericFieldBasedTableEditViewController alloc] 
	  initWithFormInfoCreator:formInfoCreator
	  andDataModelController:parentContext.dataModelController] autorelease];
	return detailViewController;
}

- (void)configureScenarioCell
{
	self.scenarioCell.caption.text = [self textLabel];	
	self.scenarioCell.subTitle.text = [self detailTextLabel];
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	[self configureScenarioCell];
	return [self.scenarioCell cellHeightForWidth:width];
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    assert(tableView!=nil);
	
	[self configureScenarioCell]; 
	
	return self.scenarioCell;
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
    return self.userScen;
}

-(BOOL)supportsDelete
{
	return TRUE;
}

- (void)deleteObject:(DataModelController*)dataModelController
{
	// TODO - Need to ensure the current scenario reverts back to default when 
	// deleting the scenario and the current scenario is this one.
	assert(self.userScen != nil);
	[dataModelController deleteObject:self.userScen];
	self.userScen = nil;
}

- (BOOL)isSelected
{
	assert(self.userScen != nil);
	return self.userScen.isSelectedForSelectableObjectTableView;
}

- (void)updateSelection:(BOOL)isSelected
{
	assert(self.userScen != nil);
	self.userScen.isSelectedForSelectableObjectTableView = isSelected;
}


@end
