//
//  DigestEntryProcessingParams.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WorkingBalanceMgr;

@interface DigestEntryProcessingParams : NSObject {
    @private
		NSInteger dayIndex;
		NSDate *currentDate;
		WorkingBalanceMgr *workingBalanceMgr;
}

@property(nonatomic,retain) WorkingBalanceMgr *workingBalanceMgr;
@property NSInteger dayIndex;
@property(nonatomic,retain) NSDate *currentDate;

-(id)initWithWorkingBalanceMgr:(WorkingBalanceMgr*)theWorkingBalanceMgr
	andDayIndex:(NSInteger)theDayIndex andCurrentDate:(NSDate*)theCurrentDate;

@end
