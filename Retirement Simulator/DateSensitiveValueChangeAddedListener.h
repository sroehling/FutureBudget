//
//  DateSensitiveValueChangeAddedListener.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FinishedAddingObjectListener.h"
#import "VariableValue.h"

@interface DateSensitiveValueChangeAddedListener : NSObject <FinishedAddingObjectListener> {
    @private
		VariableValue *valueToAddTo;
}

@property(nonatomic,retain) VariableValue *valueToAddTo;

- (id)initWithVariableValue:(VariableValue*)variableValue;

@end
