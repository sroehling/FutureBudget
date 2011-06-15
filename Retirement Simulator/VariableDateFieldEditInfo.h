//
//  VariableDateFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"
#import "ManagedObjectFieldEditInfo.h"

@class ValueSubtitleTableCell;

@interface VariableDateFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
    @private
        ManagedObjectFieldInfo *defaultValFieldInfo;
		ValueSubtitleTableCell *dateCell;
}

@property(nonatomic,retain) ManagedObjectFieldInfo *defaultValFieldInfo;
@property(nonatomic,retain) ValueSubtitleTableCell *dateCell;

+ (VariableDateFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
              andLabel:(NSString*)label andDefaultValueKey:(NSString*)defaultValKey;

@end
