//
//  FormInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SectionInfo;

#import "FieldEditInfo.h"
#import "TableViewObjectAdder.h"

@interface FormInfo : NSObject {
@private
    NSMutableArray *sections;
    NSString *title;
	id<TableViewObjectAdder> objectAdder; // optional
}

@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) id<TableViewObjectAdder> objectAdder;

- (void) addSection:(SectionInfo*)section;

- (id<FieldEditInfo>)fieldEditInfoIndexPath:(NSIndexPath *)indexPath;

- (NSManagedObject*)objectAtPath:(NSIndexPath *)indexPath;
- (NSIndexPath*)pathForObject:(NSManagedObject *)object;

- (NSUInteger)numSections;
- (SectionInfo*)sectionInfoAtIndex:(NSUInteger)sectionIndex;

- (BOOL)allFieldsInitialized;
- (void)disableFieldChanges;

- (NSIndexSet*)sectionIndicesNeedingRefreshForEditMode;


@end
