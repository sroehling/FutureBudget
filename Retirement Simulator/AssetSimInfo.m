//
//  AssetSimInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AssetSimInfo.h"
#import "SimParams.h"
#import "AssetInput.h"
#import "InterestBearingWorkingBalance.h"
#import "SimInputHelper.h"
#import "DateHelper.h"
#import "VariableRateCalculator.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "InterestBearingWorkingBalance.h"
#import "MultiScenarioGrowthRate.h"
#import "MultiScenarioAmount.h"
#import "MultiScenarioSimDate.h"
#import "MultiScenarioSimEndDate.h"
#import "InputValDigestSummation.h"
#import "InputValDigestSummations.h"
#import "DigestEntryProcessingParams.h"
#import "WorkingBalanceMgr.h"

@implementation AssetSimInfo

@synthesize assetValue;
@synthesize asset;
@synthesize simParams;
@synthesize purchaseDate;
@synthesize saleDate;
@synthesize sumGainsLosses;
@synthesize assetSaleIncome;
@synthesize assetPurchaseExpense;

- (void)dealloc
{
	[assetValue release];
	[asset release];
	[simParams release];
	[purchaseDate release];
	[saleDate release];
	
	[sumGainsLosses release];
	[assetSaleIncome release];
	[assetPurchaseExpense release];
	
	[super dealloc];
}



-(id)initWithAsset:(AssetInput*)theAsset andSimParams:(SimParams*)theSimParams
{
	self = [super init];
	if(self)
	{
		assert(theSimParams != nil);
		self.simParams = theSimParams;
	
		assert(theAsset != nil);
		self.asset = theAsset;
		
		self.sumGainsLosses = [[[InputValDigestSummation alloc] init] autorelease];
		self.assetSaleIncome = [[[InputValDigestSummation alloc] init] autorelease];
		self.assetPurchaseExpense = [[[InputValDigestSummation alloc] init] autorelease];
		
		[theSimParams.digestSums addDigestSum:self.sumGainsLosses];
		[theSimParams.digestSums addDigestSum:self.assetSaleIncome];
		[theSimParams.digestSums addDigestSum:self.assetPurchaseExpense];
		
		self.purchaseDate = [SimInputHelper 
			multiScenFixedDate:self.asset.purchaseDate.simDate 
			andScenario:self.simParams.simScenario];
		assert(self.purchaseDate != nil);

		self.saleDate = [SimInputHelper 
			multiScenEndDate:self.asset.saleDate.simDate 
			withStartDate:self.asset.purchaseDate.simDate 
			andScenario:self.simParams.simScenario];
		assert(self.saleDate != nil);
		
		double startingAssetValue;		
		if([self purchasedAfterSimStart])
		{
			// An AssetPurchaseSimEventCreator will create an event
			// which increments the asset value to the purchase cost when
			// purchase is made.
			startingAssetValue = 0.0;
		}
		else
		{
			startingAssetValue = [SimInputHelper doubleVal:asset.startingValue];
		}
		VariableRateCalculator *apprecCalc = [DateSensitiveValueVariableRateCalculatorCreator 
			createVariableRateCalc:self.asset.apprecRate.growthRate 
			andStartDate:self.simParams.simStartDate andScenario:simParams.simScenario 
			andUseLoanAnnualRates:false];
		// TODO - Need to figure out where to handle taxableProceeds
		self.assetValue = [[[InterestBearingWorkingBalance alloc] 
			initWithStartingBalance:startingAssetValue andInterestRateCalc:apprecCalc 
			andWorkingBalanceName:self.asset.name andWithdrawPriority:WORKING_BALANCE_WITHDRAW_PRIORITY_MAX] autorelease];

	}
	return self;
}

- (double)purchaseCost
{
	double cost;
	if([self purchasedAfterSimStart])
	{
		// If the purchase is in the future, then we adjust it's price for the appreciation rate.
		cost = [SimInputHelper multiScenRateAdjustedValueAsOfDate:self.asset.cost.amount 
			andMultiScenRate:self.asset.apprecRate.growthRate asOfDate:[self purchaseDate] 
			sinceDate:self.simParams.simStartDate forScenario:self.simParams.simScenario];
	}
	else
	{
		// If the purchase was in the past, the purchase cost is assumed to be the unadjusted
		// value given by the user.
		cost = [SimInputHelper multiScenValueAsOfDate:self.asset.cost.amount 
			andDate:[self purchaseDate] andScenario:self.simParams.simScenario];
		
	}
	return cost;
}

-(void)processSale:(DigestEntryProcessingParams*)processingParams
{
	// Record the asset sale for tracking cash flow
	double saleValue = [self.assetValue 
		zeroOutBalanceAsOfDate:processingParams.currentDate];
	[self.assetSaleIncome adjustSum:saleValue onDay:processingParams.dayIndex];
	
	double purchaseCost  = [self purchaseCost];
	
	// gainOrLoss could be negative if the asset depreciated and is worth
	// less at the time of sale than purchase.
	double gainOrLoss = saleValue-purchaseCost;
	
	[self.sumGainsLosses adjustSum:gainOrLoss onDay:processingParams.dayIndex];
	
	[processingParams.workingBalanceMgr incrementCashBalance:saleValue 
			asOfDate:processingParams.currentDate];
}

-(bool)ownedForAtLeastOneDay
{
	NSDate *beginningOfPurchaseDate = [DateHelper beginningOfDay:self.purchaseDate];
	NSDate *begginningOfSaleDate = [DateHelper beginningOfDay:self.saleDate];
	if([DateHelper dateIsLater:begginningOfSaleDate otherDate:beginningOfPurchaseDate])
	{
		return true;
	}
	else
	{
		return false;
	}
}

-(bool)purchasedAfterSimStart
{
	if([DateHelper dateIsEqualOrLater:self.purchaseDate otherDate:self.simParams.simStartDate])
	{
		return true;
	}
	else
	{
		return false;
	}
}

- (bool)soldAfterSimStart
{
	if([DateHelper dateIsEqualOrLater:self.saleDate otherDate:self.simParams.simStartDate])
	{
		return true;
	}
	else
	{
		return false;
	}

}


-(id)init
{
	assert(0); // must call with asset and sim params
	return nil;
}


@end
