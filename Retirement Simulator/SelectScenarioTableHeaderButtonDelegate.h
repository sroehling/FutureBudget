//
//  SelectScenarioTableHeaderButtonDelegate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TableHeaderDisclosureButtonDelegate.h"


@interface SelectScenarioTableHeaderButtonDelegate : 
	NSObject <TableHeaderDisclosureButtonDelegate> {
    @private
		UIViewController *parentController;
}

@property(nonatomic,retain) UIViewController *parentController;

-(id)initWithParentController:(UIViewController*)parentController;

@end
