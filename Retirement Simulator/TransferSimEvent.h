//
//  TransferSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEvent.h"

@class TransferSimInfo;

@interface TransferSimEvent : SimEvent {
	@private
		TransferSimInfo *transferInfo;
		double transferAmount;
}

@property(nonatomic,retain) TransferSimInfo *transferInfo;
@property double transferAmount;

@end
