//
//  ResultsListFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"
#import "MBProgressHUD.h"
#import "ProgressUpdateDelegate.h"
#import "ProgressCompleteDelegate.h"

@class SimResultsController;

@interface ResultsListFormInfoCreator : NSObject <FormInfoCreator,
	MBProgressHUDDelegate,ProgressUpdateDelegate> {
    @private
		SimResultsController *simResultsController;
		
		id<ProgressCompleteDelegate> simResultsCompleteDelegate;
		MBProgressHUD *simProgressHUD;
}

@property(nonatomic,retain) SimResultsController *simResultsController;
@property(nonatomic,retain) MBProgressHUD *simProgressHUD;
@property(nonatomic,assign) id<ProgressCompleteDelegate> simResultsCompleteDelegate;


@end
