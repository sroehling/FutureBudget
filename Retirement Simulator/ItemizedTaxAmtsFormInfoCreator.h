//
//  ItemizedTaxAmtsFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@class ItemizedTaxAmtsInfo;

@interface ItemizedTaxAmtsFormInfoCreator : NSObject <FormInfoCreator>  {
    @private
		ItemizedTaxAmtsInfo *itemizedTaxAmtsInfo;
		BOOL isForNewObject;
}

-(id)initWithItemizedTaxAmtsInfo:(ItemizedTaxAmtsInfo*)theItemizedTaxAmtsInfo
	andIsForNewObject:(BOOL)forNewObject;

@property(nonatomic,retain) ItemizedTaxAmtsInfo *itemizedTaxAmtsInfo;
@property BOOL isForNewObject;

@end
