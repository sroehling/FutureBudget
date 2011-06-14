//
//  DateSensitiveValueChangeFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValueChangeFieldEditInfo.h"
#import "DateSensitiveValueChangeFormPopulator.h"
#import "DateSensitiveValueChange.h"
#import "VariableValueRuntimeInfo.h"
#import "DateHelper.h"
#import "NumberHelper.h"

@implementation DateSensitiveValueChangeFieldEditInfo

@synthesize varValInfo;
@synthesize valChange;

- (id) initWithValueChange:(DateSensitiveValueChange*)valueChange 
andVariableValueRuntimeInfo:(VariableValueRuntimeInfo*)varValueInfo
{
		self = [super init];
		if(self)
		{
			assert(varValueInfo!=nil);
			self.varValInfo = varValueInfo;
			
			assert(valueChange!=nil);
			self.valChange = valueChange;
		}
		return self;
}

- (id) init
{
	assert(0); // must not call this init
	return nil;
}

- (void) dealloc
{
	[super dealloc];
	[varValInfo release];
	[valChange release];
}

- (NSString*)detailTextLabel
{
	NSNumber *displayVal = [[NumberHelper theHelper] displayValFromStoredVal:self.valChange.newValue andFormatter:self.varValInfo.valueFormatter];
	return [NSString stringWithFormat:@"%@ on %@",
			[self.varValInfo.valueFormatter stringFromNumber:displayVal],
			[[DateHelper theHelper].mediumDateFormatter stringFromDate:self.valChange.startDate] ];
}

- (NSString*)textLabel
{
    return [NSString stringWithFormat:@"New %@",self.varValInfo.valueTitle];
}

- (UIViewController*)fieldEditController
{
	DateSensitiveValueChangeFormPopulator *dsvFormPop = 
		[[[DateSensitiveValueChangeFormPopulator alloc]init ] autorelease];
	return [dsvFormPop editViewControllerForValueChange:self.valChange
							  andVariableValRuntimeInfo:self.varValInfo];
 }

- (BOOL)hasFieldEditController
{
    return TRUE;
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return 40.0;
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    assert(tableView!=nil);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ValueChanges"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ValueChanges"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self detailTextLabel];
 //   cell.detailTextLabel.text = [self detailTextLabel];
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
    return self.valChange;
}




@end
