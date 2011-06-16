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
		NSString *valueTitle;
		NSString *valueVerb;
		NSString *periodDesc;
}

@property(nonatomic,retain) NSString *entityName;
@property(nonatomic,retain) NSNumberFormatter *valueFormatter;
@property(nonatomic,retain) NSString *valueTitle;
@property(nonatomic,retain) NSString *valueVerb;
@property(nonatomic,retain) NSString *periodDesc;

- (id) initWithEntityName:(NSString*)entityName andFormatter:(NSNumberFormatter*)formatter
	andValueTitle:(NSString*)title andValueVerb:(NSString*)verb
	andPeriodDesc:(NSString*)thePeriodDesc;
	
- (NSString *)inlinePeriodDesc;

@end
