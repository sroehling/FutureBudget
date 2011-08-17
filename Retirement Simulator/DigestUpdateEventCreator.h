//
//  DigestUpdateEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEventCreator.h"
#import "EventRepeater.h"


@interface DigestUpdateEventCreator : NSObject <SimEventCreator> {
    @private
		EventRepeater *updateEventRepeater;
		NSDate *digestStartDate;
}

@property(nonatomic,retain) EventRepeater *updateEventRepeater;
@property(nonatomic,retain) NSDate *digestStartDate;

@end
