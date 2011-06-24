//
//  InputEventCreatorCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InputVisitor.h"
#import "SimEventCreator.h"
@class SimEngine;

@interface InputEventCreatorCreator : NSObject <InputVisitor> {
    @private
        id<SimEventCreator>  currSimEventCreator;
}

@property(nonatomic,retain) id<SimEventCreator>  currSimEventCreator;

-(void)populateSimEngine:(SimEngine*)simEngine;


@end
