//
//  AccountDividendDigestEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/6/13.
//
//

#import <Foundation/Foundation.h>
#import "DigestEntry.h"

@interface AccountDividendDigestEntry : NSObject <DigestEntry>
{
	@private
		double dividendAmount;
}

@property double dividendAmount;

-(id)initWithDividendAmount:(double)theDividendAmount;

@end
