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
@class MultiScenarioInputValue;
@class FieldInfo;

@interface DateSensitiveValueFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
    @private 
		FieldInfo *defaultFixedValFieldInfo;
		VariableValueRuntimeInfo *varValRuntimeInfo;
		ValueSubtitleTableCell *valueCell;
		BOOL isForNewValue;

}

@property(nonatomic,retain) VariableValueRuntimeInfo *varValRuntimeInfo;
@property BOOL isForNewValue;

- (id)initWithFieldInfo:(FieldInfo *)theFieldInfo 
	andDefaultFixedValFieldInfo:(FieldInfo*)theDefaultFieldInfo
      andValRuntimeInfo:(VariableValueRuntimeInfo *)theVarValRuntimeInfo
	  andForNewVal:(BOOL)forNewVal;

@property(nonatomic,retain) FieldInfo *defaultFixedValFieldInfo;
@property(nonatomic,retain) ValueSubtitleTableCell *valueCell;

+ (DateSensitiveValueFieldEditInfo*)createForObject:
			(NSManagedObject*)obj andKey:(NSString*)key andLabel:(NSString*)label andValRuntimeInfo:(VariableValueRuntimeInfo *)varValRuntimeInfo
				andDefaultFixedValKey:(NSString*)defaultFixedValKey
				andForNewVal:(BOOL)forNewVal;

+ (DateSensitiveValueFieldEditInfo*)createForScenario:(Scenario*)theScenario 
	andMultiScenFixedVal:(MultiScenarioInputValue*)multiScenFixedVal
	andLabel:(NSString*)label andValRuntimeInfo:(VariableValueRuntimeInfo *)varValRuntimeInfo andDefaultFixedVal:(MultiScenarioInputValue*)defaultFixedVal
		andForNewVal:(BOOL)forNewVal;

@end
