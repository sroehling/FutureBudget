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
@class Scenario;
@class FieldInfo;
@class MultiScenarioInputValue;

@interface SimDateFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
    @private
        FieldInfo *defaultValFieldInfo;
		FieldInfo *defaultRelEndDateFieldInfo;
		ValueSubtitleTableCell *dateCell;
		SimDateRuntimeInfo *varDateRuntimeInfo;
		bool showEndDates;
}

@property(nonatomic,retain) FieldInfo *defaultValFieldInfo;
@property(nonatomic,retain) FieldInfo *defaultRelEndDateFieldInfo;
@property(nonatomic,retain) ValueSubtitleTableCell *dateCell;
@property(nonatomic,retain) SimDateRuntimeInfo *varDateRuntimeInfo;

+ (SimDateFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key andLabel:(NSString*)label andDefaultValueKey:(NSString*)defaultValKey andVarDateRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo 
	andShowEndDates:(bool)doShowEndDates
	andDefaultRelEndDateKey:(NSString*)theDefaultRelEndDateKey;
			  
+ (SimDateFieldEditInfo*)createForMultiScenarioVal:(Scenario*)scenario 
	andObject:(NSManagedObject*)obj andKey:(NSString*)key andLabel:(NSString*)label
	andDefaultValue:(MultiScenarioInputValue*)defaultVal 
	andVarDateRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo 
	andShowEndDates:(bool)doShowEndDates
	andDefaultRelEndDate:(MultiScenarioInputValue*)defaultRelEndDate;

@end
