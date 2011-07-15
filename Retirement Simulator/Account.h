//
//  Account.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Input.h"

extern NSString * const ACCOUNT_STARTING_BALANCE_KEY;


@interface Account : Input {
@private
}
@property (nonatomic, retain) NSNumber * startingBalance;

@end
