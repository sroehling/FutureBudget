//
//  DurationInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DurationInfo.h"
#import "LocalizationHelper.h"

#define MONTHS_PER_YEAR 12


@implementation DurationInfo

@synthesize totalMonths;
@synthesize yearsPart;
@synthesize monthsPart;

-(id)initWithTotalMonths:(NSNumber *)theTotalMonths
{
	self = [super init];
	if(self)
	{
		assert(theTotalMonths != nil);
		
		self.totalMonths = theTotalMonths;
		
		NSInteger totalMonthsDuration = [theTotalMonths intValue];
		assert(totalMonthsDuration >= 0);
		
		self.yearsPart = totalMonthsDuration / MONTHS_PER_YEAR;
		self.monthsPart = totalMonthsDuration - (self.yearsPart * MONTHS_PER_YEAR);
		
		
	}
	return self;
}

-(id)initWithYearPart:(NSInteger)years andMonthsPart:(NSInteger)months
{
	self = [super init];
	if(self)
	{
		assert(years>=0);
		self.yearsPart = years;
		
		assert(months>=0);
		self.monthsPart = months;
		
		NSInteger totalMonthsVal = (years*12) + months;
		self.totalMonths = [NSNumber numberWithInt:totalMonthsVal];
	}
	return self;
}


+ (NSString*)formatYearLabel:(NSInteger)theYearsPart
{
	assert(theYearsPart>=0);
	NSString *theLabel = ((theYearsPart==1)?
		LOCALIZED_STR(@"DURATION_FIELD_SINGLE_YEAR"):LOCALIZED_STR(@"DURATION_FIELD_MULTIPLE_YEARS"));
	return theLabel;
}


+(NSString*)formatMonthLabel:(NSInteger)theMonthsPart
{
	assert(theMonthsPart >= 0);
	NSString *theLabel = ((theMonthsPart == 1)?
		LOCALIZED_STR(@"DURATION_FIELD_SINGLE_MONTH"):LOCALIZED_STR(@"DURATION_FIELD_MULTPLE_MONTHS"));
	return theLabel;
}

- (NSString*)yearLabel
{
	return [DurationInfo formatYearLabel:self.yearsPart];
}


- (NSString*)monthLabel
{
	return [DurationInfo formatMonthLabel:self.monthsPart];
}

-(NSString*)yearsAndMonthsFormatted
{
	if(self.yearsPart > 0)
	{
		if(self.monthsPart > 0)
		{
			return [NSString stringWithFormat:@"%d %@, %d %@",
				self.yearsPart, [self yearLabel], self.monthsPart,[self monthLabel]];
		}
		else
		{
			return [NSString stringWithFormat:@"%d %@",self.yearsPart,[self yearLabel]];
		}
	}
	else
	{
		if(self.monthsPart > 0)
		{
			return [NSString stringWithFormat:@"%d %@",self.monthsPart,[self monthLabel]];
		}
		else
		{
			return @"";
		}
	}

}



-(void)dealloc
{
	[totalMonths release];
	[super dealloc];
}



@end
