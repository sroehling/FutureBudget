//
//  FieldEditViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FieldInfo;

@interface FieldEditViewController : UIViewController {
    FieldInfo *fieldInfo;
}

@property(nonatomic,retain) FieldInfo *fieldInfo;

- (id) initWithNibName:(NSString *)nibName andFieldInfo:(FieldInfo*)theFieldInfo;
- (void) commidFieldEdit;
- (void) initFieldUI;

@end
