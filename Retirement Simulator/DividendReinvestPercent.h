//
//  DividendReinvestPercent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/14/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "VariableValue.h"

extern NSString * const DIVIDEND_REINVEST_PERCENT_ENTITY_NAME;

@class SharedAppValues;

@interface DividendReinvestPercent : VariableValue

// inverse relationship
@property (nonatomic, retain) SharedAppValues *sharedAppValsDivReinvestPerc;

@end
