//
//  MultiScenarioSimEndDate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const MULTI_SCEN_SIM_END_DATE_ENTITY_NAME;
extern NSString * const MULTI_SCEN_SIM_END_DATE_SIM_DATE_KEY;

@class MultiScenarioInputValue;

@class Account;
@class AssetInput;
@class CashFlowInput;
@class LoanInput;

@interface MultiScenarioSimEndDate : NSManagedObject {
@private
}
@property (nonatomic, retain) MultiScenarioInputValue * simDate;

// These properties retain a single fixed
// date value the user can select. If the user then
// selects a milestone date, he/she can come back and select
// the same fixed date, rather than the fixed
// date reverting back to zero.
@property (nonatomic, retain) MultiScenarioInputValue * defaultFixedRelativeEndDate;
@property (nonatomic, retain) MultiScenarioInputValue * defaultFixedSimDate;


// Inverse relationships
@property (nonatomic, retain) Account * accountContribEndDate;
@property (nonatomic, retain) AssetInput * assetSaleDate;
@property (nonatomic, retain) CashFlowInput * cashFlowEndDate;
@property(nonatomic,retain) LoanInput *loanEarlyPayoffDate;


@end
