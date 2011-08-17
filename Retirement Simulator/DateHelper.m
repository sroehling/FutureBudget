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
    [super dealloc];
    [mediumDateFormatter release];
	[longDateFormatter release];
	[gregorian release];
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
