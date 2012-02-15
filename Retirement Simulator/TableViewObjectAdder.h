//
//  TableViewObjectAdder.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FormContext;

@protocol TableViewObjectAdder <NSObject>

-(void)addObjectFromTableView:(FormContext*)parentContext;
-(BOOL)supportsAddOutsideEditMode;

@end
