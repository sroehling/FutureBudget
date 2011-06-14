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
@synthesize objectAdder;


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


- (NSManagedObject*)objectAtPath:(NSIndexPath *)indexPath
{
    id<FieldEditInfo> feAtPath = [self fieldEditInfoIndexPath:indexPath];
    assert(feAtPath != nil);
    return feAtPath.managedObject;
}

- (NSIndexPath*)pathForObject:(NSManagedObject *)object
{
    NSInteger sectionNum = 0;
    for(SectionInfo* sectionInfo in sections)
    {
        NSInteger objectRowNum = [sectionInfo findObjectRow:object];
        if(objectRowNum >= 0)
        {
            return [NSIndexPath indexPathForRow:objectRowNum inSection:sectionNum];
        }
        sectionNum++;
    }
    assert(0); // should not get here - object must be found
    return nil;
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

- (NSIndexSet*)sectionIndicesNeedingRefreshForEditMode
{
    // TODO - Return just the sections needing updating, rather than all the sections
    NSRange sectionRange = NSMakeRange(0,[sections count]);
    return [[[NSIndexSet alloc] initWithIndexesInRange:sectionRange] autorelease];
    
}

@end
