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
@class DateHelper;

@interface MilestoneDateFieldEditInfo : NSObject <FieldEditInfo> {
    @private
        MilestoneDate *milestoneDate;
		ValueSubtitleTableCell *milestoneCell;
		SimDateRuntimeInfo *varDateRuntimeInfo;
		UIViewController *parentController;
        DateHelper *dateHelper;
}


- (id)initWithMilestoneDate:(MilestoneDate*)theMilestoneDate 
	  andVarDateRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo
	  andParentController:(UIViewController *)theParentController;

@property(nonatomic,retain) MilestoneDate *milestoneDate;
@property(nonatomic,retain) ValueSubtitleTableCell *milestoneCell;
@property(nonatomic,retain) SimDateRuntimeInfo *varDateRuntimeInfo;
@property(nonatomic,assign) UIViewController *parentController;
@property(nonatomic,retain) DateHelper *dateHelper;

@end
