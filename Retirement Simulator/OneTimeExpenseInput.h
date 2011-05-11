//
//  OneTimeExpenseInput.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Input.h"

@class EventRepeatFrequency;

@interface OneTimeExpenseInput : Input {
@private
}
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSDate * transactionDate;
@property (nonatomic, retain) EventRepeatFrequency * repeatFrequency;


@end
