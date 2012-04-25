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

@interface Retirement_SimulatorAppDelegate : NSObject 
	<UIApplicationDelegate,UITabBarControllerDelegate,PasscodeValidationDelegate> {
		
	@private
		PasscodeValidator *passcodeValidator;
		
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property(nonatomic,retain) PasscodeValidator *passcodeValidator;


@end
