//
//  DateHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DateHelper : NSObject {
    @private
        NSDateFormatter *mediumDateFormatter;
}

+(DateHelper*)theHelper; // singleton

@property(nonatomic,retain)  NSDateFormatter *mediumDateFormatter;

+ (NSDate*)today;

@end
