//
//  AppHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/14/12.
//
//

#import "AppHelper.h"
#import "DataModelController.h"
#import "AppDelegate.h"


NSString * const APP_DATA_DATA_MODEL_NAME = @"DataModel";

// TODO - Plug in real APP ID
NSString * const FINSIM_APP_ID = @"572539748";

@implementation AppHelper

+(DataModelController*)appDataModelControllerForPlanName:(NSString*)planName
{
	// Each plan resides in a separate SQL lite database file
	NSString *planFileName = [NSString stringWithFormat:@"%@.sqlite",planName];

	DataModelController *appDmc = 
		[[[DataModelController alloc] 
			initForDatabaseUsageWithDataModelNamed:APP_DATA_DATA_MODEL_NAME
			andStoreNamed:planFileName] autorelease];
			
	return appDmc;
}

+(DataModelController*)subDataModelControllerForCurrentPlan
{
	AppDelegate *appDelegate = [AppHelper theAppDelegate];
	
	assert(appDelegate.currentPlanDmc != nil);
	
	DataModelController *subDmc = [[[DataModelController alloc]
			initWithPersistentStoreCoord:appDelegate.currentPlanDmc.persistentStoreCoordinator] autorelease];
			
	return subDmc;
	
}


+(AppDelegate*)theAppDelegate
{
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	assert(appDelegate != nil);
	return appDelegate;	
}


+(BOOL)generatingLaunchScreen
{
	// To (re)generate the launch screens, temporarily
	// return TRUE, then copy the screens from the
	// screens from the simulator.
//	return TRUE;
	return FALSE;
}


@end
