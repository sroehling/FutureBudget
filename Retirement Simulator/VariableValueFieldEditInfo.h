//
//  VariableValueFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"

@class VariableValue;
@class VariableValueRuntimeInfo;
@class ValueSubtitleTableCell;

@interface VariableValueFieldEditInfo : NSObject <FieldEditInfo> {
    @private
    VariableValue *variableVal;
	VariableValueRuntimeInfo *varValRuntimeInfo;
	ValueSubtitleTableCell *varValueCell;
}

@property(nonatomic,retain) VariableValue *variableVal;
@property(nonatomic,retain) VariableValueRuntimeInfo *varValRuntimeInfo;
@property(nonatomic,retain) ValueSubtitleTableCell *varValueCell;

- (id)initWithVariableValue:(VariableValue*)varValue
	   andVarValRuntimeInfo:(VariableValueRuntimeInfo*)varValRuntimeInfo;

@end
