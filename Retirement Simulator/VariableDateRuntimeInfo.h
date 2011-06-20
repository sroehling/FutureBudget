//
//  VariableDateRuntimeInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CashFlowInput;
@class VariableValueRuntimeInfo;

@interface VariableDateRuntimeInfo : NSObject {
    
}

+ (VariableDateRuntimeInfo*)createForCashFlowStartDate:(CashFlowInput*)cashFlow;
+ (VariableDateRuntimeInfo*)createForCashFlowEndDate:(CashFlowInput*)cashFlow;
+ (VariableDateRuntimeInfo*)createForDateSensitiveValue:(VariableValueRuntimeInfo*)valRuntimeInfo;

@end
