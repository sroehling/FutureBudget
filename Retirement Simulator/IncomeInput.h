//
//  IncomeInput.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CashFlowInput.h"

extern NSString * const INCOME_INPUT_ENTITY_NAME;
extern NSString * const INCOME_INPUT_DEFAULT_ICON_NAME;

@interface IncomeInput : CashFlowInput {
@private
}

// Inverse Relationship
@property (nonatomic, retain) NSSet* incomeItemizedTaxAmts;


@end
