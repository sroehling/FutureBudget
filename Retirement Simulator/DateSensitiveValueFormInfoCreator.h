//
//  DateSensitiveValueFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FixedValue;
@class FieldInfo;
#import "VariableValueRuntimeInfo.h"
#import "FormInfoCreator.h"

@interface DateSensitiveValueFormInfoCreator : NSObject <FormInfoCreator> {
    @private
        FieldInfo *fieldInfo;
        FieldInfo *defaultValFieldInfo;
		VariableValueRuntimeInfo *varValRuntimeInfo;
}

- (id)initWithVariableValueFieldInfo:(FieldInfo*)vvFieldInfo
                  andDefaultValFieldInfo:(FieldInfo*)theDefaultValFieldInfo
               andVarValRuntimeInfo:(VariableValueRuntimeInfo *) varValRuntimeInfo;

@property(nonatomic,retain) FieldInfo *defaultValFieldInfo;
@property(nonatomic,retain) FieldInfo *fieldInfo;
@property(nonatomic,retain) VariableValueRuntimeInfo *varValRuntimeInfo;

@end
