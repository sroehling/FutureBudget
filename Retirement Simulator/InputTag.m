//
//  InputTag.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/15/13.
//
//

#import "InputTag.h"
#import "Input.h"

NSString * const INPUT_TAG_ENTITY_NAME = @"InputTag";
NSString * const INPUT_TAG_NAME_KEY = @"tagName";
NSUInteger const INPUT_TAG_NAME_MAX_LENGTH = 32;
NSString * const INPUT_TAG_NOTES_KEY = @"notes";

@implementation InputTag

@dynamic tagName;
@dynamic notes;
@dynamic taggedInputs;

@end
