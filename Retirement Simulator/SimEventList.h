//
//  SimEventList.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SimEvent;

@interface SimEventList : NSObject {
    @private
		NSMutableArray *eventList;

}

-(void)addEvent:(SimEvent*)newEvent;
-(SimEvent*)nextEvent;
-(void)removeAllEvents;

@property(nonatomic,retain) NSMutableArray *eventList;

@end
