//
//  SimParams.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Scenario;
@class InputSimInfoCltn;

@interface SimParams : NSObject {
	@private
		NSDate *simStartDate;
		Scenario *simScenario;
		
		InputSimInfoCltn *incomeInfo;
		
		
    
}

@property(nonatomic,retain) NSDate *simStartDate;
@property(nonatomic,retain) Scenario *simScenario;

@property(nonatomic,retain) InputSimInfoCltn *incomeInfo;

- (id)initWithStartDate:(NSDate*)startDate andScenario:(Scenario*)scenario;


@end
