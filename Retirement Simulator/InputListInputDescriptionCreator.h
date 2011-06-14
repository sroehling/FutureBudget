//
//  InputListInputDescriptionCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InputVisitor.h"

@class Input;


@interface InputListInputDescriptionCreator : NSObject <InputVisitor> {
	@private
		NSString *generatedDesc;
    
}

@property(nonatomic,retain) NSString *generatedDesc;

- (NSString*)descripionForInput:(Input*)theInput;

@end
