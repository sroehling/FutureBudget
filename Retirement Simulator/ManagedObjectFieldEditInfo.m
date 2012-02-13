//
//  ManagedObjectFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ManagedObjectFieldEditInfo.h"


@implementation ManagedObjectFieldEditInfo

@synthesize fieldInfo;
@synthesize isDefaultSelection;

- (id) initWithFieldInfo:(FieldInfo *)theFieldInfo
{
    self = [super init];
    if(self)
    {
        assert(theFieldInfo != nil);
        self.fieldInfo = theFieldInfo;
		self.isDefaultSelection = FALSE;
		
    }
    return self;
}

- (NSString*) textLabel
{
    return [fieldInfo textLabel];
}

- (void)dealloc
{
    [fieldInfo release];
    [super dealloc];
}

- (BOOL)fieldIsInitializedInParentObject
{
    return [self.fieldInfo fieldIsInitializedInParentObject];
}

- (void)disableFieldAccess
{
    [self.fieldInfo disableFieldAccess];
}

- (NSManagedObject*) managedObject
{
    return self.fieldInfo.managedObject;
}

- (BOOL)isSelected
{
	return self.fieldInfo.isSelectedForSelectableObjectTableView;
}

- (void)updateSelection:(BOOL)isSelected
{
	self.fieldInfo.isSelectedForSelectableObjectTableView = isSelected;
}

@end
