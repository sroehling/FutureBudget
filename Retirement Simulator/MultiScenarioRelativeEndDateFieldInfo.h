//
//  MultiScenarioRelativeEndDateFieldInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldInfo.h"

@class Scenario;
@class MultiScenarioInputValue;

@interface MultiScenarioRelativeEndDateFieldInfo : FieldInfo {
    @private
		Scenario *currentScen;
		MultiScenarioInputValue *inputVal;
}

@property(nonatomic,retain) Scenario *currentScen;
@property(nonatomic,retain) MultiScenarioInputValue *inputVal;

-(id)initWithFieldLabel:(NSString *)theFieldLabel andFieldPlaceholder:(NSString *)thePlaceholder
	andScenario:(Scenario*)currScenario andInputVal:(MultiScenarioInputValue*)theInputVal;


@end
