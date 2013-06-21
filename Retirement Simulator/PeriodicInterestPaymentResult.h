//
//  PeriodicInterestPaymentResult.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/19/13.
//
//

#import <Foundation/Foundation.h>

@interface PeriodicInterestPaymentResult : NSObject {
	@private
		double interestPaid;
		double extraPaymentPaid;
}

@property double interestPaid;
@property double extraPaymentPaid;

@end
