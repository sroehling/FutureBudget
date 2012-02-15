//
//  FieldEditTableViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FieldInfo.h"

@class DataModelController;

@interface FieldEditTableViewController : UITableViewController {
    FieldInfo *fieldInfo;
	DataModelController *dataModelController;
}

@property(nonatomic,retain) FieldInfo *fieldInfo;
@property(nonatomic,retain) DataModelController *dataModelController;

- (id) initWithFieldInfo:(FieldInfo*)theFieldInfo
	andDataModelController:(DataModelController*)theDataModelController;
- (void) commidFieldEdit;
- (void) initFieldUI;

@end
