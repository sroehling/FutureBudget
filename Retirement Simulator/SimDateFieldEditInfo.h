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
@class FixedDate;
@class FieldInfo;
@class MultiScenarioInputValue;
@class SimDateSubtitleFormatter;
@class MultiScenarioInputValue;
@class DataModelController;

@interface SimDateFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
    @private
        FieldInfo *defaultValFieldInfo;
		FieldInfo *defaultRelEndDateFieldInfo;
		ValueSubtitleTableCell *dateCell;
		SimDateSubtitleFormatter *subtitleFormatter;
		SimDateRuntimeInfo *varDateRuntimeInfo;
		bool showEndDates;
}

@property(nonatomic,retain) FieldInfo *defaultValFieldInfo;
@property(nonatomic,retain) FieldInfo *defaultRelEndDateFieldInfo;
@property(nonatomic,retain) ValueSubtitleTableCell *dateCell;
@property(nonatomic,retain) SimDateRuntimeInfo *varDateRuntimeInfo;
@property(nonatomic,retain) SimDateSubtitleFormatter *subtitleFormatter;
	
+ (SimDateFieldEditInfo*)createForDataModelController:(DataModelController*)dataModelController 
		andObject:(NSManagedObject*)obj andKey:(NSString*)key andLabel:(NSString*)label andDefaultFixedDate:(FixedDate*)defaultFixedDate andVarDateRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo 
	andShowEndDates:(bool)doShowEndDates
	andDefaultRelEndDateKey:(NSString*)defaultRelEndDateKey;
			  
+ (SimDateFieldEditInfo*)createForDataModelController:(DataModelController*)dataModelController 
	andMultiScenarioVal:(Scenario*)scenario 
	andSimDate:(MultiScenarioInputValue*)multiScenSimDate andLabel:(NSString*)label
	andDefaultValue:(MultiScenarioInputValue*)defaultVal 
	andVarDateRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo 
	andShowEndDates:(bool)doShowEndDates
	andDefaultRelEndDate:(MultiScenarioInputValue*)defaultRelEndDate;

@end
