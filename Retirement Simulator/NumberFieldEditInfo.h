//
//  NumberFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"
#import "ManagedObjectFieldEditInfo.h"

@class NumberFieldCell;
@class FieldInfo;
@class NumberFieldValidator;

@interface NumberFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
@private  
    NSNumberFormatter *numberFormatter;
	NSManagedObject *objectForDelete;
	NumberFieldValidator *validator;
	NumberFieldCell *numberCell;

}


+ (NumberFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
                               andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder
                        andNumberFormatter:(NSNumberFormatter*)numFormatter
						andValidator:(NumberFieldValidator*)theValidator;
					 
- (id) initWithFieldInfo:(FieldInfo *)theFieldInfo 
      andNumberFormatter:(NSNumberFormatter*)numFormatter
	  andValidator:(NumberFieldValidator*)theValidator;
	  
@property(nonatomic,retain) NSManagedObject *objectForDelete;
@property (nonatomic, retain) NSNumberFormatter *numberFormatter;
@property(nonatomic,retain) NumberFieldValidator *validator;
@property(nonatomic,retain)	NumberFieldCell *numberCell;

@end
