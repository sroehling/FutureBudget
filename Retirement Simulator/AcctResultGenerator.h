//
//  AcctResultGenerator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YearValXYPlotDataGenerator.h"

@class Account;

@interface AcctResultGenerator : NSObject <YearValXYPlotDataGenerator> {
    @private
		Account *account;
}

@property(nonatomic,retain) Account *account;

-(id)initWithAccount:(Account*)theAccount;

@end
