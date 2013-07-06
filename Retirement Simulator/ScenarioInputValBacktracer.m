//
//  ScenarioInputValBacktracer.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScenarioInputValBacktracer.h"
#import "ScenarioValue.h"
#import "MultiScenarioInputValue.h"
#import "UserScenario.h"

#import "Input.h"
#import "CashFlowInput.h"
#import "TaxInput.h"
#import "AssetInput.h"
#import "Account.h"
#import "LoanInput.h"
#import "MultiScenarioAmount.h"
#import "MultiScenarioGrowthRate.h"
#import "MultiScenarioPercent.h"
#import "MultiScenarioSimEndDate.h"
#import "MultiScenarioSimDate.h"

@implementation ScenarioInputValBacktracer

// Elsewhere, the properties are listed in order of the object the input is traced from. 
// Below the properties are listed in order of the destination input, which provides
// a listing which can be cross-checked with the property lists in the (derived) Input classes.

@synthesize cashFlowEnabled;
@synthesize cashFlowStartDate;
@synthesize cashFlowEndDate;
@synthesize cashFlowAmount;
@synthesize cashFlowAmountGrowthRate;
@synthesize cashFlowRepeatFrequency;

@synthesize taxEnabled;
@synthesize taxExemptionAmt;
@synthesize taxExemptionGrowthRate;
@synthesize taxStdDeductionGrowthRate;
@synthesize taxStdDeductionAmt;

@synthesize assetEnabled;
@synthesize assetCost;
@synthesize assetApprecRate;
@synthesize assetPurchaseDate;
@synthesize assetSaleDate;

@synthesize accountContribEnabled;
@synthesize accountDividendEnabled;
@synthesize accountContribStartDate;
@synthesize accountContribEndDate;
@synthesize accountContribRepeatFrequency;
@synthesize accountContribAmount;
@synthesize accountContribGrowthRate;
@synthesize accountDeferredWithdrawalsEnabled;
@synthesize accountDeferredWithdrawalDate;
@synthesize accountWithdrawalPriority;
@synthesize accountInterestRate;
@synthesize accountDividendRate;
@synthesize accountDividendReinvestPercent;

@synthesize loanDownPmtEnabled;
@synthesize loanDownPmtPercent;
@synthesize loanDuration;
@synthesize loanOrigDate;
@synthesize loanEnabled;
@synthesize loanExtraPmtEnabled;
@synthesize loanCost;
@synthesize loanExtraPmtAmt;
@synthesize loanCostGrowthRate;
@synthesize loanExtraPmtGrowthRate;
@synthesize loanInterestRate;
@synthesize loanEarlyPayoff;
@synthesize loanDeferPayment;


-(BOOL)populateInputSet:(NSMutableSet*)theSet withInput:(Input*)theInput
{
	assert(theSet != nil);
	if(theInput != nil)
	{
		[theSet addObject:theInput];
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

-(void)resolveOneScenarioValInput:(ScenarioValue*)scenVal
{
	assert(scenVal != nil);
	MultiScenarioInputValue *msInputVal = scenVal.multiScenInputValueScenarioVals;
	assert(msInputVal != nil);

	// MultiScenarioInputValue inverse relationships
	
	if([self populateInputSet:self.accountContribEnabled 
		      withInput:msInputVal.accountContribEnabled]) { return; }
			 
	if([self populateInputSet:self.accountDividendEnabled
			withInput:msInputVal.accountDividendEnabled]) { return; }
				
	if([self populateInputSet:self.accountContribRepeatFrequency 
		      withInput:msInputVal.accountContribRepeatFrequency]) { return; }
		
	if([self populateInputSet:self.accountDeferredWithdrawalsEnabled 
		      withInput:msInputVal.accountDeferredWithdrawalsEnabled]) { return; }
		
	if([self populateInputSet:self.accountWithdrawalPriority 
		      withInput:msInputVal.accountWithdrawalPriority]) { return; }

	if([self populateInputSet:self.loanDownPmtEnabled 
		      withInput:msInputVal.loanDownPmtEnabled]) { return; }
		
	if([self populateInputSet:self.loanDownPmtPercent 
		      withInput:msInputVal.loanDownPmtPercent]) { return; }
		
	if([self populateInputSet:self.loanDuration 
		      withInput:msInputVal.loanDuration]) { return; }
		
	if([self populateInputSet:self.loanEnabled 
		      withInput:msInputVal.loanEnabled]) { return; }
		
	if([self populateInputSet:self.loanExtraPmtEnabled 
		      withInput:msInputVal.loanExtraPmtEnabled]) { return; }
		

	if([self populateInputSet:self.cashFlowRepeatFrequency 
		      withInput:msInputVal.cashFlowEventRepeatFrequency]) { return; }
		
	
	if([self populateInputSet:self.cashFlowEnabled 
		      withInput:msInputVal.cashFlowEnabled]) { return; }
	
	if([self populateInputSet:self.taxEnabled 
		      withInput:msInputVal.taxEnabled]) { return; }

	if([self populateInputSet:self.assetEnabled 
		      withInput:msInputVal.assetEnabled]) { return; }

	// MultiScenarioAmount inverse relationships
	if(msInputVal.multiScenAmountAmount != nil)
	{
		MultiScenarioAmount *msAmount = msInputVal.multiScenAmountAmount;
		
		if([self populateInputSet:self.accountContribAmount 
			        withInput:msAmount.accountContribAmount]) { return; }
			
		if([self populateInputSet:self.assetCost 
			        withInput:msAmount.assetCost]) { return; }
			
		if([self populateInputSet:self.taxExemptionAmt 
			        withInput:msAmount.taxExemptionAmt]) { return; }
			
		if([self populateInputSet:self.taxStdDeductionAmt 
			        withInput:msAmount.taxStdDeductionAmt]) { return; }
			
		if([self populateInputSet:self.cashFlowAmount 
			        withInput:msAmount.cashFlowAmount]) { return; }
			
		if([self populateInputSet:self.loanCost 
			        withInput:msAmount.loanCost]) { return; }
			
		if([self populateInputSet:self.loanExtraPmtAmt 
			        withInput:msAmount.loanExtraPmtAmt]) { return; }		
	}

	// MultiScenarioGrowthRate inverse relationships
	if(msInputVal.multiScenGrowthRateGrowthRate != nil)
	{
		MultiScenarioGrowthRate *msGrowthRate = msInputVal.multiScenGrowthRateGrowthRate;
		
		if([self populateInputSet:self.accountContribGrowthRate 
			    withInput:msGrowthRate.accountContribGrowthRate]) { return; }
			
		if([self populateInputSet:self.accountInterestRate 
			    withInput:msGrowthRate.accountInterestRate]) { return; }
				
		if([self populateInputSet:self.accountDividendRate
				withInput:msGrowthRate.accountDividendRate]) { return; }
			
		if([self populateInputSet:self.assetApprecRate 
			    withInput:msGrowthRate.assetApprecRate]) { return; }
			
		if([self populateInputSet:self.taxExemptionGrowthRate 
			    withInput:msGrowthRate.taxExemptionGrowthRate]) { return; }
			
		if([self populateInputSet:self.taxStdDeductionGrowthRate 
			    withInput:msGrowthRate.taxStdDeductionGrowthRate]) { return; }
			
		if([self populateInputSet:self.cashFlowAmountGrowthRate 
				withInput:msGrowthRate.cashFlowAmountGrowthRate]) { return; }
			
        // Only show the loan cost (amount borrowed) growth rate if the
        // loan originates in the future. To show this value when it is not applicable
        // would cause unnecessary confusion.
       if(msGrowthRate.loanCostGrowthRate != nil)
        {
            LoanInput *theLoan = msGrowthRate.loanCostGrowthRate;
            if([theLoan originationDateDefinedAndInTheFutureForScenario:scenVal.scenario])
            {
                [self populateInputSet:self.loanCostGrowthRate
                             withInput:msGrowthRate.loanCostGrowthRate];
            }
            return;
        }
			
		if([self populateInputSet:self.loanExtraPmtGrowthRate 
			    withInput:msGrowthRate.loanExtraPmtGrowthRate]) { return; }
			
		if([self populateInputSet:self.loanInterestRate 
			    withInput:msGrowthRate.loanInterestRate]) { return; }
	}

	// MultiScenarioSimEndDate inverse relationships
	if(msInputVal.multiScenSimEndDateSimDate != nil)
	{
		MultiScenarioSimEndDate *msEndDate = msInputVal.multiScenSimEndDateSimDate;

		if([self populateInputSet:self.accountContribEndDate 
			       withInput:msEndDate.accountContribEndDate]) { return; }
			
		if([self populateInputSet:self.assetSaleDate 
			       withInput:msEndDate.assetSaleDate]) { return; }
			
		if([self populateInputSet:self.cashFlowEndDate 
			       withInput:msEndDate.cashFlowEndDate]) { return; }	

		if([self populateInputSet:self.loanEarlyPayoff 
				withInput:msEndDate.loanEarlyPayoffDate]) { return; }
				
		if([self populateInputSet:self.loanDeferPayment
				withInput:msEndDate.loanDeferredPaymentDate]) { return; }
	}
	
	// MultiScenarioPercent inverse relationships
	if(msInputVal.multiScenPercentPercent != nil)
	{
		MultiScenarioPercent *msPercent = msInputVal.multiScenPercentPercent;
		
		if([self populateInputSet:self.accountDividendReinvestPercent
			withInput:msPercent.accountDividendReinvestPercent]) { return; }
	}

	// MultiScenarioSimDate inverse relationships
	if(msInputVal.multiScenSimDateSimDate != nil)
	{
		MultiScenarioSimDate *msDate = msInputVal.multiScenSimDateSimDate;
		if([self populateInputSet:self.accountContribStartDate 
			          withInput:msDate.accountContribStartDate]) { return; }
			
		if([self populateInputSet:self.accountDeferredWithdrawalDate 
			          withInput:msDate.accountDeferredWithdrawalDate]) { return; }
			
		if([self populateInputSet:self.assetPurchaseDate 
			          withInput:msDate.assetPurchaseDate]) { return; }
			
		if([self populateInputSet:self.cashFlowStartDate 
			          withInput:msDate.cashFlowStartDate]) { return; }
			
		if([self populateInputSet:self.loanOrigDate 
			          withInput:msDate.loanOrigDate]) { return; }

	}

}

-(id)initWithUserScen:(UserScenario*)userScen
{
	self = [super init];
	if(self)
	{

		// MultiScenarioInputValue inverse relationships
		self.accountContribEnabled = [[[NSMutableSet alloc] init] autorelease];
		self.accountDividendEnabled = [[[NSMutableSet alloc] init] autorelease];
		self.accountContribRepeatFrequency = [[[NSMutableSet alloc] init] autorelease];
		self.accountDeferredWithdrawalsEnabled = [[[NSMutableSet alloc] init] autorelease];
		self.accountWithdrawalPriority = [[[NSMutableSet alloc] init] autorelease];

		self.loanDownPmtEnabled = [[[NSMutableSet alloc] init] autorelease];
		self.loanDownPmtPercent = [[[NSMutableSet alloc] init] autorelease];
		self.loanDuration = [[[NSMutableSet alloc] init] autorelease];
		self.loanEnabled = [[[NSMutableSet alloc] init] autorelease];
		self.loanExtraPmtEnabled = [[[NSMutableSet alloc] init] autorelease];

		self.cashFlowEnabled = [[[NSMutableSet alloc] init] autorelease];
		self.taxEnabled = [[[NSMutableSet alloc] init] autorelease];
		self.assetEnabled = [[[NSMutableSet alloc] init] autorelease];
		

		// MultiScenarioAmount inverse relationships
		self.accountContribAmount = [[[NSMutableSet alloc] init] autorelease];
		self.assetCost = [[[NSMutableSet alloc] init] autorelease];
		self.taxExemptionAmt = [[[NSMutableSet alloc] init] autorelease];
		self.taxStdDeductionAmt = [[[NSMutableSet alloc] init] autorelease];
		self.cashFlowAmount = [[[NSMutableSet alloc] init] autorelease];
		self.cashFlowRepeatFrequency = [[[NSMutableSet alloc] init] autorelease];
		self.loanCost = [[[NSMutableSet alloc] init] autorelease];
		self.loanExtraPmtAmt = [[[NSMutableSet alloc] init] autorelease];

		// MultiScenarioGrowthRate inverse relationships		
		self.accountContribGrowthRate = [[[NSMutableSet alloc] init] autorelease];
		self.accountInterestRate = [[[NSMutableSet alloc] init] autorelease];
		self.accountDividendRate = [[[NSMutableSet alloc] init] autorelease];
		self.assetApprecRate = [[[NSMutableSet alloc] init] autorelease];
		self.taxExemptionGrowthRate = [[[NSMutableSet alloc] init] autorelease];
		self.taxStdDeductionGrowthRate = [[[NSMutableSet alloc] init] autorelease];
		self.cashFlowAmountGrowthRate = [[[NSMutableSet alloc] init] autorelease];
		self.loanCostGrowthRate = [[[NSMutableSet alloc] init] autorelease];
		self.loanExtraPmtGrowthRate = [[[NSMutableSet alloc] init] autorelease];
		self.loanInterestRate = [[[NSMutableSet alloc] init] autorelease];
		
		// MultiScenarioPercent inverse relationships
		self.accountDividendReinvestPercent = [[[NSMutableSet alloc] init] autorelease];
		
		// MultiScenarioSimEndDate inverse relationships
		self.accountContribEndDate = [[[NSMutableSet alloc] init] autorelease];
		self.assetSaleDate = [[[NSMutableSet alloc] init] autorelease];
		self.cashFlowEndDate = [[[NSMutableSet alloc] init] autorelease];
		self.loanEarlyPayoff = [[[NSMutableSet alloc] init] autorelease];
		self.loanDeferPayment = [[[NSMutableSet alloc] init] autorelease];

		// MultiScenarioSimDate inverse relationships
		self.accountContribStartDate = [[[NSMutableSet alloc] init] autorelease];
		self.accountDeferredWithdrawalDate = [[[NSMutableSet alloc] init] autorelease];
		self.assetPurchaseDate = [[[NSMutableSet alloc] init] autorelease];
		self.cashFlowStartDate = [[[NSMutableSet alloc] init] autorelease];
		self.loanOrigDate = [[[NSMutableSet alloc] init] autorelease];

		
		NSLog(@"Backtracing inverse relationships to identify values changed under scenario");
		for (ScenarioValue *scenVal in userScen.scenarioValueScenario)
		{
			[self resolveOneScenarioValInput:scenVal];
			
		} // for each ScenarioValue
		
		
	}
	return self;
}



-(id)init
{
	assert(0); // must call init with userScen
	return nil;
}

-(void)dealloc
{
	
	// MultiScenarioInputValue inverse relationships
	[accountContribEnabled release];
	[accountDividendEnabled release];
	[accountContribRepeatFrequency release];
	[accountDeferredWithdrawalsEnabled release];
	[accountWithdrawalPriority release];

	[loanDownPmtEnabled release];
	[loanDownPmtPercent release];
	[loanDuration release];
	[loanEnabled release];
	[loanExtraPmtEnabled release];


	[cashFlowEnabled release];
	[cashFlowRepeatFrequency release];
	[taxEnabled release];
	[assetEnabled release];
	
	// MultiScenarioAmount inverse relationships	
	[accountContribAmount release];
	[assetCost release];
	[taxExemptionAmt release];
	[taxStdDeductionAmt release];
	[cashFlowAmount release];
	[loanCost release];
	[loanExtraPmtAmt release];

	// MultiScenarioGrowthRate inverse relationships	
	[accountContribGrowthRate release];
	[accountInterestRate release];
	[accountDividendRate release];
	[assetApprecRate release];
	[taxExemptionGrowthRate release];
	[taxStdDeductionGrowthRate release];
	[cashFlowAmountGrowthRate release];
	[loanCostGrowthRate release];
	[loanExtraPmtGrowthRate release];
	[loanInterestRate release];
	
	// MultiScenarioPercent  inverse relationships
	[accountDividendReinvestPercent release];

	// MultiScenarioSimEndDate inverse relationships	
	[accountContribEndDate release];
	[assetSaleDate release];
	[cashFlowEndDate release];
	[loanEarlyPayoff release];
	[loanDeferPayment release];

	// MultiScenarioSimDate inverse relationships
	[accountContribStartDate  release];
	[accountDeferredWithdrawalDate release];
	[assetPurchaseDate  release];
	[cashFlowStartDate  release];
	[loanOrigDate  release];
	
	[super dealloc];


}



@end
