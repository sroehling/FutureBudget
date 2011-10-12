//
//  ItemizedTaxAmt.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MultiScenarioInputValue;
@protocol ItemizedTaxAmtVisitor;

@interface ItemizedTaxAmt : NSManagedObject {
@private
}
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioApplicablePercent;

-(void)acceptVisitor:(id<ItemizedTaxAmtVisitor>)visitor;

@end
