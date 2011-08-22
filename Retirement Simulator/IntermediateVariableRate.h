//
//  IntermediateVariableRate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const INTERMEDIATE_VARIABLE_RATE_SECONDS_VS_START_KEY;


@interface IntermediateVariableRate : NSObject {
		double annualRate;
		NSInteger secondsVsStart;
}

@property double annualRate;
@property NSInteger secondsVsStart;

- (id) initWithAnnualRate:(double)annualRate andSecondsVsStart:(NSInteger)seconds;

@end
