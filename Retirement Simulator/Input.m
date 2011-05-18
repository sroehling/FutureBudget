//
//  Input.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Input.h"


@implementation Input
@dynamic name,inputType;


-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    // no-op
}

@end
