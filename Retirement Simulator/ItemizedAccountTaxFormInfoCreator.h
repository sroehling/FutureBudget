//
//  ItemizedAccountTaxFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@class Account;

@interface ItemizedAccountTaxFormInfoCreator : NSObject <FormInfoCreator> {
    @private
		Account *account;
		BOOL isForNewObject;
		
		// This class is used to show the itemization of an
		// account for different taxes. The boolean values
		// below configure which types of tax itemizations are
		// shown. These should be set after instantiating the
		// object to fully configure the object.
		BOOL showContributions;
		BOOL showWithdrawal;
		BOOL showInterest;

}

@property(nonatomic,retain) Account *account;
@property BOOL isForNewObject;
@property BOOL showContributions;
@property BOOL showWithdrawal;
@property BOOL showInterest;


-(id)initWithAcct:(Account*)theAccount andIsForNewObject:(BOOL)forNewObject;

@end
