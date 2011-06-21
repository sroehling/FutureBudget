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
#import "ValueSubtitleTableCell.h"
#import "VariableDate.h"
#import "LocalizationHelper.h"

@implementation DateSensitiveValueChangeFieldEditInfo

@synthesize varValInfo;
@synthesize valChange;
@synthesize valChangeCell;
@synthesize variableVal;

- (void) configureCell
{
	self.valChangeCell.caption.text = 
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:self.valChange.startDate.date];
	self.valChangeCell.valueDescription.text = [[NumberHelper theHelper] displayStrFromStoredVal:self.valChange.newValue andFormatter:self.varValInfo.valueFormatter];;

}

- (id) initWithValueChange:(DateSensitiveValueChange*)valueChange 
andVariableValueRuntimeInfo:(VariableValueRuntimeInfo*)varValueInfo
andVariableValue:(VariableValue*)theVariableVal
{
		self = [super init];
		if(self)
		{
			assert(varValueInfo!=nil);
			self.varValInfo = varValueInfo;
			
			assert(valueChange!=nil);
			self.valChange = valueChange;
			
			self.variableVal = theVariableVal;
			
			self.valChangeCell = [[[ValueSubtitleTableCell alloc] init] autorelease];
			[self configureCell];
			

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
	[valChangeCell release];
	[variableVal release];
}

- (NSString*)detailTextLabel
{
	NSNumber *displayVal = [[NumberHelper theHelper] displayValFromStoredVal:self.valChange.newValue andFormatter:self.varValInfo.valueFormatter];
	return [NSString stringWithFormat:@"%@ - %@",
			[self.varValInfo.valueFormatter stringFromNumber:displayVal],
			[[DateHelper theHelper].mediumDateFormatter stringFromDate:self.valChange.startDate.date] ];
}

- (NSString*)textLabel
{
    return [NSString stringWithFormat:LOCALIZED_STR(@"VALUE_CHANGE_NEW_VALUE_FORMAT"),
	 LOCALIZED_STR(self.varValInfo.valueTitleKey)];
}

- (UIViewController*)fieldEditController
{
	DateSensitiveValueChangeFormPopulator *dsvFormPop = 
		[[[DateSensitiveValueChangeFormPopulator alloc]init ] autorelease];
	return [dsvFormPop editViewControllerForValueChange:self.valChange
		andVariableValRuntimeInfo:self.varValInfo andParentVariableValue:self.variableVal];
 }

- (BOOL)hasFieldEditController
{
    return TRUE;
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return [self.valChangeCell cellHeight];
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    assert(tableView!=nil);
	[self configureCell];
    return self.valChangeCell;
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
