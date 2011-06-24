//
//  ValueAsOfCalculatorCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DateSensitiveValueVisitor.h"
#import "ValueAsOfCalculator.h"

@class DateSensitiveValue;

@interface ValueAsOfCalculatorCreator : NSObject <DateSensitiveValueVisitor> {
    @private
		id<ValueAsOfCalculator> valueCalc;
}

- (id<ValueAsOfCalculator>) createForDateSensitiveValue:(DateSensitiveValue*)dsVal ;

@property(nonatomic,retain) id<ValueAsOfCalculator> valueCalc;

@end
