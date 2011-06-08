//
//  VariableValueRuntimeInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VariableValueRuntimeInfo : NSObject {
	@private
		NSString *entityName;
		NSNumberFormatter *valueFormatter;
}

@property(nonatomic,retain) NSString *entityName;
@property(nonatomic,retain) NSNumberFormatter *valueFormatter;

- (id) initWithEntityName:(NSString*)entityName andFormatter:(NSNumberFormatter*)formatter;

@end
