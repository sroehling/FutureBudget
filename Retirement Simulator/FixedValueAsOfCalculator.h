//
//  FixedValueAsOfCalculator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValueAsOfCalculator.h"

@class FixedValue;


@interface FixedValueAsOfCalculator : NSObject <ValueAsOfCalculator> {
    @private
		FixedValue *fixedVal;
}

-(id) initWithFixedValue:(FixedValue*)theFixedValue;

@property(nonatomic,retain) FixedValue *fixedVal;

@end
