//
//  GrowthRateChange.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GrowthRateChange : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * startingDate;
@property (nonatomic, retain) NSNumber * newRate;

@end
