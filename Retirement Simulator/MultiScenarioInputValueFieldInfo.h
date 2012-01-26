//
//  MultiScenarioValueFieldInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ManagedObjectFieldInfo.h"
#import "FieldInfo.h"

@class Scenario;
@class MultiScenarioInputValue;

@interface MultiScenarioInputValueFieldInfo : FieldInfo {
    @private
		Scenario *currentScenario;
		MultiScenarioInputValue *multiScenInputVal;
}

-(id)initWithScenario:(Scenario*)theScenario 
	andMultiScenarioInputVal:(MultiScenarioInputValue*)theMultiScenInputVal
	andFieldLabel:(NSString*)theFieldLabel
			andFieldPlaceholder:(NSString*)thePlaceholder;

- (id)getFieldValue;
- (void)setFieldValue:(NSObject*)newValue;
- (BOOL)fieldIsInitializedInParentObject;

@property(nonatomic,retain) Scenario *currentScenario;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenInputVal;

@end
