//
//  TransferInput.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransferInput.h"
#import "InputVisitor.h"
#import "LocalizationHelper.h"

NSString * const TRANSFER_INPUT_ENTITY_NAME = @"TransferInput";
NSString * const TRANSFER_INPUT_FROM_ENDPOINT_KEY = @"fromEndpoint";
NSString * const TRANSFER_INPUT_TO_ENDPOINT_KEY = @"toEndpoint";


@implementation TransferInput
@dynamic fromEndpoint;
@dynamic toEndpoint;

-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
    [inputVisitor visitTransfer:self];
}

- (NSString*)inlineInputType
{
	return LOCALIZED_STR(@"INPUT_TYPE_TRANSFER_INLINE");
}

-(NSString*)inputTypeTitle
{
	return LOCALIZED_STR(@"INPUT_TYPE_TRANSFER_TITLE");
}



@end
