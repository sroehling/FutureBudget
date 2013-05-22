//
//  InterestOnlyPaymentAmtCalculator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/21/13.
//
//

#import <Foundation/Foundation.h>

#import "LoanPmtAmtCalculator.h"

@interface InterestOnlyPaymentAmtCalculator : NSObject <LoanPmtAmtCalculator>
{
	@private
		BOOL subsizePayment;
}

-(id)initWithSubsidizedInterestPayment:(BOOL)doSubsidizePayment;

@end
