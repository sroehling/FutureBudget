//
//  Scenario.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const SCENARIO_DEFAULT_ICON_IMAGE_NAME;
extern NSString * const SCENARIO_ICON_IMAGE_NAME_KEY;

@class SharedAppValues;

@interface Scenario : NSManagedObject {
@private
	BOOL isSelectedForSelectableObjectTableView;
}

// Inverse property
@property (nonatomic, retain) NSSet* scenarioValueScenario;
@property (nonatomic, retain) NSString * iconImageName;
@property (nonatomic, retain) SharedAppValues * sharedAppValsCurrentInputScenario;

@property BOOL isSelectedForSelectableObjectTableView;


- (NSString *)scenarioName;

@end
