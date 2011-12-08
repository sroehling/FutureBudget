//
//  ResultsListFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultsListFormInfoCreator.h"
#import "FormPopulator.h"
#import "LocalizationHelper.h"
#import "SectionInfo.h"
#import "StaticNavFieldEditInfo.h"
#import "ResultsViewFactory.h"
#import "SimResultsController.h"
#import "ResultsViewInfo.h"
#import "YearValXYPlotResultsViewFactory.h"
#import "NetWorthXYPlotDataGenerator.h"


@implementation ResultsListFormInfoCreator

@synthesize simResultsController;

-(id)init
{
	self = [super init];
	if(self)
	{
		self.simResultsController = [[[SimResultsController alloc] init] autorelease];
	}
	return self;
}

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"RESULTS_NAV_CONTROLLER_BUTTON_TITLE");
	
	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"RESULTS_SUMMARY_SECTION_TITLE");
	
	
	ResultsViewInfo *resultsViewInfo = [[[ResultsViewInfo alloc] 
		initWithSimResultsController:self.simResultsController 
		andViewTitle:LOCALIZED_STR(@"RESULTS_SUMMARY_NET_WORTH_TITLE")] autorelease];
	ResultsViewFactory *resultsViewFactory = 
		[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:resultsViewInfo
			andPlotDataGenerator:[[[NetWorthXYPlotDataGenerator alloc]init]autorelease]] autorelease];
	StaticNavFieldEditInfo *netWorthFieldEditInfo = 
		[[[StaticNavFieldEditInfo alloc] 
			initWithCaption:LOCALIZED_STR(@"RESULTS_SUMMARY_NET_WORTH_TITLE")
			andSubtitle:LOCALIZED_STR(@"RESULTS_SUMMARY_NET_WORTH_SUBTITLE") 
			andContentDescription:nil
			andSubViewFactory:resultsViewFactory] autorelease];
	[sectionInfo addFieldEditInfo:netWorthFieldEditInfo];		

	
	return formPopulator.formInfo;
	
}

-(void)dealloc
{
	[super dealloc];
	[simResultsController release];
}


@end
