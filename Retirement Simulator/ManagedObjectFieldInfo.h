//
//  ManagedObjectFieldInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ManagedObjectFieldInfo : NSObject {
    NSString *fieldLabel;
    NSString *fieldKey;
    NSManagedObject *managedObject;
}

-(id)initWithManagedObject:(NSManagedObject*)managedObject
               andFieldKey:(NSString*)fieldKey
             andFieldLabel:(NSString*)fieldLabel;


@property(nonatomic,retain) NSString *fieldLabel;
@property(nonatomic,retain) NSString *fieldKey;
@property(nonatomic,retain) NSManagedObject *managedObject;

- (id)getFieldValue;
- (void)setFieldValue:(id)newValue;


- (NSString*)textLabel;

@end
