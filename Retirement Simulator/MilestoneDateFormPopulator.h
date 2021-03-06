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
@class SimDateRuntimeInfo;
@class FormContext;

@interface MilestoneDateFormPopulator : FormPopulator {
    @private
		SimDateRuntimeInfo *varDateRuntimeInfo;
}

@property(nonatomic,retain) SimDateRuntimeInfo *varDateRuntimeInfo;

-(id) initWithRuntimeInfo:(SimDateRuntimeInfo*)theRuntimeInfo
	andFormContext:(FormContext*)theFormContext;

- (UIViewController*)milestoneDateAddViewController:(MilestoneDate*)milestoneDate;
- (UIViewController*)milestoneDateEditViewController:(MilestoneDate*)milestoneDate;

@end
