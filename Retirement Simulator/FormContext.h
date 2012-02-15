//
//  FormContext.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataModelController;

@interface FormContext : NSObject {
    @private
		UIViewController *parentController;
		DataModelController *dataModelController;
}

@property(nonatomic,retain) DataModelController *dataModelController;
@property(nonatomic,assign) UIViewController *parentController;

-(id)initWithParentController:(UIViewController*)theParentController
	andDataModelController:(DataModelController*)theDataModelController;

@end
