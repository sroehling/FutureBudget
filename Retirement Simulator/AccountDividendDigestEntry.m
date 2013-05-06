//
//  AccountDividendDigestEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/6/13.
//
//

#import "AccountDividendDigestEntry.h"

@implementation AccountDividendDigestEntry

@synthesize dividendAmount;

-(id)initWithDividendAmount:(double)theDividendAmount
{
	self = [super init];
	if(self)
	{
		self.dividendAmount = theDividendAmount;
	}
	return self;
}

-(id)init
{
	assert(0); // must call initWithDividend
}

-(void)processDigestEntry:(DigestEntryProcessingParams*)processingParams
{
	if(self.dividendAmount>0.0)
	{
		// TODO - Process the dividend amount with the appropriate working balances, etc.
		
	}

}



@end
