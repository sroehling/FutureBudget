//
//  VariableValueRuntimeInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableValueRuntimeInfo.h"
#import "SharedEntityVariableValueListMgr.h"
#import "NumberHelper.h"


@implementation VariableValueRuntimeInfo

@synthesize valueFormatter;
@synthesize valueTitle;
@synthesize valueVerb;
@synthesize periodDesc;
@synthesize listMgr;

- (id) initWithFormatter:(NSNumberFormatter*)valFormatter
		   andValueTitle:(NSString*)title andValueVerb:(NSString*)verb
		   andPeriodDesc:(NSString*)thePeriodDesc andListMgr:(id<VariableValueListMgr>)theListMgr
{
	self = [super init];
	if(self)
	{
		assert(valFormatter != nil);
		assert(title != nil);
		assert([title length] > 0);
		self.valueFormatter = valFormatter;
		self.valueTitle = title;
		self.valueVerb = verb;
		self.periodDesc = thePeriodDesc;
		self.listMgr = theListMgr;
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
	[valueFormatter release];
	[valueTitle release];
	[valueVerb release];
	[periodDesc release];
	[listMgr release];
}

- (NSString *)inlinePeriodDesc;
{
	NSString *periodDescStr = @"";
	if([self.periodDesc length] > 0)
	{
		periodDescStr = [NSString stringWithFormat:@" %@",
					  self.periodDesc];		  
	}
	return periodDescStr;

}


+ (VariableValueRuntimeInfo*)createForCashflowAmount
{
	SharedEntityVariableValueListMgr *variableAmountMgr = 
	[[[SharedEntityVariableValueListMgr alloc] initWithEntity:@"CashFlowAmount"] autorelease];
	VariableValueRuntimeInfo *amountRuntimeInfo = [[[VariableValueRuntimeInfo alloc]
		initWithFormatter:[NumberHelper theHelper].currencyFormatter 
		andValueTitle:@"Amount" andValueVerb:@"" andPeriodDesc:@"" andListMgr:variableAmountMgr] autorelease];
	return amountRuntimeInfo;
}

+ (VariableValueRuntimeInfo*)createForInflationRate
{
	SharedEntityVariableValueListMgr *sharedInflationRatesMgr = 
	[[[SharedEntityVariableValueListMgr alloc] initWithEntity:@"InflationRate"] autorelease];
	
	VariableValueRuntimeInfo *inflationRuntimeInfo = [[[VariableValueRuntimeInfo alloc] 
		initWithFormatter:[NumberHelper theHelper].percentFormatter andValueTitle:@"Inflation Rate"
		andValueVerb:@"inflate amount" 
		andPeriodDesc:@"every year" andListMgr:sharedInflationRatesMgr] autorelease];
	return inflationRuntimeInfo;
}

@end
