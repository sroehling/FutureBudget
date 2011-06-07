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

@interface VariableValueFieldEditInfo : NSObject <FieldEditInfo> {
    @private
    VariableValue *variableVal;
}

@property(nonatomic,retain) VariableValue *variableVal;

- (id)initWithVariableValue:(VariableValue*)varValue;

@end
