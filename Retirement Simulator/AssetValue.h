//
//  AssetValue.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "VariableValue.h"

extern NSString * const ASSET_VALUE_ENTITY_NAME;

@interface AssetValue : VariableValue {
@private
}

@property (nonatomic, retain) NSSet* assetGainItemizedTaxAmts;


@end
