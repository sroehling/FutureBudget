//
//  InputCreationHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MultiScenarioInputValue;

@interface InputCreationHelper : NSObject {
    
}

// TODO - move the rest of the helper methods from input type selection info to this class.
+ (MultiScenarioInputValue*)multiScenFixedValWithDefault:(double)defaultVal;

@end
