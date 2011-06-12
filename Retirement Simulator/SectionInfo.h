//
//  SectionInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"

@interface SectionInfo : NSObject {
@private
    NSMutableArray *fieldEditInfo;
    NSString *title;
	NSString *subTitle;
	CGFloat subTitleHeight;
}

@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *subTitle;

- (void) addFieldEditInfo:(id<FieldEditInfo>)fieldEditInfo;

- (id<FieldEditInfo>)fieldEditInfoAtRowIndex:(NSUInteger)rowIndex;
- (NSInteger)numFields;
- (BOOL)allFieldsInitialized;
- (void)disableFieldChanges;
- (NSInteger)findObjectRow:(NSManagedObject*)object;

- (CGFloat)sectionViewRightOffset:(BOOL)editing;
- (UIView*)viewForSectionHeader:(CGFloat)tableWidth andEditMode:(BOOL)editing;
- (CGFloat)viewHeightForSection;
    
@end
