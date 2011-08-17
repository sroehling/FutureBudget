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


extern NSString * const CASH_STARTING_BALANCE_KEY;
extern NSString * const CASH_ENTITY_NAME;

@interface Cash : Input {
@private
}
@property (nonatomic, retain) NSNumber * startingBalance;

@end
