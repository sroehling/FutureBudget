//
//  FieldEditViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ManagedObjectFieldInfo.h"

@interface FieldEditViewController : UIViewController {
    ManagedObjectFieldInfo *fieldInfo;
}

@property(nonatomic,retain) ManagedObjectFieldInfo *fieldInfo;

- (id) initWithNibName:(NSString *)nibName andFieldInfo:(ManagedObjectFieldInfo*)theFieldInfo;
- (void) commidFieldEdit;
- (void) initFieldUI;

@end
