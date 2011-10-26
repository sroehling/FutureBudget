//
//  DigestEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DigestEntryProcessingParams;

@protocol DigestEntry <NSObject>

-(void)processDigestEntry:(DigestEntryProcessingParams*)processingParams;

@end
