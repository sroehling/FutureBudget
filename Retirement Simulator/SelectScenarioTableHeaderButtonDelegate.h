//
//  SelectScenarioTableHeaderButtonDelegate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TableHeaderDisclosureButtonDelegate.h"

@class FormContext;

@interface SelectScenarioTableHeaderButtonDelegate : 
	NSObject <TableHeaderDisclosureButtonDelegate> {
    @private
		FormContext *formContext;
}

@property(nonatomic,retain) FormContext *formContext;;

-(id)initWithFormContext:(FormContext*)theFormContext;

@end
