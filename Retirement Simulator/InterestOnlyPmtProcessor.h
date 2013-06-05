//
//  InterestOnlyPaymentAmtCalculator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/21/13.
//
//

#import <Foundation/Foundation.h>

#import "LoanPmtProcessor.h"

@interface InterestOnlyPmtProcessor : NSObject <LoanPmtProcessor>
{
	@private
		BOOL subsizePayment;
}

-(id)initWithSubsidizedInterestPayment:(BOOL)doSubsidizePayment;

@end
