//
//  DateSensitiveValueFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ManagedObjectFieldEditInfo.h"
#import "VariableValueRuntimeInfo.h"
#import "FieldEditInfo.h"

@class ValueSubtitleTableCell;
@class Scenario;
@class ManagedObjectFieldInfo;
@class MultiScenarioInputValue;
@class FieldInfo;

@interface DateSensitiveValueFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
    @private 
		FieldInfo *defaultFixedValFieldInfo;
		VariableValueRuntimeInfo *varValRuntimeInfo;
		ValueSubtitleTableCell *valueCell;

}

@property(nonatomic,retain) VariableValueRuntimeInfo *varValRuntimeInfo;

- (id)initWithFieldInfo:(ManagedObjectFieldInfo *)theFieldInfo 
    andDefaultFixedValFieldInfo:(FieldInfo*)theDefaultFieldInfo
      andValRuntimeInfo:(VariableValueRuntimeInfo *)varValRuntimeInfo;

@property(nonatomic,retain) FieldInfo *defaultFixedValFieldInfo;
@property(nonatomic,retain) ValueSubtitleTableCell *valueCell;

+ (DateSensitiveValueFieldEditInfo*)createForObject:
			(NSManagedObject*)obj andKey:(NSString*)key andLabel:(NSString*)label andValRuntimeInfo:(VariableValueRuntimeInfo *)varValRuntimeInfo
				andDefaultFixedValKey:(NSString*)defaultFixedValKey;

+ (DateSensitiveValueFieldEditInfo*)createForScenario:(Scenario*)theScenario andObject:
			(NSManagedObject*)obj andKey:(NSString*)key andLabel:(NSString*)label 
			andValRuntimeInfo:(VariableValueRuntimeInfo *)varValRuntimeInfo
				andDefaultFixedVal:(MultiScenarioInputValue*)defaultFixedVal;

@end
