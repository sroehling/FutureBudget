//
//  ResultsViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface ResultsViewController : UIViewController <CPTPlotDataSource> {
	@private
		CPTXYGraph *graph;
		
		NSMutableArray *dataForPlot;
		NSInteger resultMinYear;
		NSInteger resultMaxYear;
		double resultMinVal;
		double resultMaxVal;
}

@property(nonatomic,retain) NSMutableArray *dataForPlot;

@end
