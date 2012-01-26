//
//  SectionInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SectionInfo.h"
#import "SectionHeaderWithSubtitle.h"
#import "FixedValue.h"

@implementation SectionInfo

@synthesize title;
@synthesize subTitle;
@synthesize sectionHeader;

- (id) init
{
    self = [super init];
    if(self)
    {
        fieldEditInfo = [[NSMutableArray alloc] init];
		
		self.sectionHeader = [[[SectionHeaderWithSubtitle alloc] initWithFrame:CGRectZero] autorelease];
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
	[sectionHeader release];
    
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

- (NSInteger)findObjectRow:(NSManagedObject*)object
{
    assert(object != nil);
    NSInteger objectRow = 0;
    for(id<FieldEditInfo> feInfo in fieldEditInfo)
    {
		NSManagedObject *feObject = feInfo.managedObject;
		assert(feObject != nil);
		if(object == feObject)
		{
           return objectRow;
        }
		objectRow++;
    }
    
    return -1;
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

- (void)removeFieldEditInfoAtRowIndex:(NSUInteger)rowIndex
{
	assert(rowIndex < [fieldEditInfo count]);
	[fieldEditInfo removeObjectAtIndex:rowIndex];
}

- (NSInteger)numFields
{
    return [fieldEditInfo count];
}

-(void)configureSectionHeader:(CGFloat)tableWidth andEditMode:(BOOL)editing
{
	self.sectionHeader.headerLabel.text = self.title;
	self.sectionHeader.subtitle = self.subTitle;
	[self.sectionHeader sizeForTableWidth:tableWidth andEditMode:editing];

}

- (UIView*)viewForSectionHeader:(CGFloat)tableWidth andEditMode:(BOOL)editing
{
    assert(tableWidth>0.0);
    // Returning nil will cause the view to revert to the default
    if([self.title length] > 0)
    {
		[self configureSectionHeader:tableWidth andEditMode:editing];
		return self.sectionHeader;
       
    }
    else
    {
        return nil;
    }

}


- (CGFloat)viewHeightForSection
{
    return [sectionHeader headerHeight];
}

@end
