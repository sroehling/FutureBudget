//
//  AssetSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEventCreator.h"

@class AssetSimInfo;


@interface AssetSimEventCreator : NSObject  <SimEventCreator> { 
	@private
		AssetSimInfo *assetSimInfo;
}

@property(nonatomic,retain) AssetSimInfo *assetSimInfo;

-(id)initWithAssetSimInfo:(AssetSimInfo*)theAssetSimInfo;

@end
