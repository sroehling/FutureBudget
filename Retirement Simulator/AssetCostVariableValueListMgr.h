//
//  AssetCostVariableValueListMgr.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VariableValueListMgr.h"

@class AssetInput;

@interface AssetCostVariableValueListMgr : NSObject <VariableValueListMgr> {
    @private
		AssetInput *asset;
}

-(id)initWithAsset:(AssetInput*)theAsset;

@property(nonatomic,retain) AssetInput *asset;

@end
