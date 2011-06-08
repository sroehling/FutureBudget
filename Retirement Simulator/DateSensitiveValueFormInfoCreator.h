//
//  DateSensitiveValueFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FixedValue;
@class ManagedObjectFieldInfo;
#import "VariableValueRuntimeInfo.h"
#import "FormInfoCreator.h"

@interface DateSensitiveValueFormInfoCreator : NSObject <FormInfoCreator> {
    @private
        ManagedObjectFieldInfo *fieldInfo;
        FixedValue *defaultFixedVal;
		VariableValueRuntimeInfo *varValRuntimeInfo;
}

- (id)initWithVariableValueFieldInfo:(ManagedObjectFieldInfo*)vvFieldInfo
                  andDefaultFixedVal:(FixedValue*)theDefaultFixedVal
               andVarValRuntimeInfo:(VariableValueRuntimeInfo *) varValRuntimeInfo;

@property(nonatomic,retain) FixedValue *defaultFixedVal;
@property(nonatomic,retain) ManagedObjectFieldInfo *fieldInfo;
@property(nonatomic,retain) VariableValueRuntimeInfo *varValRuntimeInfo;

@end
