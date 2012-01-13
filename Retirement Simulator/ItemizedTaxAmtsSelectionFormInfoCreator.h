//
//  ItemizedTaxAmtsSelectionFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@class ItemizedTaxAmtsInfo;

@interface ItemizedTaxAmtsSelectionFormInfoCreator : NSObject <FormInfoCreator> {
    @private
		ItemizedTaxAmtsInfo *itemizedTaxAmtsInfo;
		BOOL isForNewObject;
}

-(id)initWithItemizedTaxAmtsInfo:(ItemizedTaxAmtsInfo*)theItemizedTaxAmtsInfo
	andIsForNewObject:(BOOL)forNewObject;

@property(nonatomic,retain) ItemizedTaxAmtsInfo *itemizedTaxAmtsInfo;
@property BOOL isForNewObject;

@end
