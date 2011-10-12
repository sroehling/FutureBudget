//
//  ItemizedTaxAmtVisitor.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IncomeItemizedTaxAmt;

@protocol ItemizedTaxAmtVisitor <NSObject>

-(void)visitIncomeItemizedTaxAmt:(IncomeItemizedTaxAmt*)itemizedTaxAmt;

@end
