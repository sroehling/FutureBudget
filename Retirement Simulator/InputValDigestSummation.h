//
//  InputSummation.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InputValDigestSummation : NSObject {
    @private
		double currentSum;
}

@property double currentSum;

-(void)resetSum;

@end
