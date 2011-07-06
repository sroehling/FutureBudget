//
//  SharedAppValues.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NeverEndDate;
@class DefaultScenario;
@class Scenario;

extern NSString * const SHARED_APP_VALUES_ENTITY_NAME;
extern NSString * const SHARED_APP_VALUES_CURRENT_SCENARIO_KEY;

@interface SharedAppValues : NSManagedObject {
@private
}
@property (nonatomic, retain) NeverEndDate * sharedNeverEndDate;
@property (nonatomic, retain) DefaultScenario *defaultScenario;
@property (nonatomic,retain) Scenario *currentScenario;

@end
