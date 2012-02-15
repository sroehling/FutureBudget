//
//  MultiScenarioAmountVariableValueListMgr.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VariableValueListMgr.h"

@class MultiScenarioAmount;
@class DataModelController;

@interface MultiScenarioAmountVariableValueListMgr : NSObject <VariableValueListMgr> {
    @private
		MultiScenarioAmount *amount;
		DataModelController *dataModelController;
}

-(id)initWithDataModelController:(DataModelController*)theDataModelController 
	andMultiScenarioAmount:(MultiScenarioAmount *)theAmount;

@property(nonatomic,retain) MultiScenarioAmount *amount;
@property(nonatomic,retain) DataModelController *dataModelController;

@end
