//
//  BoolFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BoolFieldEditInfo.h"
#import "BoolFieldCell.h"
#import "StringValidation.h"
#import "ManagedObjectFieldInfo.h"
#import "FieldInfo.h"
#import "TableViewHelper.h"


@implementation BoolFieldEditInfo

@synthesize boolCell;

- (id)initWithFieldInfo:(FieldInfo *)theFieldInfo
	andSubtitle:(NSString*)subTitle
{
	self = [super initWithFieldInfo:theFieldInfo];
	if(self)
	{
		self.boolCell = [[[BoolFieldCell alloc] initWithFrame:CGRectZero] autorelease];
		
		self.boolCell.label.text = [self textLabel];
	
		if(subTitle != nil)
		{
			self.boolCell.valueSubtitle.text = subTitle;
		}
	
		NSNumber *boolVal = [self.fieldInfo getFieldValue];
		assert(boolVal != nil);
		[self.boolCell.boolSwitch setOn:[boolVal boolValue]];

		self.boolCell.boolFieldInfo = theFieldInfo;

	}
	return self;
}

-(id)initWithFieldInfo:(FieldInfo *)theFieldInfo
{
	assert(0); // must init with subtitle
	return nil;
}

+ (BoolFieldEditInfo*)createForObject:(NSManagedObject*)obj 
		andKey:(NSString*)key
        andLabel:(NSString*)label
{
    assert(obj != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
    
    ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc] 
              initWithManagedObject:obj andFieldKey:key andFieldLabel:label 
										 andFieldPlaceholder:@"N/A"] autorelease];
    BoolFieldEditInfo *fieldEditInfo = [[[BoolFieldEditInfo alloc] initWithFieldInfo:fieldInfo
		andSubtitle:nil] autorelease];
	
    
    return fieldEditInfo;
}


- (NSString*)detailTextLabel
{
   return @"";
    
}


- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return [self.boolCell cellHeight];
}


- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    return self.boolCell;
}

- (void)dealloc 
{
	[boolCell release];
    [super dealloc];
}


@end
