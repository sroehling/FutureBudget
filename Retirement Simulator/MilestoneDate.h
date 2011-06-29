//
//  MilestoneDate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SimDate.h"

@interface MilestoneDate : SimDate {
@private
}
@property (nonatomic, retain) NSString * name;

@end

extern NSString * const MILESTONE_DATE_ENTITY_NAME;
