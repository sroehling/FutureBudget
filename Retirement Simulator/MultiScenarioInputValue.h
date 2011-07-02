//
//  MultiScenarioInputValue.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ScenarioValue;

@interface MultiScenarioInputValue : NSManagedObject {
@private
}
@property (nonatomic, retain) NSSet* scenarioVals;

@end
