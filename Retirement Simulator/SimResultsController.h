//
//  SimResultsController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SimResultsController : NSObject {
	@private
		NSMutableArray *endOfYearResults;
		NSInteger resultMinYear;
		NSInteger resultMaxYear;
    
}

@property(nonatomic,retain) NSMutableArray *endOfYearResults;
@property NSInteger resultMinYear;
@property NSInteger resultMaxYear;

- (void) runSimulatorForResults;

@end
