//
//  DateSensitiveValueVisitor.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FixedValue;
@class VariableValue;

@protocol DateSensitiveValueVisitor <NSObject>

- (void)visitFixedValue:(FixedValue*)fixedVal;
- (void)visitVariableValue:(VariableValue*)variableVal;

@end
