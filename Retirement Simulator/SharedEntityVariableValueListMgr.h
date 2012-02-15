//
//  SharedEntityVariableValueListMgr.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VariableValueListMgr.h"
#import "FinishedAddingObjectListener.h"

@class DataModelController;

@interface SharedEntityVariableValueListMgr : NSObject <VariableValueListMgr,FinishedAddingObjectListener> {
    @private
		DataModelController *dataModelController;
		NSString *entityName;
}

- (id) initWithDataModelController:(DataModelController*)theDataModelController 
		andEntity:(NSString *)theEntityName;

@property(nonatomic,retain) NSString *entityName;
@property(nonatomic,retain) DataModelController *dataModelController;

@end
