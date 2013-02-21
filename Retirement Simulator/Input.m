//
//  Input.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Input.h"

NSString * const INPUT_NAME_KEY = @"name";
NSString * const INPUT_NOTES_KEY = @"notes";
NSString * const INPUT_ICON_IMAGE_NAME_KEY = @"iconImageName";
NSString * const INPUT_TAGS_KEY = @"tags";
NSString * const INPUT_ENTITY_NAME = @"Input";

@implementation Input

@dynamic name;
@dynamic notes;
@dynamic iconImageName;
@dynamic tags;


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
