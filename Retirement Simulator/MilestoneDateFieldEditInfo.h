//
//  MilestoneDateFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"
#import "ManagedObjectFieldEditInfo.h"
@class MilestoneDate;

@interface MilestoneDateFieldEditInfo : NSObject <FieldEditInfo> {
    @private
        MilestoneDate *milestoneDate;
}

+ (MilestoneDateFieldEditInfo*)createForMilestoneDate:(MilestoneDate*)theMilestoneDate;

- (id)initWithMilestoneDate:(MilestoneDate*)theMilestoneDate;

@property(nonatomic,retain) MilestoneDate *milestoneDate;

@end
