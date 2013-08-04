//
//  InputTypeSelectionFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/13/13.
//
//

#import "InputTypeSelectionFieldEditInfo.h"
#import "InputTypeSelectionInfo.h"
#import "Input.h"
#import "FormFieldWithSubtitleTableCell.h"


@implementation InputTypeSelectionFieldEditInfo

@synthesize inputTypeSelectionInfo;
@synthesize inputCell;

-(void)dealloc
{
	[inputTypeSelectionInfo release];
	[inputCell release];
	[super dealloc];
}

-(id)initWithTypeSelectionInfo:(InputTypeSelectionInfo*)theInputTypeSelectionInfo
{
	self = [ super init];
	if(self)
	{
		self.inputTypeSelectionInfo = theInputTypeSelectionInfo;
		
		self.inputCell = 
			[[[FormFieldWithSubtitleTableCell alloc] initWithFrame:CGRectZero] autorelease];
		self.inputCell.accessoryType = UITableViewCellAccessoryNone;
		self.inputCell.editingAccessoryType = UITableViewCellAccessoryNone;
		self.inputCell.tableStyle = UITableViewStyleGrouped;

		self.inputCell.imageView.image = [UIImage imageNamed:self.inputTypeSelectionInfo.imageName];
		self.inputCell.caption.text = self.inputTypeSelectionInfo.inputLabel;
		self.inputCell.subTitle.text = self.inputTypeSelectionInfo.subTitle;


	}
	return self;
}


- (NSString*)detailTextLabel
{
    return @"";
}

- (NSString*)textLabel
{
    return @"";
}


- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return [self.inputCell cellHeightForWidth:width];
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
     return self.inputCell;
}


- (BOOL)fieldIsInitializedInParentObject
{
    return FALSE;
}


- (NSManagedObject*) managedObject
{
    return [self.inputTypeSelectionInfo createInput];
}


- (BOOL)supportsDelete
{
	return FALSE;
}

- (void)deleteObject:(DataModelController*)dataModelController
{
	assert(0); // Should not get here
}


@end
