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
@synthesize sectionHeader;
@synthesize helpInfoHTMLFile;
@synthesize formContext;

- (id) initWithFormContext:(FormContext*)theFormContext
{
    self = [super init];
    if(self)
    {
        fieldEditInfo = [[NSMutableArray alloc] init];
		
		self.sectionHeader = [[[SectionHeaderWithSubtitle alloc] initWithFrame:CGRectZero] autorelease];
		self.sectionHeader.formContext = theFormContext;
        self.title = @"";
		
		assert(theFormContext != nil);
		self.formContext = theFormContext;
    }
    return self;
}

- (id) init
{
	assert(0);
	return nil;
}

- (id) initWithHelpInfo:(NSString*)helpInfoFile andFormContext:(FormContext*)theFormContext
{
	self = [super init];
	if(self)
	{
       fieldEditInfo = [[NSMutableArray alloc] init];
		
		self.sectionHeader = [[[SectionHeaderWithSubtitle alloc] initWithFrame:CGRectZero] autorelease];
		self.sectionHeader.formContext = theFormContext;
        self.title = @"";


		self.helpInfoHTMLFile = helpInfoFile;
		self.sectionHeader.helpInfoHTMLFile = helpInfoHTMLFile;
		
		assert(theFormContext != nil);
		self.formContext = theFormContext;
		
		
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
    [fieldEditInfo release];
    [title release];
	[sectionHeader release];
	[helpInfoHTMLFile release];
    [super dealloc];
    
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

- (id<FieldEditInfo>)findSelectedFieldEditInfo
{
	for(id<FieldEditInfo> feInfo in fieldEditInfo)
	{
		assert([feInfo respondsToSelector: @selector(isSelected)]);
		if([feInfo isSelected])
		{
			return feInfo;
		}
	}
	return nil;
}

- (id<FieldEditInfo>)findDefaultSelection
{
	for(id<FieldEditInfo> feInfo in fieldEditInfo)
	{
		if([feInfo respondsToSelector: @selector(isDefaultSelection)] && 
			[feInfo isDefaultSelection])
		{
			return feInfo;
		}
	}
	return nil;

}

- (void)unselectAllFields
{
	for(id<FieldEditInfo> feInfo in fieldEditInfo)
	{
		assert([feInfo respondsToSelector: @selector(updateSelection:)]);
		[feInfo updateSelection:FALSE];
	}

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
	self.sectionHeader.helpInfoHTMLFile = self.helpInfoHTMLFile;
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
