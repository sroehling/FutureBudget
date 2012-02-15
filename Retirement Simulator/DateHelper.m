//
//  DateHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

@synthesize mediumDateFormatter;
@synthesize gregorian;
@synthesize longDateFormatter;

+(DateHelper*)theHelper
{  
    static DateHelper *theDateHelper;  
    @synchronized(self)  
    {    if(!theDateHelper)      
        theDateHelper =[[DateHelper alloc] init];
        return theDateHelper;
    }
}

-(id)init
{
    self = [super init];
    if(self)
    {
        self.mediumDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [self.mediumDateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[self.mediumDateFormatter setTimeStyle:NSDateFormatterNoStyle];


        self.longDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [self.longDateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[self.longDateFormatter setTimeStyle:NSDateFormatterShortStyle];
		
		self.gregorian = [[NSCalendar alloc]
                         initWithCalendarIdentifier:NSGregorianCalendar];
		
    }
    return self;
}

+ (NSDate*)today
{
    return [[[NSDate alloc] init]autorelease];
}

+ (bool)dateIsEqualOrLater:(NSDate*)theDate otherDate:(NSDate*)comparisonDate
{
	assert(theDate != nil);
	assert(comparisonDate != nil);
	NSComparisonResult comparison = [theDate compare:comparisonDate];
	if((comparison == NSOrderedDescending) ||
		(comparison == NSOrderedSame))
	{
		return true;
	}
	return false;
}

+ (bool)dateIsLater:(NSDate*)theDate otherDate:(NSDate*)comparisonDate
{
	assert(theDate != nil);
	assert(comparisonDate != nil);
	NSComparisonResult comparison = [theDate compare:comparisonDate];
	if(comparison == NSOrderedDescending)
	{
		return true;
	}
	return false;
}

+ (bool)dateIsEqual:(NSDate*)theDate otherDate:(NSDate*)comparisonDate
{
	assert(theDate != nil);
	assert(comparisonDate!=nil);
	NSDate *beginningDate = [DateHelper beginningOfDay:theDate];
	NSDate *beginningOtherDate = [DateHelper beginningOfDay:comparisonDate];
	NSComparisonResult comparison = [beginningDate compare:beginningOtherDate];
	if(comparison == NSOrderedSame)
	{
		return true;
	}
	else
	{
		return false;
	}
}

+ (NSDate*)nextDay:(NSDate*)currentDay
{
	assert(currentDay != nil);
	NSDateComponents *nextDayOffset = [[[NSDateComponents alloc] init] autorelease];
	[nextDayOffset setDay:1];
	NSDate *nextDay = [[DateHelper theHelper].gregorian dateByAddingComponents:nextDayOffset 
                 toDate:currentDay options:0];
	assert(nextDay != nil);
	return nextDay;
}

+ (NSDate*)beginningOfNextYear:(NSDate*)dateWithinPreviousYear
{
	assert(dateWithinPreviousYear!=nil);
	NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *components = [[DateHelper theHelper].gregorian 
		components:componentFlags fromDate:dateWithinPreviousYear];
		
	NSInteger year = [components year];
	year++;
	[components setYear:year];
	[components setMonth:1];
	[components setDay:1];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	
	NSDate *theDate = [[DateHelper theHelper].gregorian dateFromComponents:components];
	assert(theDate!=nil);
	return theDate;
}

+ (NSDate*)beginningOfYear:(NSDate*)dateWithinYear
{	
	assert(dateWithinYear!=nil);
	NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *components = [[DateHelper theHelper].gregorian 
		components:componentFlags fromDate:dateWithinYear];
		
	[components setMonth:1];
	[components setDay:1];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	
	
	
	NSDate *theDate = [[DateHelper theHelper].gregorian dateFromComponents:components];
	assert(theDate!=nil);
	return theDate;
}


+ (NSDate*)beginningOfDay:(NSDate*)theDate
{	
	assert(theDate!=nil);
	NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *components = [[DateHelper theHelper].gregorian 
		components:componentFlags fromDate:theDate];
	
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	
	
	
	NSDate *roundedDate = [[DateHelper theHelper].gregorian dateFromComponents:components];
	assert(roundedDate!=nil);
	return roundedDate;
}


+(NSInteger)daysOffset:(NSDate*)theDate vsEarlierDate:(NSDate*)otherDate
{

		assert(theDate != nil);
		assert(otherDate != nil);

		NSDate *beginningOfOtherDate = [DateHelper beginningOfDay:otherDate];
		assert([DateHelper dateIsEqualOrLater:theDate otherDate:beginningOfOtherDate]);
		
		NSTimeInterval secondsSinceStart = [theDate timeIntervalSinceDate:beginningOfOtherDate];
		// TBD - is the right to not include values which come before the start date? Or
		// Should the startingvalue come before all other values, meaning a variable
		// value could be in effect at the start date.
		assert(secondsSinceStart >= 0.0);
		NSInteger daysSinceStart = floor(secondsSinceStart/SECONDS_PER_DAY);
		assert(daysSinceStart >= 0);
		return daysSinceStart;
}

+ (NSDate*)endOfDay:(NSDate*)theDate
{	
	assert(theDate!=nil);
	NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *components = [[DateHelper theHelper].gregorian 
		components:componentFlags fromDate:theDate];
	
	[components setHour:23];
	[components setMinute:11];
	[components setSecond:59];
	
	
	
	NSDate *roundedDate = [[DateHelper theHelper].gregorian dateFromComponents:components];
	assert(roundedDate!=nil);
	return roundedDate;
}


+ (NSDate*)sameYearDifferentDay:(NSDate*)dateWithinYear andMonth:(NSInteger)monthNum andDay:(NSInteger)dayNum
{
	assert(dateWithinYear!=nil);
	NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *components = [[DateHelper theHelper].gregorian 
		components:componentFlags fromDate:dateWithinYear];
//	NSInteger year = [components year];
	[components setMonth:monthNum];
	[components setDay:dayNum];
	[components setHour:23];
	[components setMinute:59];
	[components setSecond:59];
	
	NSDate *theDate = [[DateHelper theHelper].gregorian dateFromComponents:components];
	assert(theDate !=nil);
	return theDate;
	
}

+ (NSInteger)yearOfDate:(NSDate*)dateWithinYear
{
	assert(dateWithinYear!=nil);
	NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *components = [[DateHelper theHelper].gregorian 
		components:componentFlags fromDate:dateWithinYear];
	NSInteger year = [components year];
	assert(year > 0);
	return year;
}



+ (NSDate*)endOfYear:(NSDate*)dateWithinYear
{
	assert(dateWithinYear!=nil);
	NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *components = [[DateHelper theHelper].gregorian 
		components:componentFlags fromDate:dateWithinYear];
//	NSInteger year = [components year];
	[components setMonth:12];
	[components setDay:31];
	[components setHour:23];
	[components setMinute:59];
	[components setSecond:59];
	
	NSDate *theDate = [[DateHelper theHelper].gregorian dateFromComponents:components];
	assert(theDate !=nil);
	return theDate;
}


- (void) dealloc
{
    [mediumDateFormatter release];
	[longDateFormatter release];
	[gregorian release];
    [super dealloc];
}

+ (NSDate*)dateFromStr:(NSString*)dateStr
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *theDate = [dateFormatter dateFromString:dateStr];
	assert(theDate != nil);
	return theDate;
}

+ (NSString*)stringFromDate:(NSDate*)theDate
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *dateStr = [dateFormatter stringFromDate:theDate];
	return dateStr;	
}

@end
