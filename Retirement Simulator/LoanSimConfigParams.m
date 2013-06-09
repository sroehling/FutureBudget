//
//  PastLoanConfigParams.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/7/13.
//
//

#import "LoanSimConfigParams.h"

@implementation LoanSimConfigParams

@synthesize monthlyPmt;
@synthesize interestStartDate;
@synthesize startingBal;

-(void)dealloc
{
	[interestStartDate release];
	[super dealloc];
}

@end
