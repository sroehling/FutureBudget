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


@implementation InputListInputDescriptionCreator 

@synthesize generatedDesc;

- (void) visitCashFlow:(CashFlowInput *)cashFlow
{
	VariableValueRuntimeInfo *amountRuntimeInfo = [[[VariableValueRuntimeInfo alloc] initWithEntityName:@"CashFlowAmount" andFormatter:[NumberHelper theHelper].currencyFormatter 
			andValueTitle:@"Amount" andValueVerb:@"" andPeriodDesc:@""] autorelease];
	NSString *amountDisplay = [cashFlow.amount inlineDescription:amountRuntimeInfo];

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
	
	VariableValueRuntimeInfo *inflationRuntimeInfo = [[[VariableValueRuntimeInfo alloc] initWithEntityName:@"InflationRate" andFormatter:[NumberHelper theHelper].percentFormatter andValueTitle:@"Inflation Rate"
		andValueVerb:@"inflate amount" andPeriodDesc:@"every year"] autorelease];
	NSString *inflationDesc = [cashFlow.amountGrowthRate inlineDescription:inflationRuntimeInfo];
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
