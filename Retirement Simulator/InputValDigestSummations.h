//
//  InputValDigestSummations.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InputValDigestSummation;

@interface InputValDigestSummations : NSObject {
    @private
		NSMutableArray *inputValDigestSums;
}

@property(nonatomic,retain) NSMutableArray *inputValDigestSums;

-(void)addDigestSum:(InputValDigestSummation*)digestSum;
-(void)resetSums;

@end
