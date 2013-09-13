//
//  EventRepeater.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventRepeater.h"
#import "EventRepeatFrequency.h"
#import "DateHelper.h"


@implementation EventRepeater

@synthesize startDate;
@synthesize endDate;
@synthesize currentDate;
@synthesize dateHelper;

-(void)dealloc {
    [dateFormatter release];
    [repeatOffsetComponents release];
    [startDate release];
	[currentDate release];
	[endDate release];
    [dateHelper release];
    
    [super dealloc];
}


- (id) initWithRepeatOffset:(NSDateComponents*)theRepeatOffset andRepeatOnce:(bool)doRepeatOnce
	 andStartDate:(NSDate*)theStartDate andEndDate:(NSDate*)theEndDate
{
	self = [super init];
	if(self)
	{
       dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        repeatOffsetComponents = theRepeatOffset;
		[repeatOffsetComponents retain];
		
		self.startDate = theStartDate;
        self.endDate = theEndDate;
		repeatOnce = doRepeatOnce;
        
        self.dateHelper = [[[DateHelper alloc] init] autorelease];

        [self reset];

	}
	return self;
 
}

- (id) initWithEventRepeatFrequency:(EventRepeatFrequency*)repeatFrequency 
         andStartDate:(NSDate*)theStartDate andEndDate:(NSDate*)theEndDate;
{
    assert(repeatFrequency!=nil);
    assert(theStartDate!=nil);
	assert(theEndDate != nil);
	
	bool doRepeatOnce = false;

	NSDateComponents *offsetComponents = [[[NSDateComponents alloc] init] autorelease];
        
	EventPeriod periodEnum = 
		(EventPeriod)[[repeatFrequency period] intValue];
	int periodMultiply = [[repeatFrequency periodMultiplier] intValue];
	assert(periodMultiply >=0);
	doRepeatOnce = false;
                
	switch (periodEnum) {
		case kEventPeriodOnce:
			assert(periodMultiply == 1);
			doRepeatOnce = true;
			break;
		case kEventPeriodDay:
			assert(periodMultiply > 0);
			[offsetComponents setDay:periodMultiply];
			break;
		case kEventPeriodWeek:
			assert(periodMultiply > 0);
			[offsetComponents setWeek:periodMultiply];
			break;
		case kEventPeriodMonth:
			assert(periodMultiply > 0);
			[offsetComponents setMonth:periodMultiply];
			break;
		case kEventPeriodQuarter:
			assert(periodMultiply > 0);
			[offsetComponents setQuarter:periodMultiply];
			break;
		case kEventPeriodYear:
			assert(periodMultiply > 0);
			[offsetComponents setYear:periodMultiply];
			break;
                
		default:
			assert(false); // shouldn't get here - invalid/unsupported enum found
			break;
	}
	return [self initWithRepeatOffset:offsetComponents andRepeatOnce:doRepeatOnce 
		andStartDate:theStartDate andEndDate:theEndDate];

    
}

- (void)reset
{
    repeatCount = 0;
    self.currentDate = [[startDate copy] autorelease];
}

- (NSDate*)nextDate
{
    if(repeatOnce)
    {
        if(repeatCount > 0)
        {
            return nil;
        }
        else
        {
            repeatCount++;
            return startDate;
        }
    }
    else
    {
        if(repeatCount == 0)
        {
            // No need to increment first, dates are the same
            repeatCount++;
           return currentDate;
        }
        else{
 			self.currentDate = [self.dateHelper.gregorian dateByAddingComponents:repeatOffsetComponents 
                 toDate:self.currentDate options:0];
				 
			NSComparisonResult eventComparedToResultsCheckpoint = 
				[self.currentDate compare:self.endDate];
    
			// Comparison is to determine if the current date is "not later"
			// than the end date.
			if (eventComparedToResultsCheckpoint != NSOrderedDescending) 
			{
				repeatCount++;
				return currentDate;
			}
			else
			{
				// The next date is beyond the end date for this event repeater,
				// so return nil to end the event repeating.
				return nil;
			}
        }        
    }
}

- (NSDate*)nextDateOnOrAfterDate:(NSDate*)minimumDate
{
	assert(minimumDate != nil);
	NSDate *nextDateOnOrAfter = [self nextDate];
	while((nextDateOnOrAfter != nil) && 
		[self.dateHelper dateIsLater:minimumDate otherDate:nextDateOnOrAfter])
	{
		nextDateOnOrAfter = [self nextDate];
	}
	return nextDateOnOrAfter;
}

+(EventRepeater*)monthlyEventRepeaterWithStartDate:(NSDate*)startDate
	andEndDate:(NSDate*)endDate
{

	NSDateComponents *monthlyOffset = [[[NSDateComponents alloc] init] autorelease];
	[monthlyOffset setMonth:1];
	
    EventRepeater *monthlyRepeater = [[[EventRepeater alloc]
                     initWithRepeatOffset:monthlyOffset andRepeatOnce:FALSE 
					andStartDate:startDate andEndDate:endDate] autorelease];
	return monthlyRepeater;

}





@end
