//
//  AcctBalanceXYPlotDataGenerator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YearValXYPlotDataGenerator.h"

@class Account;

@interface AcctBalanceXYPlotDataGenerator : NSObject <YearValXYPlotDataGenerator> {
    @private
		Account *account;
}

@property(nonatomic,retain) Account *account;

-(id)initWithAccount:(Account*)theAccount;

@end
