//
//  SectionInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SectionInfo.h"


@implementation SectionInfo

@synthesize title;

- (id) init
{
    self = [super init];
    if(self)
    {
        fieldEditInfo = [[NSMutableArray alloc] init];
        self.title = @"";
    }
    return self;
}

- (void) addFieldEditInfo:(id<FieldEditInfo>)feInfo
{
    assert(feInfo != nil);
    [fieldEditInfo addObject:feInfo];
}

- (void)dealloc
{
    [super dealloc];
    [fieldEditInfo release];
    [title release];
    
}

- (BOOL)allFieldsInitialized
{
    for(id<FieldEditInfo> feInfo in fieldEditInfo)
    {
        if(!([feInfo fieldIsInitializedInParentObject]))
        {
            return FALSE;
        }
    }
    return TRUE;
    
}

- (void)disableFieldChanges
{
    for(id<FieldEditInfo> feInfo in fieldEditInfo)
    {
        [feInfo disableFieldAccess];
    }
    
}




- (id<FieldEditInfo>)fieldEditInfoAtRowIndex:(NSUInteger)rowIndex
{
    assert(rowIndex < [fieldEditInfo count]);
    id<FieldEditInfo> feInfoForRow = [fieldEditInfo objectAtIndex:rowIndex];
    assert(feInfoForRow != nil);
    return feInfoForRow;
}

- (NSInteger)numFields
{
    return [fieldEditInfo count];
}

@end
