//
//  DateSensitiveValueChangeFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@class DateSensitiveValueChange;
@class VariableValueRuntimeInfo;
@class VariableValue;

@interface DateSensitiveValueChangeFormInfoCreator : NSObject <FormInfoCreator> {
    @private
		VariableValue *parentVariableVal;
		VariableValueRuntimeInfo *valRuntimeInfo;
		DateSensitiveValueChange *valueChange;
        BOOL promptForDateWhenFirstEditingStartDate; // optional, defaults to FALSE
}

@property(nonatomic,retain) VariableValue *parentVariableVal;
@property(nonatomic,retain) VariableValueRuntimeInfo *valRuntimeInfo;
@property(nonatomic,retain) DateSensitiveValueChange *valueChange;
@property BOOL promptForDateWhenFirstEditingStartDate;

-(id)initForValueChange:(DateSensitiveValueChange*)theValueChange
						   andVariableValRuntimeInfo:(VariableValueRuntimeInfo*)theValRuntimeInfo
						   andParentVariableValue:(VariableValue*)theVarValue;

@end
