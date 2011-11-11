//
//  Cash.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Input.h"

@class SharedAppValues;

extern NSString * const CASH_STARTING_BALANCE_KEY;
extern NSString * const CASH_ENTITY_NAME;

@interface Cash : Input {
@private
}
@property (nonatomic, retain) NSNumber * startingBalance;

// Inverse relationship to the default/shared values shared by the 
// entire application. This relationship is setup with a Deny delete
// rule, ensuring this Cash input is not deleted if it is referred
// to as the app's default Cash input.
@property (nonatomic, retain) SharedAppValues * sharedAppValsCash;


@end
