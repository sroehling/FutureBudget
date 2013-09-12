//
//  YearValXYPlotResultsViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "ResultsViewController.h"
#import "ProgressUpdateDelegate.h"
#import "MBProgressHUD.h"

@class CPTXYGraph;

@protocol YearValXYPlotDataGenerator;
@class YearValXYPlotData;
@class YearValXYResultsView;
@class SimResults;

@interface YearValXYPlotResultsViewController : ResultsViewController  {
	@private
		id<YearValXYPlotDataGenerator> plotDataGenerator;
		MBProgressHUD *simProgressHUD;
		YearValXYResultsView *resultsView;
        SimResults *currentSimResults;
}

@property(nonatomic,retain) MBProgressHUD *simProgressHUD;
@property(nonatomic,retain) YearValXYResultsView *resultsView;
@property(nonatomic,retain) id<YearValXYPlotDataGenerator> plotDataGenerator;
@property(nonatomic,retain) SimResults *currentSimResults;

-(id)initWithResultsViewInfo:(ResultsViewInfo *)theViewInfo andPlotDataGenerator:(id<YearValXYPlotDataGenerator>)thePlotDataGenerator;


@end
