//
//  CashFlowSummation.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DigestEntry;

@interface DigestEntryCltn : NSObject {
    @private
		NSMutableArray *digestEntries;
}

- (void)addDigestEntry:(id<DigestEntry>)digestEntry;

- (void)resetEntries;

@property(nonatomic,retain) NSMutableArray *digestEntries;

@end
