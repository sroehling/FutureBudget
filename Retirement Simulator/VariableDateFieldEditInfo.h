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
@class VariableDateRuntimeInfo;

@interface VariableDateFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
    @private
        ManagedObjectFieldInfo *defaultValFieldInfo;
		ValueSubtitleTableCell *dateCell;
		VariableDateRuntimeInfo *varDateRuntimeInfo;
}

@property(nonatomic,retain) ManagedObjectFieldInfo *defaultValFieldInfo;
@property(nonatomic,retain) ValueSubtitleTableCell *dateCell;
@property(nonatomic,retain) VariableDateRuntimeInfo *varDateRuntimeInfo;

+ (VariableDateFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
              andLabel:(NSString*)label andDefaultValueKey:(NSString*)defaultValKey
			  andVarDateRuntimeInfo:(VariableDateRuntimeInfo*)theVarDateRuntimeInfo;

@end
