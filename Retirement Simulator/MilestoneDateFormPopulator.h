//
//  MilestoneDateFormPopulator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormPopulator.h"

@class MilestoneDate;
@class VariableDateRuntimeInfo;

@interface MilestoneDateFormPopulator : FormPopulator {
    @private
		VariableDateRuntimeInfo *varDateRuntimeInfo;
}

@property(nonatomic,retain) VariableDateRuntimeInfo *varDateRuntimeInfo;

-(id) initWithRuntimeInfo:(VariableDateRuntimeInfo*)theRuntimeInfo;

- (UIViewController*)milestoneDateAddViewController:(MilestoneDate*)milestoneDate;
- (UIViewController*)milestoneDateEditViewController:(MilestoneDate*)milestoneDate;

@end
