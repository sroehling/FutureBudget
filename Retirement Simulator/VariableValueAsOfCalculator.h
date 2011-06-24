//
//  VariableValueAsOfCalculator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValueAsOfCalculator.h"

@class VariableValue;

@interface VariableValueAsOfCalculator : NSObject <ValueAsOfCalculator> {
    @private
		VariableValue *varVal;
		NSArray *sortedValChanges;
}

- (id) initWithVariableValue:(VariableValue*)theVarVal;


@property(nonatomic,retain) VariableValue *varVal;
@property(nonatomic,retain) NSArray *sortedValChanges;

@end
