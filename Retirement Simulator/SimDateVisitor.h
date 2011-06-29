//
//  SimDateVisitor.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MilestoneDate;
@class NeverEndDate;
@class FixedDate;
// @class RelativeEndDate

@protocol SimDateVisitor <NSObject>

- (void)visitMilestoneDate:(MilestoneDate*)milestoneDate;
- (void)visitNeverEndDate:(NeverEndDate*)neverEndDate;
- (void)visitFixedDate:(FixedDate*)fixedDate;

@end
