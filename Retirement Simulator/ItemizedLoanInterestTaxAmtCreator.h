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

@interface ItemizedLoanInterestTaxAmtCreator : NSObject <ItemizedTaxAmtCreator> {
    @private
		LoanInput *loan;
		NSString *label;
}

@property(nonatomic,retain) LoanInput *loan;
@property(nonatomic,retain) NSString *label;

-(id)initWithLoan:(LoanInput*)theLoan andLabel:(NSString*)theLabel;

@end
