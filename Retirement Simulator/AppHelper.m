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
#import "StringValidation.h"
#import "SharedAppValues.h"


NSString * const APP_DATA_DATA_MODEL_NAME = @"DataModel";
NSString * const PLAN_DATA_FILE_EXTENSION = @"sqlite";

// TODO - Plug in real APP ID
NSString * const FINSIM_APP_ID = @"572539748";

NSString * const CURRENT_PLAN_NAME_KEY = @"CURRENT_PLAN_FILE_NAME";

@implementation AppHelper

+(DataModelController*)appDataModelControllerForPlanName:(NSString*)planName
{
	// Each plan resides in a separate SQL lite database file
	NSString *planFileName = [NSString stringWithFormat:@"%@.%@",planName,PLAN_DATA_FILE_EXTENSION];

	DataModelController *appDmc = 
		[[[DataModelController alloc] 
			initForDatabaseUsageWithDataModelNamed:APP_DATA_DATA_MODEL_NAME
			andStoreNamed:planFileName] autorelease];
			
	return appDmc;
}

+(DataModelController*)openPlanForPlanName:(NSString*)planName
{
	DataModelController *planDmc = [AppHelper appDataModelControllerForPlanName:planName];
	[SharedAppValues initFromDatabase:planDmc];
	return planDmc;
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


+(void)setCurrentPlanName:(NSString*)planName
{
	assert([StringValidation nonEmptyString:planName]);
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setValue:planName forKey:CURRENT_PLAN_NAME_KEY];
	[userDefaults synchronize];
}

+(NSString*)currentPlanName
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	return [userDefaults stringForKey:CURRENT_PLAN_NAME_KEY];
}



@end
