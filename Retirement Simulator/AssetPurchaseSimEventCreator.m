//
//  AssetPurchaseSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AssetPurchaseSimEventCreator.h"

#import "InterestBearingWorkingBalance.h"
#import "AssetInput.h"
#import "AssetSimInfo.h"
#import "SimInputHelper.h"
#import "SimParams.h"
#import "DateHelper.h"
#import "AssetPurchaseSimEvent.h"


@implementation AssetPurchaseSimEventCreator

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
		
		if([self.assetSimInfo ownedForAtLeastOneDay] && [self.assetSimInfo purchasedAfterSimStart])		
		{
			// We only need to process/simulate the asset purchase, it the purchase date 
			// is in the future w.r.t. to the simulation start date.
			AssetPurchaseSimEvent *purchaseEvent = 
				[[[AssetPurchaseSimEvent alloc]initWithAssetSimInfo:self.assetSimInfo andSimEventCreator:self 
					andEventDate:[self.assetSimInfo purchaseDate]] autorelease];
            purchaseEvent.tieBreakPriority = SIM_EVENT_TIE_BREAK_PRIORITY_ASSET_PURCHASE;
			return purchaseEvent;
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
