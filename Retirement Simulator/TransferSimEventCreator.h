//
//  TransferSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CashFlowSimEventCreator.h"

@class TransferSimInfo;

@interface TransferSimEventCreator : CashFlowSimEventCreator {
    @private
		TransferSimInfo *transferInfo;
}

@property(nonatomic,retain) TransferSimInfo *transferInfo;

- (id)initWithTransferSimInfo:(TransferSimInfo*)theTransferInfo;


@end
