//
//  SectionHeaderAddButtonDelegate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SectionHeaderAddButtonDelegate <NSObject>

-(void)addButtonPressedInSectionHeader:(UIViewController*)parentView;

@end
