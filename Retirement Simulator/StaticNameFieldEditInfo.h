//
//  StaticNameFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"

@interface StaticNameFieldEditInfo : NSObject <FieldEditInfo> {
    @private
		NSString *staticName;
}

@property(nonatomic,retain) NSString *staticName;

-(id)initWithName:(NSString*)theName;

@end
