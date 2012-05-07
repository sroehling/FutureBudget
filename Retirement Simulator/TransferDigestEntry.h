//
//  TransferDigestEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CashFlowDigestEntry.h"
#import "DigestEntry.h"

@class TransferSimInfo;

@interface TransferDigestEntry : CashFlowDigestEntry <DigestEntry> {
	@private
		TransferSimInfo *transferInfo;
}

@property(nonatomic,retain) TransferSimInfo *transferInfo;

-(id)initWithTransferInfo:(TransferSimInfo*)theTransferInfo
	andTransferAmount:(double)transferAmount;

@end
