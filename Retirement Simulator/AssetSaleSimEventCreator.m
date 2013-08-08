//
//  AssetSaleSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AssetSaleSimEventCreator.h"

#import "AssetInput.h"
#import "SimInputHelper.h"
#import "SimParams.h"
#import "AssetSimInfo.h"
#import "DateHelper.h"
#import "AssetSaleSimEvent.h"

@implementation AssetSaleSimEventCreator

- (void)resetSimEventCreation
{
	eventCreated = false;
}

- (SimEvent*)nextSimEvent
{
	if(eventCreated)
	{
		return nil;
	}
	else
	{
		eventCreated = true;
		
		if([self.assetSimInfo ownedForAtLeastOneDay] && [self.assetSimInfo soldAfterSimStart])
		{
			// We only need to process/simulate the asset purchase, it the purchase date 
			// is in the future w.r.t. to the simulation start date.
			AssetSaleSimEvent *saleEvent = 
				[[[AssetSaleSimEvent alloc]initWithAssetSimInfo:self.assetSimInfo 
					andSimEventCreator:self 
					andEventDate:[self.assetSimInfo saleDate]] autorelease];
            saleEvent.tieBreakPriority = SIM_EVENT_TIE_BREAK_PRIORITY_ASSET_SALE;
			return saleEvent;
		}
		else
		{
			// Purchase date is in the past w.r.t. the simulatino start date, so 
			// we don't need to create an event for it.
			return nil;
		}
	}
}

@end
