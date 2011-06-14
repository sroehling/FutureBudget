//
//  Retirement_SimulatorAppDelegate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Retirement_SimulatorAppDelegate.h"
#import "DataModelController.h"

#import "InputListFormInfoCreator.h"
#import "ResultsViewController.h"
#import "GenericFieldBasedTableEditViewController.h"

@implementation Retirement_SimulatorAppDelegate


@synthesize window=_window;

@synthesize tabBarController=_tabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Delete the persistent cache of information for results controllers: Otherwise,
    // the app was throwing exceptions with a message "The persistent cache of 
    // section information does not match the current configuration."
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    [[DataModelController theDataModelController] initializeDatabaseDefaults];
    
	InputListFormInfoCreator *inputFormInfoCreator = 
		[[[InputListFormInfoCreator alloc] init] autorelease];
	UIViewController *inputController = [[[GenericFieldBasedTableEditViewController alloc]
		initWithFormInfoCreator:inputFormInfoCreator] autorelease];
	UINavigationController *inputNavController = [[[UINavigationController alloc] initWithRootViewController:inputController] autorelease];
	inputNavController.title = @"Inputs";
	
	
	ResultsViewController *resultsController = [[[ResultsViewController alloc] init] autorelease];
	UINavigationController *resultsNavController = [[[UINavigationController alloc] initWithRootViewController:resultsController] autorelease];
	resultsNavController.title = @"Results";
	
	
	self.tabBarController.viewControllers =
		[NSArray arrayWithObjects:inputNavController, resultsNavController, nil]; 
	
    // Add the tab bar controller's current view as a subview of the window
    self.window.rootViewController = self.tabBarController;
	
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    // Saves changes in the application's managed object context before the application 
    [[DataModelController theDataModelController] saveContext];

}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];

    [super dealloc];
}


- (void)awakeFromNib
{
  //  RootViewController *rootViewController = (RootViewController *)[self.navigationController //topViewController];
 //   rootViewController.managedObjectContext = self.managedObjectContext;
 }




/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/



@end
