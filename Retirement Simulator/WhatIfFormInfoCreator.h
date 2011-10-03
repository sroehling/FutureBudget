//
//  WhatIfFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@interface WhatIfFormInfoCreator : NSObject <FormInfoCreator> {} @end

@interface WhatIfInputsEnabledFormInfoCreator : NSObject <FormInfoCreator> {} @end
@interface WhatIfWithdrawalsFormInfoCreator : NSObject <FormInfoCreator> {} @end
@interface WhatIfAmountFormInfoCreator : NSObject <FormInfoCreator> {} @end
@interface WhatIfInvestmentReturnFormInfoCreator : NSObject <FormInfoCreator> {} @end
@interface WhatIfGrowthRateFormInfoCreator : NSObject <FormInfoCreator> {} @end
@interface WhatIfTaxesFormInfoCreator : NSObject <FormInfoCreator> {} @end

// TODO - Need to include a "what if" screen for manipulating the tax related inputs
// This can be done after 