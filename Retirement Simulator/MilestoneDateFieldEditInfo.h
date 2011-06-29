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
@class ValueSubtitleTableCell;
@class SimDateRuntimeInfo;

@interface MilestoneDateFieldEditInfo : NSObject <FieldEditInfo> {
    @private
        MilestoneDate *milestoneDate;
		ValueSubtitleTableCell *milestoneCell;
		SimDateRuntimeInfo *varDateRuntimeInfo;
}

+ (MilestoneDateFieldEditInfo*)createForMilestoneDate:(MilestoneDate*)theMilestoneDate
	andVarDateRuntimeInfo:(SimDateRuntimeInfo*)varDateRuntimeInfo;


- (id)initWithMilestoneDate:(MilestoneDate*)theMilestoneDate
	  andVarDateRuntimeInfo:(SimDateRuntimeInfo*)varDateRuntimeInfo;

@property(nonatomic,retain) MilestoneDate *milestoneDate;
@property(nonatomic,retain) ValueSubtitleTableCell *milestoneCell;
@property(nonatomic,retain) SimDateRuntimeInfo *varDateRuntimeInfo;

@end
