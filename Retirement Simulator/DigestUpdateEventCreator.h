//
//  DigestUpdateEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YearlySimEventCreator.h"


@interface DigestUpdateEventCreator : YearlySimEventCreator {
}

- (id) initWithSimStartDate:(NSDate*)simStart;

@end
