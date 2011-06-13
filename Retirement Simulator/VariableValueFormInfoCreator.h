//
//  VariableValueFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"


@class VariableValue;
@class VariableValueRuntimeInfo;

@interface VariableValueFormInfoCreator : NSObject <FormInfoCreator> {
	@private
		VariableValue *variableValue;
		VariableValueRuntimeInfo *varValRuntimeInfo;
}

- (id)initWithVariableValue:(VariableValue*)theValue
	 andVarValueRuntimeInfo:(VariableValueRuntimeInfo*)varValRuntimeInfo;

@property(nonatomic,retain) VariableValue *variableValue;
@property(nonatomic,retain) VariableValueRuntimeInfo *varValRuntimeInfo;

@end
