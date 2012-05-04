//
//  TransferEndpointSelectionFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@interface TransferEndpointSelectionFormInfoCreator : NSObject <FormInfoCreator> {
	@private
		NSString *formTitle;
}

@property(nonatomic,retain) NSString *formTitle;

-(id)initWithTitle:(NSString*)theFormTitle;

@end
