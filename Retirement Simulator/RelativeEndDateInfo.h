//
//  RelativeEndDateInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RelativeEndDateInfo : NSObject {
    @private
		NSInteger years;
		NSInteger months;
		NSInteger weeks;
}

@property NSInteger years;
@property NSInteger months;
@property NSInteger weeks;

@end
