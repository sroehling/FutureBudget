//
//  AppHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/14/12.
//
//

#import <Foundation/Foundation.h>

extern NSString * const FUTURE_BUDGET_APP_ID;
extern NSString * const PLAN_DATA_FILE_EXTENSION;

@class DataModelController;
@class AppDelegate;

@interface AppHelper : NSObject

+(DataModelController*)openPlanForPlanName:(NSString*)planName;

+(DataModelController*)subDataModelControllerForCurrentPlan;

+(AppDelegate*)theAppDelegate;

+(BOOL)generatingLaunchScreen;

+(void)setCurrentPlanName:(NSString*)planName;
+(NSString*)currentPlanName;

@end
