//
//  ItemizedTaxAmtObjectAdder.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TableViewObjectAdder.h"
#import "ItemizedTaxAmtsInfo.h"

@interface ItemizedTaxAmtObjectAdder : NSObject <TableViewObjectAdder> {
    @private
		ItemizedTaxAmtsInfo *itemizedTaxAmtsInfo;
}

@property(nonatomic,retain) ItemizedTaxAmtsInfo *itemizedTaxAmtsInfo;

-(id)initWithItemizedTaxAmtsInfo:(ItemizedTaxAmtsInfo*)theItemizedTaxAmtsInfo;

@end
