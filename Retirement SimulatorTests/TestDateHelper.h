//
//  TestDateHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TestDateHelper : NSObject {
    
}
+ (NSDate*)dateFromStr:(NSString*)dateStr;
+ (NSString*)stringFromDate:(NSDate*)theDate;

@end
