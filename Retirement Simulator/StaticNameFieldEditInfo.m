//
//  StaticNameFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StaticNameFieldEditInfo.h"
#import "StaticNameFieldCell.h"

@implementation StaticNameFieldEditInfo

@synthesize staticName;

-(id)initWithName:(NSString*)theName
{
	self = [super init];
	if(self)
	{
		assert(theName != nil);
		self.staticName = theName;
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

- (void)dealloc {
	[staticName release];
    [super dealloc];
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return 30.0;
}

- (BOOL)fieldIsInitializedInParentObject
{
    return TRUE;
}

- (void)disableFieldAccess
{
    // no-op
}

- (NSManagedObject*) managedObject
{
    return nil;
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    
    assert(tableView!=nil);
    
    StaticNameFieldCell *cell = (StaticNameFieldCell *)[tableView 
		dequeueReusableCellWithIdentifier:STATIC_NAME_FIELD_CELL_IDENTIFIER];
    if (cell == nil) {
		cell = [[[StaticNameFieldCell alloc] init] autorelease];
    }    
    cell.staticName.text = self.staticName;
    
    
    return cell;
    
}

@end
