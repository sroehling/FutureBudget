//
//  UserScenario.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Scenario.h"

extern NSString * const USER_SCENARIO_ENTITY_NAME;
extern NSString * const USER_SCENARIO_NAME_KEY;
extern NSString * const USER_SCENARIO_NOTES_KEY;

@interface UserScenario : Scenario {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;


@end
