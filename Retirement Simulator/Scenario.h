//
//  Scenario.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Scenario : NSManagedObject {
@private
}

// Inverse property
@property (nonatomic, retain) NSSet* scenarioValueScenario;


- (NSString *)scenarioName;

@end
