//
//  MilestoneDate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "VariableDate.h"


@interface MilestoneDate : VariableDate {
@private
}
@property (nonatomic, retain) NSString * name;

@end
