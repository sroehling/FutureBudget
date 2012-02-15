//
//  SectionInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"
@class SectionHeaderWithSubtitle;
@class FormContext;

@interface SectionInfo : NSObject {
@private
    NSMutableArray *fieldEditInfo;
    NSString *title;
	NSString *helpInfoHTMLFile;
	SectionHeaderWithSubtitle *sectionHeader;
	FormContext *formContext;
}

@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *helpInfoHTMLFile;
@property(nonatomic,retain) SectionHeaderWithSubtitle *sectionHeader;
@property(nonatomic,retain) FormContext *formContext;

- (void) addFieldEditInfo:(id<FieldEditInfo>)fieldEditInfo;

- (id<FieldEditInfo>)fieldEditInfoAtRowIndex:(NSUInteger)rowIndex;
- (void)removeFieldEditInfoAtRowIndex:(NSUInteger)rowIndex;

- (NSInteger)numFields;
- (BOOL)allFieldsInitialized;
- (void)disableFieldChanges;
- (NSInteger)findObjectRow:(NSManagedObject*)object;
- (id<FieldEditInfo>)findSelectedFieldEditInfo;
- (id<FieldEditInfo>)findDefaultSelection;
- (void)unselectAllFields;

- (UIView*)viewForSectionHeader:(CGFloat)tableWidth andEditMode:(BOOL)editing;
- (CGFloat)viewHeightForSection;

- (id) initWithFormContext:(FormContext*)theFormContext;
- (id) initWithHelpInfo:(NSString*)helpInfoFile andFormContext:(FormContext*)theFormContext;
    
@end
