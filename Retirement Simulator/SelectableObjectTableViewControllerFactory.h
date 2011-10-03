//
//  SelectableObjectTableViewControllerFactory.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GenericTableViewFactory.h"

@protocol FormInfoCreator;
@class FieldInfo;

@interface SelectableObjectTableViewControllerFactory : NSObject <GenericTableViewFactory> {
    @private
		id<FormInfoCreator> formInfoCreator;
		FieldInfo *assignedField;
}

@property(nonatomic,retain) FieldInfo *assignedField;
@property(nonatomic,retain) id<FormInfoCreator> formInfoCreator;

-(id)initWithFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator
	andAssignedField:(FieldInfo*)theFieldInfo;

@end
