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
@class DataModelController;

@interface InputListInputDescriptionCreator : NSObject <InputVisitor> {
	@private
		NSString *generatedDesc;
		DataModelController *dataModelController;
		
    
}

@property(nonatomic,retain) NSString *generatedDesc;
@property(nonatomic,retain) DataModelController *dataModelController;

- (NSString*)descripionForInput:(Input*)theInput;

-(id)initWithDataModelController:(DataModelController*)theDataModelController;

@end
