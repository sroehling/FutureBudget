//
//  TransferEndpointSelectionFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StaticFieldEditInfo.h"

@class TransferEndpoint;
@class FormFieldWithSubtitleTableCell;

@interface TransferEndpointSelectionFieldEditInfo : NSObject <FieldEditInfo>
{
	@private
		TransferEndpoint *transferEndpoint;
		FormFieldWithSubtitleTableCell *endpointCell;

}

@property(nonatomic,retain) TransferEndpoint *transferEndpoint;
@property(nonatomic,retain) FormFieldWithSubtitleTableCell *endpointCell;

-(id)initWithTransferEndpoint:(TransferEndpoint*)theTransferEndpoint;

@end
