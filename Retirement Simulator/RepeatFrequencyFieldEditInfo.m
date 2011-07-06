//
//  RepeatFrequencyFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RepeatFrequencyFieldEditInfo.h"
#import "RepeatFrequencyEditViewController.h"
#import "EventRepeatFrequency.h"
#import "TableViewHelper.h"
#import "StringValidation.h"
#import "FormFieldWithSubtitleTableCell.h"
#import "LocalizationHelper.h"
#import "MultiScenarioInputValueFieldInfo.h"

@implementation RepeatFrequencyFieldEditInfo

@synthesize freqCell;

- (void)configureFreqCell
{
	self.freqCell.caption.text = [self textLabel];
    self.freqCell.contentDescription.text = [self detailTextLabel];

}

+ (RepeatFrequencyFieldEditInfo*)createForScenario:(Scenario*)theScenario 
	andObject:(NSManagedObject*)obj andKey:(NSString*)key
                             andLabel:(NSString*)label
{
    assert(obj != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
	
	NSString *freqPlaceholder = LOCALIZED_STR(@"INPUT_CASH_FLOW_REPEAT_FREQUENCY_PLACEHOLDER");
    
 	MultiScenarioInputValueFieldInfo *fieldInfo = [[[MultiScenarioInputValueFieldInfo alloc]
			initWithScenario:theScenario andManagedObject:obj andFieldKey:key 
			andFieldLabel:label andFieldPlaceholder:freqPlaceholder] autorelease];


    RepeatFrequencyFieldEditInfo *fieldEditInfo = [[RepeatFrequencyFieldEditInfo alloc] initWithFieldInfo:fieldInfo];
    [fieldEditInfo autorelease];
    
    return fieldEditInfo;
}

+ (RepeatFrequencyFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
                             andLabel:(NSString*)label
{
    assert(obj != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
	
	NSString *freqPlaceholder = LOCALIZED_STR(@"INPUT_CASH_FLOW_REPEAT_FREQUENCY_PLACEHOLDER");
    
    ManagedObjectFieldInfo *fieldInfo = [[ManagedObjectFieldInfo alloc] 
                                         initWithManagedObject:obj andFieldKey:key andFieldLabel:label andFieldPlaceholder:freqPlaceholder];
    RepeatFrequencyFieldEditInfo *fieldEditInfo = [[RepeatFrequencyFieldEditInfo alloc] initWithFieldInfo:fieldInfo];
    [fieldEditInfo autorelease];
    [fieldInfo release];
    
    return fieldEditInfo;
}

- (id) initWithFieldInfo:(ManagedObjectFieldInfo *)theFieldInfo
{
	self = [super initWithFieldInfo:theFieldInfo];
	if(self)
	{
		self.freqCell = [[[FormFieldWithSubtitleTableCell alloc] init] autorelease];
		self.freqCell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.freqCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[self configureFreqCell];
	}
	return self;
}

- (NSString*)detailTextLabel
{
    
    EventRepeatFrequency *repeatFrequency = [self.fieldInfo getFieldValue];
    return [repeatFrequency description];
}

- (UIViewController*)fieldEditController
{
    RepeatFrequencyEditViewController *repeatController = 
    [[RepeatFrequencyEditViewController alloc] initWithFieldInfo:fieldInfo];
    [repeatController autorelease];
    return repeatController;
}

- (BOOL)hasFieldEditController
{
    return TRUE;
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return [self.freqCell cellHeightForWidth:width];
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
	[self configureFreqCell];
	return self.freqCell;
}

- (void) dealloc
{
	[super dealloc];
	[freqCell release];
}

@end
