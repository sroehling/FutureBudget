//
//  ItemizedLoanTaxFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@class LoanInput;

@interface ItemizedLoanTaxFormInfoCreator : NSObject <FormInfoCreator> {
    @private
		LoanInput *loan;
		BOOL isForNewObject;

}

@property(nonatomic,retain) LoanInput *loan;
@property BOOL isForNewObject;

-(id)initWithLoan:(LoanInput*)theLoan andIsForNewObject:(BOOL)forNewObject;
@end
