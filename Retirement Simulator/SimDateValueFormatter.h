//
//  SimDateValueFormatter.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimDateVisitor.h"

@class SimDate;

@interface SimDateValueFormatter : NSObject <SimDateVisitor> {
    @private
		NSString *formattedVal;
}

@property(nonatomic,retain) NSString *formattedVal;

- (NSString*)formatSimDate:(SimDate*)theSimDate;

@end
