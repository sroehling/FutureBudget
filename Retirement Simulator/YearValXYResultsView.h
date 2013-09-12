//
//  YearValXYResultsView.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YearValXYPlotDataGenerator.h"
#import "CorePlot-CocoaTouch.h"

@class YearValXYPlotData;
@class ResultsViewInfo;
@class CPTGraphHostingView;

@interface YearValXYResultsView : UIView <CPTPlotDataSource,UITableViewDataSource,UITableViewDelegate>
{
	@private
		ResultsViewInfo *resultsViewInfo;
	
		UIView *chartContentView;
		id<YearValXYPlotDataGenerator> plotDataGenerator;
		YearValXYPlotData *currentData;
		CPTGraphHostingView *graphView;
		
		UITableView *tabularDataView;
		
		UISegmentedControl *resultsTypeSelection;
		
		UILabel *footerLabel;
		
		UILabel *yearColLabel;
		UILabel *valColLabel;
		UIView *headerView;
    
        BOOL adjustResultsToSimStartDate;

}

@property(nonatomic,retain) UIView *chartContentView;
@property(nonatomic,retain) id<YearValXYPlotDataGenerator> plotDataGenerator;
@property(nonatomic,retain) YearValXYPlotData *currentData;
@property(nonatomic,retain) ResultsViewInfo *resultsViewInfo;
@property(nonatomic,retain) CPTGraphHostingView *graphView;
@property(nonatomic,retain) UISegmentedControl *resultsTypeSelection;
@property(nonatomic,retain) UITableView *tabularDataView;

@property(nonatomic,retain) UILabel *yearColLabel;
@property(nonatomic,retain) UILabel *valColLabel;
@property(nonatomic,retain) UIView *headerView;
@property(nonatomic,retain) UILabel *footerLabel;

-(id)initWithResultsViewInfo:(ResultsViewInfo *)theViewInfo 
	andPlotDataGenerator:(id<YearValXYPlotDataGenerator>)thePlotDataGenerator;
-(void)generateResults;

@end
