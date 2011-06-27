//
//  VariableDate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface VariableDate : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate *date;

- (NSString *)inlineDescription:(NSDateFormatter*)withFormat;
- (NSString *)dateLabel;

@end
