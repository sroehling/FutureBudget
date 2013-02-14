//
//  InputListObjectAdder.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TableViewObjectAdder.h"
#import "SelectableObjectCreationTableViewController.h"

@class DataModelController;
@class FormContext;

@interface InputListObjectAdder : NSObject <TableViewObjectAdder,ObjectSelectedForCreationDelegate>
{
	@private
		DataModelController *dmcForNewInputs;
		FormContext *currentContext;
}

@property(nonatomic,retain) DataModelController *dmcForNewInputs;
@property(nonatomic,retain) FormContext *currentContext;

@end
