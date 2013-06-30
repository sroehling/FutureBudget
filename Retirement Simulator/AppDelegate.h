//
//  Retirement_SimulatorAppDelegate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTPasscodeViewController.h"

#import "PasscodeValidator.h"

@class DataModelController;
@class InputListTableViewController;
@class GenericFieldBasedTableEditViewController;
@class GenericFieldBasedTableViewController;

@interface AppDelegate : NSObject 
	<UIApplicationDelegate,UITabBarControllerDelegate,PasscodeValidationDelegate> {
		
	@private
		PasscodeValidator *passcodeValidator;
		
		DataModelController *currentPlanDmc;
		
		InputListTableViewController *inputViewController;
		GenericFieldBasedTableEditViewController *startingValsController;
		GenericFieldBasedTableViewController *resultsController;
		GenericFieldBasedTableViewController *whatIfController;
		GenericFieldBasedTableViewController *moreController;
		

		
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property(nonatomic,retain) PasscodeValidator *passcodeValidator;
@property(nonatomic,retain) DataModelController *currentPlanDmc;

@property(nonatomic,retain) InputListTableViewController *inputViewController;
@property(nonatomic,retain) GenericFieldBasedTableEditViewController *startingValsController;
@property(nonatomic,retain) GenericFieldBasedTableViewController *resultsController;
@property(nonatomic,retain) GenericFieldBasedTableViewController *whatIfController;
@property(nonatomic,retain) GenericFieldBasedTableViewController *moreController;

-(void)changeCurrentPlan:(NSString*)newPlanName;



@end
