//
//  InputTagsFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/15/13.
//
//

#import "InputTagsFieldEditInfo.h"

#import "Input.h"
#import "InputTagSelectionFormInfoCreator.h"
#import "MultipleSelectionTableViewController.h"
#import "InputTag.h"
#import "FormContext.h"
#import "LocalizationHelper.h"
#import "VariableContentTableCell.h"

@implementation InputTagsFieldEditInfo


@synthesize input;
@synthesize valueCell;

-(void)dealloc
{
	[input release];
	[valueCell release];
	[super dealloc];
}  


-(id)initWithInput:(Input*)theInput
{
	self = [super init];
	if(self)
	{
		self.input = theInput;
		self.valueCell = [[[VariableContentTableCell alloc] initWithFrame:CGRectZero] autorelease];
		self.valueCell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;

	}
	return self;
}

-(void)configureCell
{
	self.valueCell.caption.text = LOCALIZED_STR(@"INPUT_TAGS_FIELD_CAPTION");

	NSString *tagListDesc;
	
	if(self.input.tags.count > 0)
	{
		NSMutableArray *specificTagNames = [[[NSMutableArray alloc] init] autorelease];
		for(InputTag *tag in self.input.tags)
		{
			[specificTagNames addObject:tag.tagName];
		}
		tagListDesc = [specificTagNames componentsJoinedByString:@", "];
	}
	else
	{
		tagListDesc = LOCALIZED_STR(@"INPUT_TAGS_FIELD_NO_TAGS_SELECTED_CONTENT");
	}
	
	self.valueCell.contentDescription.text = tagListDesc;

}

-(id)initWithManagedObj:(NSManagedObject *)theFieldObj 
	andCaption:(NSString *)theCaption 
	andContent:(NSString *)theContent
{
	assert(0);
	return nil;
}


- (NSString*)textLabel
{
	return @"";
}


- (NSString*)detailTextLabel
{
	return @"";
}

- (UIViewController*)fieldEditController:(FormContext*)parentContext
{
	InputTagSelectionFormInfoCreator *inputTagsFormInfoCreator =
		[[[InputTagSelectionFormInfoCreator alloc] initWithInput:self.input] autorelease];

	MultipleSelectionTableViewController *tagSelectionController =
		[[[MultipleSelectionTableViewController alloc]
		initWithFormInfoCreator:inputTagsFormInfoCreator
			andDataModelController:parentContext.dataModelController] autorelease];
	tagSelectionController.supportsEditing = TRUE;

	return tagSelectionController;	

}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	[self configureCell];
	return [self.valueCell cellHeightForWidth:width];
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
	[self configureCell];
    return self.valueCell;
}

- (BOOL)fieldIsInitializedInParentObject
{
    return TRUE;
}


- (NSManagedObject*) managedObject
{
    return nil;
}


@end
