//
//  TestSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestSimEvent.h"

#include "SimEvent.h"

@implementation TestSimEvent



// Do the actual event
- (void)doSimEvent:(FiscalYearDigest*)digest
{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSLog(@"Doing event: %@",[dateFormatter stringFromDate:self.eventDate]);
    
    [dateFormatter release];
    
}


@end
