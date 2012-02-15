//
//  SingleScenarioRelativeEndDateFieldInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ManagedObjectFieldInfo.h"

@class DataModelController;

@interface SingleScenarioRelativeEndDateFieldInfo : ManagedObjectFieldInfo {
    @private
		DataModelController *dataModelController;
}

@property(nonatomic,retain) DataModelController *dataModelController;


-(id)initWithDataModelController:(DataModelController*)theDataModelController 
		andManagedObject:(NSManagedObject*)theManagedObject
               andFieldKey:(NSString*)theFieldKey
             andFieldLabel:(NSString*)theFieldLabel
			 andFieldPlaceholder:(NSString *)thePlaceholder;

@end
