//
//  PastLoanConfigParams.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/7/13.
//
//

#import <Foundation/Foundation.h>

@interface LoanSimConfigParams : NSObject
{
	@private
		NSDate *interestStartDate;
		double monthlyPmt;
		double startingBal;
		
}

@property (nonatomic,retain) NSDate *interestStartDate;
@property double monthlyPmt;
@property double startingBal;

@end
