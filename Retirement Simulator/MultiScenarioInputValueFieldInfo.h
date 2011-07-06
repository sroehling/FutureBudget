//
//  MultiScenarioValueFieldInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ManagedObjectFieldInfo.h"

@class Scenario;

@interface MultiScenarioInputValueFieldInfo : ManagedObjectFieldInfo {
    @private
		Scenario *currentScenario;
}

-(id)initWithScenario:(Scenario*)theScenario
	 andManagedObject:(NSManagedObject*)theManagedObject
		  andFieldKey:(NSString*)theFieldKey
		andFieldLabel:(NSString*)theFieldLabel
  andFieldPlaceholder:(NSString*)thePlaceholder;

- (id)getFieldValue;
- (void)setFieldValue:(id)newValue;
- (BOOL)fieldIsInitializedInParentObject;

@property(nonatomic,retain) Scenario *currentScenario;

@end
