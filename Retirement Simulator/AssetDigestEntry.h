//
//  AssetPurchaseDigestEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AssetSimInfo;

@interface AssetDigestEntry : NSObject {
	@private
		AssetSimInfo *assetInfo;
}

@property(nonatomic,retain) AssetSimInfo *assetInfo;

-(id)initWithAssetSimInfo:(AssetSimInfo*)theAssetInfo;

@end
