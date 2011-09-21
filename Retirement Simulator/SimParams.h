//
//  SimParams.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Scenario;

@interface SimParams : NSObject {
	@private
		NSDate *simStartDate;
		Scenario *simScenario;
    
}

@property(nonatomic,retain) NSDate *simStartDate;
@property(nonatomic,retain) Scenario *simScenario;

- (id)initWithStartDate:(NSDate*)startDate andScenario:(Scenario*)scenario;


@end
