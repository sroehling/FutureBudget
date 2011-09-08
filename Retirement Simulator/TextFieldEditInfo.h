//
//  TextFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FieldEditInfo.h"
#import "ManagedObjectFieldEditInfo.h"
#import "TextFieldCell.h"

@interface TextFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
}


+ (TextFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
							 andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder;
@end
