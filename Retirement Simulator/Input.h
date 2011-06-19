//
//  Input.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol InputVisitor;

@interface Input : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString *inputType;

-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor;

-(NSString*)inlineInputType;
-(NSString*)inputTypeTitle;

@end
