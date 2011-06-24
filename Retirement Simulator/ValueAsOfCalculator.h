//
//  ValueAsOfCalculator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ValueAsOfCalculator <NSObject>

- (double)valueAsOfDate:(NSDate*)theDate;

@end
