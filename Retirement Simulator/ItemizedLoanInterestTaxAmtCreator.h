//
//  ItemizedLoanInterestTaxAmtCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemizedTaxAmtCreator.h"

@class LoanInput;
@class FormContext;

@interface ItemizedLoanInterestTaxAmtCreator : NSObject <ItemizedTaxAmtCreator> {
    @private
		LoanInput *loan;
		NSString *label;
		FormContext *formContext;
}

@property(nonatomic,retain) LoanInput *loan;
@property(nonatomic,retain) NSString *label;
@property(nonatomic,retain) FormContext *formContext;

-(id)initWithFormContext:(FormContext*)theFormContext
	andLoan:(LoanInput*)theLoan andLabel:(NSString*)theLabel;

@end
