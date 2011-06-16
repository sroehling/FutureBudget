//
//  InputListInputDescriptionCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputListInputDescriptionCreator.h"
#import "Input.h"

#import "NumberHelper.h"
#import "DateHelper.h"
#import "ExpenseInput.h"
#import "VariableDate.h"
#import "EventRepeatFrequency.h"
#import "VariableValueRuntimeInfo.h"
#import "DateSensitiveValue.h"
#import "SharedEntityVariableValueListMgr.h"


@implementation InputListInputDescriptionCreator 

@synthesize generatedDesc;

- (void) visitCashFlow:(CashFlowInput *)cashFlow
{
	NSString *amountDisplay = [cashFlow.amount inlineDescription:
							   [VariableValueRuntimeInfo createForCashflowAmount]];

	NSString *startDateDisplay = [cashFlow.startDate 
								  inlineDescription:[DateHelper theHelper].mediumDateFormatter];
	NSString *repeatDesc = [cashFlow.repeatFrequency inlineDescription];
	NSString *untilDesc = @"";
	if([cashFlow.repeatFrequency eventRepeatsMoreThanOnce])
	{
	    NSString *endDateDisplay = [cashFlow.endDate 
									inlineDescription:[DateHelper theHelper].mediumDateFormatter];;
		untilDesc = [NSString stringWithFormat:@" until %@",endDateDisplay];
	}
	
	NSString *inflationDesc = [cashFlow.amountGrowthRate inlineDescription:[VariableValueRuntimeInfo createForInflationRate]];
	self.generatedDesc = [NSString stringWithFormat:@"%@ starting on %@, repeating %@%@, %@",
						  amountDisplay,startDateDisplay,repeatDesc,untilDesc,inflationDesc];

}

- (void)visitExpense:(ExpenseInput*)expense
{ 
}

- (void)visitIncome:(IncomeInput*)input
{
}


- (NSString*)descripionForInput:(Input*)theInput
{
	self.generatedDesc = nil;
	assert(theInput != nil);
	[theInput acceptInputVisitor:self];
	assert(self.generatedDesc != nil);
	assert([self.generatedDesc length] > 0);
	return self.generatedDesc;
}

- (void)dealloc
{
	[super dealloc];
	[generatedDesc release];
}

@end
