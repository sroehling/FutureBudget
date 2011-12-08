//
//  AssetValueXYPlotDataGenerator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AssetInput;

@interface AssetValueXYPlotDataGenerator : NSObject {
    @private
		AssetInput *assetInput;
}

@property(nonatomic,retain) AssetInput *assetInput;

-(id)initWithAsset:(AssetInput*)theAsset;

@end
