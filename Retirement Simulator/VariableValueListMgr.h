//
//  VariableValueListMgr.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FinishedAddingObjectListener.h"

@class VariableValue;

@protocol VariableValueListMgr <NSObject,FinishedAddingObjectListener>

- (NSArray*)variableValues;
- (VariableValue*)createNewValue;

@end
