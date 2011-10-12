//
//  ItemizedTaxAmtSelectionFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@class ItemizedTaxAmtsInfo;

@interface ItemizedTaxAmtSelectionFormInfoCreator : NSObject <FormInfoCreator>  {
    @private
		ItemizedTaxAmtsInfo *itemizedTaxAmtsInfo;
}

@property(nonatomic,retain) ItemizedTaxAmtsInfo *itemizedTaxAmtsInfo;

-(id)initWithItemizedTaxAmtsInfo:(ItemizedTaxAmtsInfo*)theItemizedTaxAmtsInfo;

@end
