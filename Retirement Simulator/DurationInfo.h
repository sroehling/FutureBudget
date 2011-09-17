//
//  DurationInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DurationInfo : NSObject {
    @private
		NSNumber *totalMonths;
		NSInteger yearsPart;
		NSInteger monthsPart;
}

-(id)initWithTotalMonths:(NSNumber*)theTotalMonths;
-(id)initWithYearPart:(NSInteger)years andMonthsPart:(NSInteger)months;

@property(nonatomic,retain) NSNumber *totalMonths;
@property NSInteger yearsPart;
@property NSInteger monthsPart;

+ (NSString*)formatYearLabel:(NSInteger)theYearsPart;
+(NSString*)formatMonthLabel:(NSInteger)theMonthsPart;

-(NSString*)yearsAndMonthsFormatted;


@end
