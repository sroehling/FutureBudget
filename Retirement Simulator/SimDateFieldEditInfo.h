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
@class SimDateRuntimeInfo;

@interface SimDateFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
    @private
        ManagedObjectFieldInfo *defaultValFieldInfo;
		ValueSubtitleTableCell *dateCell;
		SimDateRuntimeInfo *varDateRuntimeInfo;
		bool showNeverEnding;
}

@property(nonatomic,retain) ManagedObjectFieldInfo *defaultValFieldInfo;
@property(nonatomic,retain) ValueSubtitleTableCell *dateCell;
@property(nonatomic,retain) SimDateRuntimeInfo *varDateRuntimeInfo;

+ (SimDateFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
              andLabel:(NSString*)label andDefaultValueKey:(NSString*)defaultValKey
			  andVarDateRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo
			  andShowNeverEnding:(bool)doShowNeverEnding;

@end
