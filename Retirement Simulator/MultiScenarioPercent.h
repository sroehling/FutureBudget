//
//  MultiScenarioPercent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/14/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const MULTI_SCEN_PERCENT_ENTITY_NAME;


@class MultiScenarioInputValue;
@class Account;

@interface MultiScenarioPercent : NSManagedObject

@property (nonatomic, retain) MultiScenarioInputValue *percent;
@property (nonatomic, retain) MultiScenarioInputValue *defaultFixedPercent;

@property (nonatomic, retain) Account *accountDividendReinvestPercent;

@end
