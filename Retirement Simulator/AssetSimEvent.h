//
//  AssetSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEvent.h"

@class AssetSimInfo;
@protocol SimEventCreator;

@interface AssetSimEvent : SimEvent {
    @private
		AssetSimInfo *assetSimInfo;
}

@property (nonatomic,retain) AssetSimInfo *assetSimInfo;

-(id)initWithAssetSimInfo:(AssetSimInfo*)assetSimInfo 
	andSimEventCreator:(id<SimEventCreator>)eventCreator andEventDate:(NSDate*)eventDate;

@end
