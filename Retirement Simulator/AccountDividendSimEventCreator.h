//
//  AccountDividendSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/13.
//
//

#import <Foundation/Foundation.h>
#import "SimEventCreator.h"
#import "PeriodicSimEventCreator.h"

@class AccountSimInfo;
@class EventRepeater;

@interface AccountDividendSimEventCreator : PeriodicSimEventCreator
{
	@private
		AccountSimInfo *acctSimInfo;

}

- (id)initWithAcctSimInfo:(AccountSimInfo*)theAcctSimInfo andSimStartDate:(NSDate*)simStart;
	
@property(nonatomic,retain) AccountSimInfo *acctSimInfo;

@end
