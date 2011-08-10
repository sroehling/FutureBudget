//
//  VariableDateFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@class FieldInfo;
@class SimDateRuntimeInfo;

@interface SimDateFormInfoCreator : NSObject <FormInfoCreator> {
    @private
        FieldInfo *fieldInfo;
        FieldInfo *fixedDateFieldInfo;
		FieldInfo *defaultRelEndDateFieldInfo;
		SimDateRuntimeInfo *varDateRuntimeInfo;
		bool showEndDates;
}

- (id)initWithVariableDateFieldInfo:(FieldInfo*)vdFieldInfo 
             andDefaultValFieldInfo:(FieldInfo*)theDefaultFieldInfo
			 andVarDateRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo
			 andDoShowEndDates:(bool)doShowEndDates
			 andDefaultRelEndDateFieldInfo:(FieldInfo*)theDefaultRelEndDateFieldInfo;

@property(nonatomic,retain) FieldInfo *fieldInfo;
@property(nonatomic,retain) FieldInfo* fixedDateFieldInfo;
@property(nonatomic,retain) FieldInfo *defaultRelEndDateFieldInfo;
@property(nonatomic,retain) SimDateRuntimeInfo *varDateRuntimeInfo;

@end
