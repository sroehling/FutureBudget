//
//  SectionInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SectionInfo.h"


#define CUSTOM_SECTION_VIEW_LEFT_LABEL_OFFSET 10.0
#define CUSTOM_SECTION_VIEW_TITLE_HEIGHT 22.0
#define CUSTOM_SECTION_VIEW_SUBTITLE_TOP (CUSTOM_SECTION_VIEW_TITLE_HEIGHT+2.0)
#define CUSTOM_SECTION_VIEW_SUBTITLE_HEIGHT 20.0
#define CUSTOM_SECTION_FIXED_HEIGHT (CUSTOM_SECTION_VIEW_TITLE_HEIGHT + 2.0)

@implementation SectionInfo

@synthesize title;
@synthesize subTitle;

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

- (NSInteger)findObjectRow:(NSManagedObject*)object
{
    assert(object != nil);
    NSInteger objectRow = 0;
    for(id<FieldEditInfo> feInfo in fieldEditInfo)
    {
        if(object == feInfo.managedObject)
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

- (NSInteger)numFields
{
    return [fieldEditInfo count];
}

- (UIView*)viewForSectionHeader:(CGFloat)tableWidth andEditMode:(BOOL)editing
{
    assert(tableWidth>0.0);
    // Returning nil will cause the view to revert to the default
    if([self.title length] > 0)
    {
        // create the button object
        UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = NO;
        headerLabel.textColor = [UIColor blackColor];
        headerLabel.highlightedTextColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:14];
        // Calculate the label width in consideration of both the offset on the LHS and RHS
        CGFloat labelWidth = tableWidth - CUSTOM_SECTION_VIEW_LEFT_LABEL_OFFSET - [self sectionViewRightOffset:editing];
        headerLabel.frame = CGRectMake(CUSTOM_SECTION_VIEW_LEFT_LABEL_OFFSET, 0.0, labelWidth, CUSTOM_SECTION_VIEW_TITLE_HEIGHT);
        headerLabel.text = self.title;
       
	   
        UILabel * subTitleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        subTitleLabel.backgroundColor = [UIColor clearColor];
        subTitleLabel.opaque = NO;
        subTitleLabel.textColor = [UIColor whiteColor];
        subTitleLabel.highlightedTextColor = [UIColor whiteColor];
        subTitleLabel.font = [UIFont systemFontOfSize:12];

		subTitleLabel.lineBreakMode = UILineBreakModeWordWrap;
		subTitleLabel.numberOfLines = 0;
	
		CGSize maxSize = CGSizeMake(labelWidth, 150);
		CGSize subTitleSize = [self.subTitle sizeWithFont:subTitleLabel.font
							   constrainedToSize:maxSize
							   lineBreakMode:subTitleLabel.lineBreakMode];
		subTitleHeight = subTitleSize.height;
		
        subTitleLabel.frame = CGRectMake(CUSTOM_SECTION_VIEW_LEFT_LABEL_OFFSET, 
				CUSTOM_SECTION_VIEW_SUBTITLE_TOP, labelWidth, 
				subTitleHeight);
		subTitleLabel.text = self.subTitle;
		

		UIView* customView = [[[UIView alloc] 
                               initWithFrame:CGRectMake(0.0, 0.0, tableWidth, CUSTOM_SECTION_FIXED_HEIGHT + subTitleHeight)] autorelease];
		customView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
       [customView addSubview:headerLabel];
        [customView addSubview:subTitleLabel];

        
        return customView;
       
    }
    else
    {
        return nil;
    }

}


- (CGFloat)sectionViewRightOffset:(BOOL)editing
{
    return 0.0;
}

- (CGFloat)viewHeightForSection
{
    return CUSTOM_SECTION_FIXED_HEIGHT + subTitleHeight;
}

@end
