//
//  ScenarioInputValBacktracer.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserScenario;

@interface ScenarioInputValBacktracer : NSObject {
    @private
		// MultiScenarioInputValue inverse relationships
		NSMutableSet *accountContribEnabled;
		NSMutableSet *accountContribRepeatFrequency;
		NSMutableSet *accountDeferredWithdrawalsEnabled;
		NSMutableSet *accountWithdrawalPriority;

		NSMutableSet *loanDownPmtEnabled;
		NSMutableSet *loanDownPmtPercent;
		NSMutableSet *loanDuration;
		NSMutableSet *loanEnabled;
		NSMutableSet *loanExtraPmtEnabled;
		NSMutableSet *loanExtraPmtFrequency;
	
		NSMutableSet *cashFlowEnabled;
		NSMutableSet *cashFlowRepeatFrequency;
		NSMutableSet *taxEnabled;
		NSMutableSet *assetEnabled;
		
		// MultiScenarioAmount inverse relationships
		NSMutableSet *accountContribAmount;
		NSMutableSet *assetCost;
		NSMutableSet *taxExemptionAmt;
		NSMutableSet *taxStdDeductionAmt;
		NSMutableSet *cashFlowAmount;
		NSMutableSet *loanCost;
		NSMutableSet *loanExtraPmtAmt;


		// MultiScenarioGrowthRate inverse relationships
		NSMutableSet *accountContribGrowthRate;
		NSMutableSet *accountInterestRate;
		NSMutableSet *assetApprecRate;
		NSMutableSet *taxExemptionGrowthRate;
		NSMutableSet *taxStdDeductionGrowthRate;
		NSMutableSet *cashFlowAmountGrowthRate;
		NSMutableSet *loanCostGrowthRate;
		NSMutableSet *loanExtraPmtGrowthRate;
		NSMutableSet *loanInterestRate;

		// MultiScenarioSimEndDate inverse relationships
		NSMutableSet *accountContribEndDate;
		NSMutableSet *assetSaleDate;
		NSMutableSet *cashFlowEndDate;


		// MultiScenarioSimDate inverse relationships
		NSMutableSet *accountContribStartDate;
		NSMutableSet *accountDeferredWithdrawalDate;
		NSMutableSet *assetPurchaseDate;
		NSMutableSet *cashFlowStartDate;
		NSMutableSet *loanOrigDate;


}

@property(nonatomic,retain) NSMutableSet *accountContribEnabled;
@property(nonatomic,retain) NSMutableSet *accountContribRepeatFrequency;
@property(nonatomic,retain) NSMutableSet *accountDeferredWithdrawalsEnabled;
@property(nonatomic,retain) NSMutableSet *accountWithdrawalPriority;

@property(nonatomic,retain) NSMutableSet *loanDownPmtEnabled;
@property(nonatomic,retain) NSMutableSet *loanDownPmtPercent;
@property(nonatomic,retain) NSMutableSet *loanDuration;
@property(nonatomic,retain) NSMutableSet *loanEnabled;
@property(nonatomic,retain) NSMutableSet *loanExtraPmtEnabled;
@property(nonatomic,retain) NSMutableSet *loanExtraPmtFrequency;

@property(nonatomic,retain) NSMutableSet *cashFlowEnabled;
@property(nonatomic,retain) NSMutableSet *cashFlowRepeatFrequency;
@property(nonatomic,retain) NSMutableSet *taxEnabled;
@property(nonatomic,retain) NSMutableSet *assetEnabled;


// MultiScenarioAmount inverse relationships
@property(nonatomic,retain) NSMutableSet *accountContribAmount;
@property(nonatomic,retain) NSMutableSet *assetCost;
@property(nonatomic,retain) NSMutableSet *taxExemptionAmt;
@property(nonatomic,retain) NSMutableSet *taxStdDeductionAmt;
@property(nonatomic,retain) NSMutableSet *cashFlowAmount;
@property(nonatomic,retain) NSMutableSet *loanCost;
@property(nonatomic,retain) NSMutableSet *loanExtraPmtAmt;

// MultiScenarioGrowthRate inverse relationships
@property(nonatomic,retain) NSMutableSet *accountContribGrowthRate;
@property(nonatomic,retain) NSMutableSet *accountInterestRate;
@property(nonatomic,retain) NSMutableSet *assetApprecRate;
@property(nonatomic,retain) NSMutableSet *taxExemptionGrowthRate;
@property(nonatomic,retain) NSMutableSet *taxStdDeductionGrowthRate;
@property(nonatomic,retain) NSMutableSet *cashFlowAmountGrowthRate;
@property(nonatomic,retain) NSMutableSet *loanCostGrowthRate;
@property(nonatomic,retain) NSMutableSet *loanExtraPmtGrowthRate;
@property(nonatomic,retain) NSMutableSet *loanInterestRate;

// MultiScenarioSimEndDate inverse relationships
@property(nonatomic,retain) NSMutableSet *accountContribEndDate;
@property(nonatomic,retain) NSMutableSet *assetSaleDate;
@property(nonatomic,retain) NSMutableSet *cashFlowEndDate;

// MultiScenarioSimDate inverse relationships
@property(nonatomic,retain) NSMutableSet *accountContribStartDate;
@property(nonatomic,retain) NSMutableSet *accountDeferredWithdrawalDate;
@property(nonatomic,retain) NSMutableSet *assetPurchaseDate;
@property(nonatomic,retain) NSMutableSet *cashFlowStartDate;
@property(nonatomic,retain) NSMutableSet *loanOrigDate;

-(id)initWithUserScen:(UserScenario*)userScen;

@end
