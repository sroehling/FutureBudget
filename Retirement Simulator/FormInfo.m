//
//  FormInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormInfo.h"
#import "SectionInfo.h"


@implementation FormInfo

@synthesize title;


- (id) init
{
    self = [super init];
    if(self)
    {
        sections = [[NSMutableArray alloc] init];
        self.title = @"";
    }
    return self;
}

- (void) addSection:(SectionInfo*)section
{
    assert(section != nil);
    [sections addObject:section];
}

- (void)dealloc
{
    [super dealloc];
    [sections release];
    [title release];
    
}

- (NSUInteger)numSections
{
    return [sections count];
}

- (SectionInfo*)sectionInfoAtIndex:(NSUInteger)sectionIndex
{
    assert(sectionIndex < [sections count]);
    SectionInfo *indexedSection = (SectionInfo*)[sections objectAtIndex:sectionIndex];
    assert(indexedSection != nil);
    return indexedSection;
}

- (id<FieldEditInfo>)fieldEditInfoIndexPath:(NSIndexPath *)indexPath
{
    assert(indexPath != nil);
    SectionInfo *indexedSection = [self sectionInfoAtIndex:indexPath.section];
    return [indexedSection fieldEditInfoAtRowIndex:indexPath.row];
}

- (BOOL)allFieldsInitialized
{
    for(SectionInfo* sectionInfo in sections)
    {
        if(!([sectionInfo allFieldsInitialized]))
        {
            return FALSE;
        }
    }
    return TRUE;
}

- (void)disableFieldChanges
{
    for(SectionInfo* sectionInfo in sections)
    {
        [sectionInfo disableFieldChanges];
    }
}

@end
