//
//  LocalizationHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocalizationHelper : NSObject {
    
}

+ (NSString*)localizeStringWithAssertionChecks:(NSString*)key;

@end

#define LOCALIZED_STR(key) ([LocalizationHelper localizeStringWithAssertionChecks:key])
