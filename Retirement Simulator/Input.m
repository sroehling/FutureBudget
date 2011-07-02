//
//  Input.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Input.h"


@implementation Input
@dynamic name;
@dynamic inputType;


-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    // no-op
}

-(NSString*)inlineInputType
{
	assert(0); // must be overridden
	return nil;
}

-(NSString*)inputTypeTitle
{
	assert(0);
	return nil;
}



@end
