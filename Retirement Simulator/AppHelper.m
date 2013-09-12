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

NSString * const FUTURE_BUDGET_APP_ID = @"668648687";

NSString * const CURRENT_PLAN_NAME_KEY = @"CURRENT_PLAN_FILE_NAME";

@implementation AppHelper

+(DataModelController*)appDataModelControllerForPlanName:(NSString*)planName
{
	// Each plan resides in a separate SQL lite database file
	NSString *planFileName = [NSString stringWithFormat:@"%@.%@",planName,PLAN_DATA_FILE_EXTENSION];

    // Init with a NSMainQueueConcurrencyType, since a child
    // NSManagedObjectContext will be used for the forecast
    // results generation.
	DataModelController *appDmc = 
		[[[DataModelController alloc] 
			initForDatabaseUsageWithDataModelNamed:APP_DATA_DATA_MODEL_NAME
			andStoreNamed:planFileName
            andConcurrencyType:NSMainQueueConcurrencyType] autorelease];
			
	return appDmc;
}

+(DataModelController*)openPlanForPlanName:(NSString*)planName
{
	DataModelController *planDmc = [AppHelper appDataModelControllerForPlanName:planName];
    
    // Since this method opens a "main" DataModelController (and underlying NSManagedObjectContect),
    // the merge policy must be set to let the store trump what is in the managed object context.
    // Changes made for new objects will need to trump any changes in the main object context.
    [planDmc.managedObjectContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];

    
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
