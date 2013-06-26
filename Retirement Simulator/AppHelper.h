//
//  AppHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/14/12.
//
//

#import <Foundation/Foundation.h>

extern NSString * const FINSIM_APP_ID;

@class DataModelController;
@class AppDelegate;

@interface AppHelper : NSObject

+(DataModelController*)appDataModelControllerForPlanName:(NSString*)planName;
+(DataModelController*)subDataModelControllerForCurrentPlan;

+(AppDelegate*)theAppDelegate;

+(BOOL)generatingLaunchScreen;

@end
