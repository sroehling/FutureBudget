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
    BoolFieldEditInfo *fieldEditInfo = [[[BoolFieldEditInfo alloc] initWithFieldInfo:fieldInfo] autorelease];
    
    return fieldEditInfo;
}


- (NSString*)detailTextLabel
{
   return @"";
    
}

- (UIViewController*)fieldEditController
{
    assert(0);
    return nil;
    
}

- (BOOL)hasFieldEditController
{
    return FALSE;
}

- (void)dealloc {
    [super dealloc];
	[boolCell release];
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return 40.0;
}


- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    
    assert(tableView!=nil);
    static NSString *boolCellIdentifier = @"BoolFieldCell";
	
    
    BoolFieldCell *cell = (BoolFieldCell *)[tableView dequeueReusableCellWithIdentifier:boolCellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"BoolFieldCell" owner:self options:nil];
		assert(self.boolCell!=nil);
        cell = self.boolCell;
		self.boolCell = nil;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.editingAccessoryType = UITableViewCellAccessoryNone;
    
    cell.boolFieldInfo = self.fieldInfo;
    cell.label.text = [self textLabel];
	NSNumber *boolVal = [self.fieldInfo getFieldValue];
	assert(boolVal != nil);
	[cell.boolSwitch setOn:[boolVal boolValue]];
        
    return cell;
    
}

@end