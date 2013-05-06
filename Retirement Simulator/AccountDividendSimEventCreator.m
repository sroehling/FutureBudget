//
//  AccountDividendSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/13.
//
//

#import "AccountDividendSimEventCreator.h"
#import "AccountDividendSimEvent.h"

@implementation AccountDividendSimEventCreator

@synthesize acctSimInfo;

-(void)dealloc
{
	[acctSimInfo release];
	[super dealloc];
}

- (id)initWithAcctSimInfo:(AccountSimInfo*)theAcctSimInfo andSimStartDate:(NSDate*)simStart
{
	self = [super initWithStartingMonth:1 andStartingDay:15
		andSimStartDate:simStart andPeriod:kEventPeriodQuarter];
		
	if(self)
	{
		self.acctSimInfo = theAcctSimInfo;
	}
	return self;

}

- (SimEvent*)createSimEventOnDate:(NSDate*)eventDate
{

	AccountDividendSimEvent *dividendEvent =
		[[[AccountDividendSimEvent alloc] initWithEventCreator:self
			andEventDate:eventDate] autorelease];
	dividendEvent.tieBreakPriority = SIM_EVENT_TIE_BREAK_PRIORITY_MEDIUM_LOW;
	dividendEvent.acctSimInfo = self.acctSimInfo;
	
	
	return dividendEvent;

}



@end
