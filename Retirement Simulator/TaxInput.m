//
//  TaxInput.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TaxInput.h"
#import "ItemizedTaxAmts.h"
#import "MultiScenarioAmount.h"
#import "MultiScenarioGrowthRate.h"
#import "MultiScenarioInputValue.h"
#import "TaxBracket.h"
#import "InputVisitor.h"
#import "LocalizationHelper.h"

NSString * const TAX_INPUT_ENTITY_NAME = @"TaxInput";
NSString * const TAX_INPUT_DEFAULT_ICON_NAME = @"piggy.png";

@implementation TaxInput


@dynamic exemptionAmt;
@dynamic exemptionGrowthRate;
@dynamic itemizedAdjustments;
@dynamic itemizedCredits;
@dynamic itemizedDeductions;
@dynamic itemizedIncomeSources;
@dynamic stdDeductionAmt;
@dynamic stdDeductionGrowthRate;
@dynamic taxBracket;
@dynamic taxEnabled;





-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
    [inputVisitor visitTax:self];
}


-(NSString*)inlineInputType
{
	return LOCALIZED_STR(@"INPUT_TAX_INLINE_INPUT_TYPE");
}

-(NSString*)inputTypeTitle
{
	return LOCALIZED_STR(@"INPUT_TAX_TITLE");
}


@end
