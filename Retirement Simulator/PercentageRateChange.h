//
//  PercentageRateChange.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PercentageRateChange : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * newRate;
@property (nonatomic, retain) NSDate * startDate;

@end
