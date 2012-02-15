//
//  BoolInputValueFieldInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldInfo.h"

@class Scenario;
@class MultiScenarioInputValue;
@class DataModelController;

@interface MultiScenarioBoolInputValueFieldInfo : FieldInfo {
    @private
		Scenario *currentScen;
		MultiScenarioInputValue *inputVal;
}

@property(nonatomic,retain) Scenario *currentScen;
@property(nonatomic,retain) MultiScenarioInputValue *inputVal;
@property(nonatomic,retain) DataModelController *dataModelController;

-(id)initWithDataModelController:(DataModelController*)theDataModelController
    andFieldLabel:(NSString *)theFieldLabel andFieldPlaceholder:(NSString *)thePlaceholder
	andScenario:(Scenario*)currScenario andInputVal:(MultiScenarioInputValue*)theInputVal;

@end
