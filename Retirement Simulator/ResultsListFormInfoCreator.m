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
#import "AllAssetValueXYPlotDataGenerator.h"
#import "AssetValueXYPlotDataGenerator.h"
#import "AssetInput.h"


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

	[self.simResultsController runSimulatorForResults];

    FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"RESULTS_NAV_CONTROLLER_BUTTON_TITLE");
	
	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"RESULTS_SUMMARY_SECTION_TITLE");
	
	if(true)
	{
		ResultsViewInfo *netWorthViewInfo = [[[ResultsViewInfo alloc] 
			initWithSimResultsController:self.simResultsController 
			andViewTitle:LOCALIZED_STR(@"RESULTS_SUMMARY_NET_WORTH_TITLE")] autorelease];
		ResultsViewFactory *netWorthViewFactory = 
			[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:netWorthViewInfo
				andPlotDataGenerator:[[[NetWorthXYPlotDataGenerator alloc]init]autorelease]] autorelease];
		StaticNavFieldEditInfo *netWorthFieldEditInfo = 
			[[[StaticNavFieldEditInfo alloc] 
				initWithCaption:LOCALIZED_STR(@"RESULTS_SUMMARY_NET_WORTH_TITLE")
				andSubtitle:LOCALIZED_STR(@"RESULTS_SUMMARY_NET_WORTH_SUBTITLE") 
				andContentDescription:nil
				andSubViewFactory:netWorthViewFactory] autorelease];
		[sectionInfo addFieldEditInfo:netWorthFieldEditInfo];		
	}


	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"RESULTS_ASSET_SECTION_TITLE");
	if(true)
	{
		ResultsViewInfo *allAssetsViewInfo = [[[ResultsViewInfo alloc] 
			initWithSimResultsController:self.simResultsController 
			andViewTitle:LOCALIZED_STR(@"RESULTS_ASSET_ALL_ASSET_TITLE")] autorelease];
		ResultsViewFactory *allAssetsViewFactory = 
			[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:allAssetsViewInfo
				andPlotDataGenerator:[[[AllAssetValueXYPlotDataGenerator alloc]init]autorelease]] autorelease];
		StaticNavFieldEditInfo *allAssetsFieldEditInfo = 
			[[[StaticNavFieldEditInfo alloc] 
				initWithCaption:LOCALIZED_STR(@"RESULTS_ASSET_ALL_ASSET_TITLE")
				andSubtitle:LOCALIZED_STR(@"RESULTS_ASSET_ALL_ASSET_SUBTITLE") 
				andContentDescription:nil
				andSubViewFactory:allAssetsViewFactory] autorelease];
		[sectionInfo addFieldEditInfo:allAssetsFieldEditInfo];
		
		for(AssetInput *asset in self.simResultsController.assetsSimulated)
		{
			ResultsViewInfo *assetViewInfo = [[[ResultsViewInfo alloc] 
				initWithSimResultsController:self.simResultsController 
				andViewTitle:asset.name] autorelease];
			ResultsViewFactory *assetViewFactory = 
				[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:assetViewInfo
					andPlotDataGenerator:[[[AssetValueXYPlotDataGenerator alloc]initWithAsset:asset]autorelease]] autorelease];
			StaticNavFieldEditInfo *assetFieldEditInfo = 
				[[[StaticNavFieldEditInfo alloc] 
					initWithCaption:asset.name
					andSubtitle:@"" 
					andContentDescription:nil
					andSubViewFactory:assetViewFactory] autorelease];
			[sectionInfo addFieldEditInfo:assetFieldEditInfo];
		}
	}
	

	
	return formPopulator.formInfo;
	
}

-(void)dealloc
{
	[super dealloc];
	[simResultsController release];
}


@end
