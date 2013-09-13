//
//  Retirement_SimulatorAppDelegate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "DataModelController.h"

#import "InputListFormInfoCreator.h"
#import "WhatIfFormInfoCreator.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "ScenarioListFormInfoCreator.h"
#import "SelectableObjectTableEditViewController.h"
#import "InputListTableViewController.h"
#import "SharedAppValues.h"
#import "LocalizationHelper.h"
#import "ManagedObjectFieldInfo.h"
#import "StartingValsFormInfoCreator.h"
#import "ResultsListFormInfoCreator.h"
#import "SimResultsController.h"
#import "ColorHelper.h"
#import "MoreFormInfoCreator.h"
#import "PasscodeHelper.h"
#import "Appirater.h"
#import "AppHelper.h"
#import "ResultsListTableViewController.h"

#import "FormPopulator.h"
#import "FormContext.h"
#import "StringValidation.h"

@implementation AppDelegate

@synthesize window=_window;
@synthesize tabBarController=_tabBarController;
@synthesize passcodeValidator;
@synthesize currentPlanDmc;

@synthesize inputViewController;
@synthesize startingValsController;
@synthesize resultsController;
@synthesize whatIfController;
@synthesize moreController;

- (void)dealloc
{
    [_window release];

    [_tabBarController release];
	[passcodeValidator release];
	
	[currentPlanDmc release];
	
	[inputViewController release];
	[startingValsController release];
	[resultsController release];
	[whatIfController release];
	[moreController release];
		
    [super dealloc];
}


-(void)configWithMainTabBarController
{
	self.window.rootViewController = self.tabBarController;
	
	if(![AppHelper generatingLaunchScreen])
	{
		[Appirater appLaunched:YES];
	}
	
}

-(void)configStartingViewController
{
	if([PasscodeHelper passcodeIsEnabled])
	{
		PTPasscodeViewController *passcodeViewController = 
			[[[PTPasscodeViewController alloc] initWithDelegate:self.passcodeValidator] autorelease];
		UINavigationController *passcodeNavController = [[[UINavigationController alloc]
			   initWithRootViewController:passcodeViewController] autorelease];
		self.window.rootViewController = passcodeNavController;
	}
	else 
	{
		[self configWithMainTabBarController];
	}

}

-(void)configureReviewAppPrompt
{
	[Appirater setAppId:FUTURE_BUDGET_APP_ID];
    [Appirater setDaysUntilPrompt:2];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:5];
    [Appirater setDebug:NO];

}

-(GenericFieldBasedTableEditViewController*)startingValsControllerForCurrentPlan
{
	StartingValsFormInfoCreator *startingValsFormInfoCreator = 
		[[[StartingValsFormInfoCreator alloc] init] autorelease];
	GenericFieldBasedTableEditViewController *theStartingValsController = [[[GenericFieldBasedTableEditViewController alloc]
		initWithFormInfoCreator:startingValsFormInfoCreator andDataModelController:self.currentPlanDmc] autorelease];
		
	return theStartingValsController;
}

-(GenericFieldBasedTableViewController*)resultsControllerForCurrentPlan
{
	ResultsListFormInfoCreator *resultsListFormInfoCreator = 
		[[[ResultsListFormInfoCreator alloc] init] autorelease];
     
	ResultsListTableViewController *theResultsController = [[[ResultsListTableViewController alloc]
		initWithFormInfoCreator:resultsListFormInfoCreator andDataModelController:self.currentPlanDmc] autorelease];
	
	return theResultsController;
}

-(GenericFieldBasedTableViewController*)whatIfControllerForCurrentPlan
{
	WhatIfFormInfoCreator *whatIfFormInfoCreator = 
		[[[WhatIfFormInfoCreator alloc] init] autorelease];
	GenericFieldBasedTableViewController *theWhatIfController = [[[GenericFieldBasedTableViewController alloc]
		initWithFormInfoCreator:whatIfFormInfoCreator andDataModelController:self.currentPlanDmc] autorelease];
	return theWhatIfController;
}

-(GenericFieldBasedTableViewController*)moreControllerForCurrentPlan
{
	MoreFormInfoCreator *moreFormInfoCreator = 
		[[[MoreFormInfoCreator alloc] init] autorelease];
	GenericFieldBasedTableViewController *theMoreViewController = [[[GenericFieldBasedTableViewController alloc]
		initWithFormInfoCreator:moreFormInfoCreator andDataModelController:self.currentPlanDmc] autorelease];
	return theMoreViewController;
}

-(InputListTableViewController*)inputControllerForCurrentPlan
{
	InputListTableViewController *inputController = [[[InputListTableViewController alloc]
		initWithDataModelController:self.currentPlanDmc] autorelease];
		
	return inputController;
}

-(void)populateTabBarController
{

	assert(self.currentPlanDmc != nil);

	// navBarController is the color used in the navigation bar for all the tabbed views.
	UIColor *navBarControllerColor = [ColorHelper navBarTintColor];

	self.inputViewController = [self inputControllerForCurrentPlan];
	UINavigationController *inputNavController = [[[UINavigationController alloc]
		initWithRootViewController:self.inputViewController] autorelease];
	inputNavController.title = [AppHelper generatingLaunchScreen]?
			@"":LOCALIZED_STR(@"INPUT_NAV_CONTROLLER_BUTTON_TITLE");
	inputNavController.tabBarItem.image = [UIImage imageNamed:@"piggy.png"];
	inputNavController.navigationBar.tintColor = navBarControllerColor;

	self.startingValsController = [self startingValsControllerForCurrentPlan];
	UINavigationController *startingValsNavController =
		[[[UINavigationController alloc] initWithRootViewController:
			self.startingValsController] autorelease];
	startingValsNavController.title = [AppHelper generatingLaunchScreen]?
			@"":LOCALIZED_STR(@"STARTING_VALS_NAV_CONTROLLER_BUTTON_TITLE");
	startingValsNavController.tabBarItem.image = [UIImage imageNamed:@"clock.png"];
	startingValsNavController.navigationBar.tintColor = navBarControllerColor;

	self.resultsController = [self resultsControllerForCurrentPlan];
	UINavigationController *resultsNavController = [[[UINavigationController alloc]
		initWithRootViewController:self.resultsController] autorelease];
	resultsNavController.title = [AppHelper generatingLaunchScreen]?
			@"":LOCALIZED_STR(@"RESULTS_NAV_CONTROLLER_BUTTON_TITLE");
	resultsNavController.tabBarItem.image = [UIImage imageNamed:@"graph.png"];
	resultsNavController.navigationBar.tintColor = navBarControllerColor;
	
	self.whatIfController = [self whatIfControllerForCurrentPlan];
	UINavigationController *whatIfNavController = [[[UINavigationController alloc]
		initWithRootViewController:self.whatIfController] autorelease];
	whatIfNavController.title = [AppHelper generatingLaunchScreen]?
			@"":LOCALIZED_STR(@"WHAT_IF_NAV_CONTROLLER_BUTTON_TITLE");
	whatIfNavController.tabBarItem.image = [UIImage imageNamed:@"scales.png"];
	whatIfNavController.navigationBar.tintColor = navBarControllerColor;
	
	self.moreController = [self moreControllerForCurrentPlan];
	UINavigationController *moreNavController = [[[UINavigationController alloc]
		initWithRootViewController:self.moreController] autorelease];
	moreNavController.title = [AppHelper generatingLaunchScreen]?
			@"":LOCALIZED_STR(@"MORE_VIEW_TITLE");
	moreNavController.tabBarItem = [[[UITabBarItem alloc] 
		initWithTabBarSystemItem:UITabBarSystemItemMore tag:0] autorelease];
	moreNavController.navigationBar.tintColor = navBarControllerColor;	
	
	self.tabBarController.viewControllers =
		[NSArray arrayWithObjects:
			inputNavController,
			startingValsNavController,
			resultsNavController,
			whatIfNavController,
			moreNavController, 
			nil]; 
}

-(void)initCurrentPlan
{
	NSString *currentPlanName = [AppHelper currentPlanName];
	
	if([StringValidation nonEmptyString:currentPlanName])
	{
		self.currentPlanDmc = [AppHelper openPlanForPlanName:currentPlanName];
	}
	else
	{
		NSString *defaultPlanName = LOCALIZED_STR(@"DEFAULT_MASTER_PLAN_NAME");
		
		[AppHelper setCurrentPlanName:defaultPlanName];
		
		self.currentPlanDmc = [AppHelper openPlanForPlanName:defaultPlanName];
	}
	[SimResultsController initSingletonFromMainDataModelController:self.currentPlanDmc];

}


-(void)saveCurrentPlan
{
    if(self.currentPlanDmc != nil)
    {
        [self.currentPlanDmc saveContext];
    }
}


-(void)changeCurrentPlan:(NSString*)newPlanName
{
	assert([StringValidation nonEmptyString:newPlanName]);
    
    // Make sure the current plan/budget information is saved, before
    // switching to the new plan/budget.
    [self saveCurrentPlan];
	
	[AppHelper setCurrentPlanName:newPlanName];
	
	self.currentPlanDmc = [AppHelper openPlanForPlanName:newPlanName];
	
	[SimResultsController updateSingletonWithMainDataModelController:self.currentPlanDmc];

	
	// Update the dataModelController ("file handle" for the current plan) for
	// all the top level views. If any of the views are showing a sub-view, they also need to be popped
	// to the root level view.
	self.inputViewController.dataModelController = self.currentPlanDmc;
	[self.inputViewController.navigationController popToViewController:self.inputViewController animated:FALSE];
	
	self.startingValsController.dataModelController = self.currentPlanDmc;
	[self.startingValsController.navigationController popToViewController:self.startingValsController animated:FALSE];
	
	self.resultsController.dataModelController = self.currentPlanDmc;
	[self.resultsController.navigationController popToViewController:self.resultsController animated:FALSE];
	
	self.whatIfController.dataModelController = self.currentPlanDmc;
	[self.whatIfController.navigationController popToViewController:self.whatIfController animated:FALSE];
	
	// Don't pop the more view controller, since the plan/budget list is a sub ViewController,
	// and we don't want to interrupt the editing of the plan list.
	self.moreController.dataModelController = self.currentPlanDmc;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Delete the persistent cache of information for results controllers: Otherwise,
    // the app was throwing exceptions with a message "The persistent cache of 
    // section information does not match the current configuration."
    [NSFetchedResultsController deleteCacheWithName:nil];
	
	[self initCurrentPlan];
	
	[self populateTabBarController];

	self.passcodeValidator = [[[PasscodeValidator alloc] initWithDelegate:self] autorelease];
	[self configureReviewAppPrompt];
		
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [self saveCurrentPlan];

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	 
	 [self configStartingViewController];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}



#pragma mark PasscodeValidationDelegate

-(void)passcodeValidated
{
	[self configWithMainTabBarController];
}


@end
