//
//  TestSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEvent.h"

@interface TestSimEvent : SimEvent {
	@private
		NSString *eventLabel;
}

@property(nonatomic,retain) NSString *eventLabel;


@end
